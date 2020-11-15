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
    
    
    // MARK: - VAR, LET
    let mapManagers = mapManager()
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var theathre = Theathre()
    let annotationIdentifier  = "annotationIdentifier"
    var incomeSegueIdentifier = ""
    var previousLocation: CLLocation? {
        didSet {
            mapManagers.startTrackingUserLocation(for: mapView,and: previousLocation) { (currentLocation) in
            self.previousLocation = currentLocation
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.mapManagers.showUserLocation(mapView: self.mapView)
                }
            }
        }
    }
    
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        currentAddressLabel.text = ""
        mapView.delegate = self
        setupMapView()

    }
    

    // MARK: - METHOD CENTER VIEW USER LOCATION
    @IBAction func centerViewUserLocation() {
        mapManagers.showUserLocation(mapView: mapView)
    }
    
        
    // MARK: - METHOD DONE BUTTON PRESSED
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegate?.getAddress(currentAddressLabel.text)
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - METHOD GO BUTTON PRESSED
    @IBAction func goButtonPressed() {
        mapManagers.getDirections(for: mapView, previousLocation: { (location) in
            self.previousLocation = location
        })
    }
    
    
    // MARK: - PRIVATE METHOD SETUP MAP VIEW
    private func setupMapView() {
        goButton.isHidden = true
        mapManagers.checkLocationServices(mapView: mapView, segueidentifier: incomeSegueIdentifier, closure: {
        mapManagers.locationManager.delegate = self })
        
        if incomeSegueIdentifier == "showMap" {
            mapManagers.setupPlaceMark(theathre: theathre, mapView: mapView)
            mapPinImage.isHidden = true
            currentAddressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
    
    
    // MARK: - PRIVATE METHOD SETUP NAVIGATION BAR
    private func setingUpNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            topItem.backBarButtonItem?.tintColor = .black
        }
        navigationItem.leftBarButtonItem = nil
    }

    
//    // MARK: - METHOD SETUP LOCATION MANAGER
//    private func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
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
        let center = mapManagers.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if incomeSegueIdentifier == "showMap" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManagers.showUserLocation(mapView: self.mapView)
        }
        }
        geocoder.cancelGeocode()
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
        mapManagers.checkLocationAuthorization(mapView: mapView, segueIdentifier: incomeSegueIdentifier)
    }
}
