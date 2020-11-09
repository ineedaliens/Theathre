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
    var theathre: Theathre!
    
    
    // MARK: - METHOD VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlaceMark()
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
