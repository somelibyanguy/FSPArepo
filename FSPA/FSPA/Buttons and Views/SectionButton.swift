//
//  SectionButton.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 4/14/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit

enum Section: String {
    
    case Announcements = "Announcements"
    case ToDo = "To-Do"
    case Members = "Members"
    case Default = "Default"
    
}

final class SectionButton: UIButton {
    
    let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 2.7)
    let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5.7)
    
    lazy private(set) var section: Section = .Default
    
    private(set) var isVisible = false {
        
        willSet (newVisibility) {
            
            if isVisible != newVisibility {
                
                if newVisibility { // Section is now visible:
                    
                    self.backgroundColor = UIColor.PrimaryCrimson
                    self.setTitleColor(.AnalCream, for: .normal)
                    
                } else { // Section is now hidden:
                    
                    self.backgroundColor = UIColor.AnalCream
                    self.setTitleColor(.PrimaryCrimson, for: .normal)
                    
                }
                
            }
            
        }
        
    }
    
    convenience init() {
        
        self.init(section: nil)
        
    }
    
    init(section: Section?) {
        
        super.init(frame: .zero)
        
        if let newSection = section { self.section = newSection }
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        
        backgroundColor = UIColor.AnalCream
        setTitle(section.rawValue, for: .normal)
        setTitleColor(.PrimaryCrimson, for: .normal)
        titleLabel!.textAlignment = .center
        titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: .getWidthFitSize(minSize: 14.0, maxSize: 19.0))
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: titleLabel!.intrinsicContentSize.height + verticalEdgeInset*2).isActive = true
        
    }
    
    func setVisibility(isVisible: Bool) {
        
        self.isVisible = isVisible
        
    }
    
    func setSection(newSection: Section) {
        
        self.section = newSection
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        switch section {
            
        case .Announcements:
            
            addShadowAndRoundCorners(shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 2.0), topRightMask: false, topLeftMask: false, bottomRightMask: false)
            
        case .ToDo:
            
            addShadowAndRoundCorners(cornerRadius: 0.0, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 2.0))
            
        case .Members:
            
            addShadowAndRoundCorners(shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 2.0), topRightMask: false, topLeftMask: false, bottomLeftMask: false)
            
        case .Default:
            
            addShadowAndRoundCorners(cornerRadius: 0.0, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 2.0))
            
        }
        
    }
    
}
