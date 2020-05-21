//
//  CreateWorkspaceViewController.swift
//  FSPA
//
//  Created by Abdulrahman Ayad on 5/11/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit
import Firebase

class CreateWorkspaceViewController: UIViewController {
    
    lazy var workspaceName: UITextField = {
        var workspaceName = UITextField(frame: CGRect.zero)
        workspaceName.textColor = UIColor.PrimaryCrimson
        workspaceName.backgroundColor = UIColor.BgGray
        workspaceName.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/40)!)
        workspaceName.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        return workspaceName
    }()
    
    lazy var submitButton: UIButton = {
        var submitButton = UIButton()
        submitButton.setTitle("Add", for: .normal)
        submitButton.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        submitButton.titleLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/45)!)
        submitButton.backgroundColor = UIColor.PrimaryCrimson
        submitButton.setTitleColor(UIColor.AnalCream, for: .normal)
        submitButton.addTarget(self, action: #selector(addWorkspace(_:)), for: .touchUpInside)
        return submitButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.AnalCream
        
        view.addSubview(workspaceName)
        workspaceName.translatesAutoresizingMaskIntoConstraints = false
        workspaceName.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.6).isActive = true
        workspaceName.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/10).isActive = true
        workspaceName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/50).isActive = true
        
        view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        submitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/10).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: workspaceName.bottomAnchor).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: workspaceName.trailingAnchor, constant: view.bounds.width/50).isActive = true
    }
    
    @IBAction func addWorkspace(_ sender: Any) {
        var currentWorkspace = ""
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        
        let workspaceAttrs = ["name": workspaceName.text!, "users": [uid: true]] as [String : Any]
        let userWorkAttrs = ["isAdmin": true, "selected": true]
        
        ref.child("users/\(uid)/currentWorkspace").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            
            currentWorkspace = value!
            ref.child("workspaces/\(self.workspaceName.text!)").setValue(workspaceAttrs)
            ref.child("users/\(uid)/workspaces/\(self.workspaceName.text!)").setValue(userWorkAttrs)
            ref.child("users/\(uid)/workspaces/\(currentWorkspace)/selected").setValue(false)
            ref.child("users/\(uid)/currentWorkspace").setValue(self.workspaceName.text!)
            
        })
        
    }
    
    
}
