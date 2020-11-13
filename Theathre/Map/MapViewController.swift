//
//  MapViewController.swift
//  Theathre
//
//  Created by Евгений on 08.11.2020.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAddress (_ address: String?)
}
 
class MapViewController: UIViewController {

    
    // MARK: - OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerViewUserLocationButton: UIButton!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var currentAddressLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var goButton: UIButton!
    
    
    // MARK: - VAR
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var theathre = Theathre()
    
    let annotationIdentifier  = "annotationIdentifier"
    let locationManager = CLLocationManager()
    let regionInMetters = 10_00.00
    var incomeSegueIdentifier = ""
    var theathreCoordinate: CLLocationCoordinate2D?
    
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        currentAddressLabel.text = ""
        setupMapView()
        mapView.delegate = self
        checkLocationServices()
    }
    

    // MARK: - METHOD SETUP NAVIGATION BAR
    private func setingUpNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            topItem.backBarButtonItem?.tintColor = .black
        }
        navigationItem.leftBarButtonItem = nil
    }
    
    
    // MARK: - SETUP PLACE MARK
    private func setupPlaceMark() {
        guard let location = theathre.location else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, completionHandler: { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = self.theathre.name
            annotation.subtitle = self.theathre.type
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            self.theathreCoordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        })
    }
    
    
    // MARK: - METHOD CHECK LOCATION SERVICES
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Определение местоположения отключено", message: "Для того чтоб включить определение геопозиции перейдите: Настройки -> Конфедециальность-> Местоположение")
            }
        }
    }
    
    
    // MARK: - METHOD SETUP LOCATION MANAGER
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    // MARK: - METHOD CHECK LOCATION AUTHORIZATION
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways: break
        case .authorizedWhenInUse: mapView.showsUserLocation = true
            if incomeSegueIdentifier == "getAddress" {
                showUserLocation()
            }
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showAlert(title: "Определение местоположения отключено", message: "Для того чтоб включить геопозицию перейдите: Настройки -> Theathre -> Местоположение")
        }
            break
        case .notDetermined: locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        @unknown default:
            print("New case is available")
        }
    }
    
    
    // MARK: - PRIVATE METHOD SHOW ALERT
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    
    
    // MARK: - PRIVATE METHOD GET CENTER LOCATION
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    // MARK: - PRIVATE METHOD SHOW USER LOCATION
    private func showUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters:     regionInMetters, longitudinalMeters: regionInMetters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    
    // MARK: - METHOD CENTER VIEW USER LOCATION
    @IBAction func centerViewUserLocation() {
     showUserLocation()
    }
    
    
    // MARK: - PRIVATE METHOD SETUP MAP VIEW
    private func setupMapView() {
        goButton.isHidden = true    
        if incomeSegueIdentifier == "showMap" {
            setupPlaceMark()
            mapPinImage.isHidden = true
            currentAddressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
    
    
    // MARK: - PRIVATE METHOD DONE BUTTON PRESSED
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegate?.getAddress(currentAddressLabel.text)
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - PRIVATE METHOD GO BUTTON PRESSED
    @IBAction func goButtonPressed() {
        getDirections()
    }
    
    
    // MARK: - PRIVATE METHOD GET DIRECTIONS
    private func getDirections() {
        
        guard let location = locationManager.location?.coordinate else { showAlert(title: "Ошибка", message: "Локация не определена")
            return }
        
        guard let request = createDirectionRequest(from: location) else { showAlert(title: "Ошибка", message: "Destination is not found")
            return }
        
        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler: { (response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let response = response else {
                self.showAlert(title: "Ошибка", message: "Directions is not available")
                return
            }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f", route.distance / 1000)
                
                let timeInterval = route.expectedTravelTime
                
                print("Расстояние до места: \(distance) км")
                print("Время в пути составит: \(timeInterval) сек.")
            }
        })
    }
    
  
    
    
    // MARK: - PRIVATE METHOD CREATE DIRECTION REQUEST
    private func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        guard let destinationCoordinate = theathreCoordinate else { return nil }
        
        let startinLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startinLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
}


// MARK: - EXTENSION MAP VIEW CONTROLLER
extension MapViewController: MKMapViewDelegate {
    
    
    // MARK: - EXTNESION METHOD VIEW FOR ANNOTATION
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
            
        }
        if let imageData = theathre.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
 
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(center, completionHandler: { (placemarks, error ) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let streetName =  placemark?.thoroughfare
            let buildNumber = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                if streetName != nil && buildNumber != nil {
                    self.currentAddressLabel.text = ("\(streetName!), \(buildNumber!)")
                } else if streetName != nil {
                    self.currentAddressLabel.text = "\(streetName!)"
                } else {
                    self.currentAddressLabel.text = ""
                }
               
            }
            

        })
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
            renderer.strokeColor = .blue
            
            return renderer
        }
    }
}


// MARK: - EXTNESION METHOD VIEW FOR ANNOTATION
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
