//
//  HomeViewController.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 4/12/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit
import Firebase
import SideMenu
import SearchTextField

class HomeViewController: UIViewController {
    
    lazy var logoutButton: UIButton = {
        var logoutButton = UIButton()
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        logoutButton.titleLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/25)!)
        logoutButton.backgroundColor = UIColor.AnalCream
        logoutButton.setTitleColor(UIColor.PrimaryCrimson, for: .normal)
        logoutButton.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
        return logoutButton
    }()
    
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
    
    lazy var editButton: UIButton = {
        var editButton = UIButton()
        editButton.setImage(UIImage(named: "edit.png"), for: .normal)
        editButton.addTarget(self, action: #selector(editWorkspace(_:)), for: .touchUpInside)
        editButton.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        return editButton
    }()
        
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("WELCOME TO FSPA")
        
        initialiseWorkspace()
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        
        ref.child("users/\(uid)").observe(.childChanged) { (snapshot) in            
            if(snapshot.key == "currentWorkspace"){
                self.initialiseWorkspace()
            }
           }
        
        
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
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
        
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height/40).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: view.bounds.height/12).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: view.bounds.height/12).isActive = true
        editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width/30).isActive = true

        
    }
    
    public func initialiseWorkspace(){
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        var isAdmin = Bool()
        ref.child("users/\(uid)/currentWorkspace").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? String
            
            let currentWorkspace = value
            if(currentWorkspace != ""){
                
                print(currentWorkspace)
                
                ref.child("users/\(uid)/workspaces/\(currentWorkspace!)").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! [String: Any]
                    
                    isAdmin = value["isAdmin"] as! Bool
                    if(isAdmin){
                        self.editButton.isHidden = false
                    }else{
                        self.editButton.isHidden = true
                    }
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func editWorkspace(_ sender: Any) {
        guard let window = self.view.window else {
            
            return
            
        }
        
        let vc = EditWorkspaceViewController()
        
        self.dismiss(animated: true, completion: nil)
        
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func logout(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
            
        }
        catch let signOutError as NSError {
            
            print ("Error signing out: %@", signOutError)
            
        }
        
        guard let window = self.view.window else {
            
            return
            
        }
        
        let transition = CATransition()
        
        transition.type = .fade
        
        transition.duration = 0.5
        
        window.layer.add(transition, forKey: kCATransition)
                
        window.rootViewController = LoginViewController()
        
        window.makeKeyAndVisible()
            
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
