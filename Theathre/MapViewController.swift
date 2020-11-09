//
//  MapViewController.swift
//  Theathre
//
//  Created by Евгений on 08.11.2020.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - METHOD SETUP NAVIGATION BAR
    private func setingUpNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            topItem.backBarButtonItem?.tintColor = .black
        }
        navigationItem.leftBarButtonItem = nil
    }
    
    
}
