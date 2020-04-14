//
//  SectionButton.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 4/14/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit

class SectionButton: UIView {
    
    var sectionButton: UIButton = UIButton()
    
    lazy var sectionLabel: UILabel = {
        
        var sectionLabel = UILabel()
        sectionLabel.text = "Section"
        sectionLabel.textAlignment = .center
        sectionLabel.textColor = UIColor.PrimaryCrimson
        sectionLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: UIFont.labelFontSize)!)
        sectionLabel.adjustsFontForContentSizeCategory = true
        return sectionLabel
        
    }()
    
    var sectionVisibility = false {
        
        willSet (newVisibility) {
            
            if sectionVisibility != newVisibility {
                
                if newVisibility { // Section is now visible:
                    
                    self.backgroundColor = UIColor.PrimaryCrimson
                    sectionLabel.textColor = UIColor.AnalCream
                    
                } else { // Section is now hidden:
                    
                    self.backgroundColor = UIColor.AnalCream
                    sectionLabel.textColor = UIColor.PrimaryCrimson
                    
                }
                
            }
            
        }
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        
        self.backgroundColor = UIColor.AnalCream
        
        self.addSubview(sectionButton)
        sectionButton.translatesAutoresizingMaskIntoConstraints = false
        sectionButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sectionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sectionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        sectionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.addSubview(sectionLabel)
        self.sendSubviewToBack(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: UIScreen.main.bounds.height*(1/70)).isActive = true
        sectionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIScreen.main.bounds.height*(1/70)).isActive = true
        sectionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        sectionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
    }
    
}
