//
//  RatingControll.swift
//  Theathre
//
//  Created by Евгений on 07.11.2020.
//

import UIKit

@IBDesignable  class RatingControll: UIStackView {
    
    
    // MARK: - PROPERTIES
    public var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
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
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        
        // MARK: - CALCULATE RATING OF THE SELECTED BUTTON
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    
    // MARK: - SETUP BUTTONS
    private func setupButtons() {
        
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        
        // MARK: - LOAD BUTTON IMAGE
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar.png", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar.png", in: bundle, compatibleWith: self.traitCollection)
        let hightlightStar = UIImage(named: "highlightedStar.png", in: bundle, compatibleWith: self.traitCollection)
        
        
        
        for _ in 0..<starCount {
            
            
            // MARK: - CREATE BUTTON
            let button = UIButton()
            
            
            // MARK: - BACKGROUND BUTTON
            button.backgroundColor = .red
            
            
            // MARK: - SET BUTTON IMAGE
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(hightlightStar, for: .highlighted)
            button.setImage(hightlightStar, for: [.highlighted, .selected])
            
            
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
        
        updateButtonSelectionState()
        
    }
    
    // MARK: - PRIVATE METHOD UPDATE BUTTON SELECTION STATE
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
