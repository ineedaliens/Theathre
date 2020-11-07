//
//  RatingControll.swift
//  Theathre
//
//  Created by Евгений on 07.11.2020.
//

import UIKit

@IBDesignable   class RatingControll: UIStackView {

    
    // MARK: - PROPERTIES
    private var ratingButtons = [UIButton]()
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    public var rating = 0
    
    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    
    // MARK: - BUTTON ACTION
   @objc func ratingButtonTapped(button: UIButton) {
        print("Button pressed 👍")
    }
    
    
    // MARK: - SETUP BUTTONS
    private func setupButtons() {
        
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        
        
        for _ in 0..<starCount {
            
            
            // MARK: - CREATE BUTTON
            let button = UIButton()
            
            
            // MARK: - BACKGROUND BUTTON
            button.backgroundColor = .red
            
            
            // MARK: - ADD CONSTRAINTS
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            
            // MARK: - SETUP THE BUTTON ACTION
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            
            
            // MARK: - ADD BUTTON TO STACK VIEW
            addArrangedSubview(button)
            
            
            // MARK: - ADD NEW BUTTON ON THE RATING BUTTON ARRAY
            ratingButtons.append(button)
        }
    }
}
