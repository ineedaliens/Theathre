//
//  MainTableViewCell.swift
//  Theathre
//
//  Created by Евгений on 27.10.2020.
//

import UIKit
import Cosmos

class MainTableViewCell: UITableViewCell {
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var images: UIImageView! {
        didSet {
            images.layer.cornerRadius = images.frame.size.height / 2
            images.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.fillMode = .half
            cosmosView.settings.updateOnTouch = false
        }
    }
    
}
