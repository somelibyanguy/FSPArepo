//
//  HomeViewController.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 4/12/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var topView: UIView = {
        
        var topView = UIView()
        topView.backgroundColor = UIColor.PrimaryCrimson
        topView.addShadowAndRoundCorners(cornerRadius: 0.0, topRightMask: false, topLeftMask: false)
        topView.accessibilityIdentifier = "homeVC/topView"
        return topView
        
    }()
    
    lazy var announcementsButton: SectionButton = {
        
        var announcementsButton = SectionButton()
        announcementsButton.sectionVisibility = true
        announcementsButton.sectionLabel.text = "Announcements"
        announcementsButton.addShadowAndRoundCorners(shadowOffset: CGSize(width: 0.0, height: 5.0), topRightMask: false, topLeftMask: false, bottomRightMask: false)
        return announcementsButton
        
    }()
    
    lazy var toDoButton: SectionButton = {
        
        var toDoButton = SectionButton()
        toDoButton.sectionLabel.text = "To-Do"
        toDoButton.addShadowAndRoundCorners(cornerRadius: 0.0)
        return toDoButton
        
    }()
    
    lazy var facultyButton: SectionButton = {
        
        var facultyButton = SectionButton()
        facultyButton.sectionLabel.text = "Faculty"
        facultyButton.addShadowAndRoundCorners(topRightMask: false, topLeftMask: false, bottomLeftMask: false)
        return facultyButton
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("WELCOME TO FSPA")
        
        view.backgroundColor = UIColor.BgGray
        
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: view.bounds.height/8).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(announcementsButton)
        view.bringSubviewToFront(announcementsButton)
        announcementsButton.translatesAutoresizingMaskIntoConstraints = false
        announcementsButton.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        announcementsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        announcementsButton.widthAnchor.constraint(equalToConstant: view.bounds.width*(17/37)).isActive = true
        
        view.addSubview(toDoButton)
        view.sendSubviewToBack(toDoButton)
        toDoButton.translatesAutoresizingMaskIntoConstraints = false
        toDoButton.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        toDoButton.leadingAnchor.constraint(equalTo: announcementsButton.trailingAnchor).isActive = true
        toDoButton.widthAnchor.constraint(equalToConstant: view.bounds.width*(9/37)).isActive = true

        view.addSubview(facultyButton)
        view.sendSubviewToBack(facultyButton)
        facultyButton.translatesAutoresizingMaskIntoConstraints = false
        facultyButton.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        facultyButton.leadingAnchor.constraint(equalTo: toDoButton.trailingAnchor).isActive = true
        facultyButton.widthAnchor.constraint(equalToConstant: view.bounds.width*(11/37)).isActive = true
        
    }
    
}

extension UIView {
    
    public func addShadowAndRoundCorners(cornerRadius: CGFloat? = nil, shadowColor: UIColor? = nil, shadowOffset: CGSize? = nil, shadowOpacity: Float? = nil, shadowRadius: CGFloat? = nil, topRightMask: Bool = true, topLeftMask: Bool = true, bottomRightMask: Bool = true, bottomLeftMask: Bool = true) {
            
        layer.masksToBounds = false
        layer.cornerRadius = 8.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0) // Shifts shadow
        layer.shadowOpacity = 0.2 // Higher value means more opaque
        layer.shadowRadius = 2 // Higher value means more blurry
        var maskedCorners = CACornerMask()
        
        if let cr = cornerRadius { layer.cornerRadius = cr }
        if let sc = shadowColor { layer.shadowColor = sc.cgColor }
        if let sof = shadowOffset { layer.shadowOffset = sof }
        if let sop = shadowOpacity { layer.shadowOpacity = sop }
        if let sr = shadowRadius { layer.shadowRadius = sr }
        
        if topRightMask { maskedCorners.insert(.layerMaxXMinYCorner) }
        if topLeftMask { maskedCorners.insert(.layerMinXMinYCorner) }
        if bottomRightMask { maskedCorners.insert(.layerMaxXMaxYCorner) }
        if bottomLeftMask { maskedCorners.insert(.layerMinXMaxYCorner) }
        if !maskedCorners.isEmpty { layer.maskedCorners = maskedCorners }
        
    }
    
}
