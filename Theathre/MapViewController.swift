//
//  MapViewController.swift
//  Theathre
//
//  Created by Евгений on 08.11.2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    // MARK: - OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - VAR
    var theathre = Theathre()
    let annotationIdentifier  = "annotationIdentifier"
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlaceMark()
        mapView.delegate = self
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
