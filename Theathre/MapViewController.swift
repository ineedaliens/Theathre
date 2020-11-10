//
//  MapViewController.swift
//  Theathre
//
//  Created by Евгений on 08.11.2020.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    
    // MARK: - OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - VAR
    var theathre = Theathre()
    let annotationIdentifier  = "annotationIdentifier"
    let locationManager = CLLocationManager()
    
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlaceMark()
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
            let ac = UIAlertController(title: "Ошибка", message: "Геолокация выключина", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            ac.addAction(okAction)
            ac.addAction(cancelAction)
            self.present(ac, animated: true, completion: nil)
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
            break
        case .denied: let ac = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(ok)
            self.present(ac, animated: true, completion: nil)
            break
        case .notDetermined: locationManager.requestWhenInUseAuthorization()
            break
        case .restricted: let ac = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "", style: .default, handler: nil)
            ac.addAction(ok)
            self.present(ac, animated: true, completion: nil)
        @unknown default:
            print("New case is available")
        }
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
}


// MARK: - EXTNESION METHOD VIEW FOR ANNOTATION
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
