//
//  EditWorksapceViewController.swift
//  FSPA
//
//  Created by Abdulrahman Ayad on 4/28/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit
import SearchTextField
import Firebase

class EditWorkspaceViewController: UIViewController {
    
    lazy var searchUsers: SearchTextField = {
        var searchUsers = SearchTextField(frame: CGRect.zero)
        searchUsers.textColor = UIColor.PrimaryCrimson
        searchUsers.backgroundColor = UIColor.BgGray
        searchUsers.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/40)!)
        searchUsers.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        return searchUsers
    }()
    
    lazy var addButton: UIButton = {
        var addButton = UIButton()
        addButton.setTitle("Add", for: .normal)
        addButton.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        addButton.titleLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/45)!)
        addButton.backgroundColor = UIColor.PrimaryCrimson
        addButton.setTitleColor(UIColor.AnalCream, for: .normal)
        addButton.addTarget(self, action: #selector(addUser(_:)), for: .touchUpInside)
        return addButton
    }()
    
    lazy var deleteButton: UIButton = {
        var deleteButton = UIButton()
        deleteButton.setImage(UIImage(named: "delete.png"), for: .normal)
        deleteButton.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        deleteButton.addTarget(self, action: #selector(deleteWorkspace(_:)), for: .touchUpInside)
        return deleteButton
    }()
    
    var users: [String] = ["Jimmy"]
    
    var usersMap: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsers()
        
        view.backgroundColor = UIColor.AnalCream
        
        view.addSubview(searchUsers)
        searchUsers.translatesAutoresizingMaskIntoConstraints = false
        searchUsers.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.6).isActive = true
        searchUsers.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/10).isActive = true
        searchUsers.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/50).isActive = true
        
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/10).isActive = true
        addButton.bottomAnchor.constraint(equalTo: searchUsers.bottomAnchor).isActive = true
        addButton.leadingAnchor.constraint(equalTo: searchUsers.trailingAnchor, constant: view.bounds.width/50).isActive = true
        
        view.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height/25).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: view.bounds.width/5).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: view.bounds.width/5).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/2 - view.bounds.width/10).isActive = true
        
    }
    
    
    private func getUsers(){
        let ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    if let value = data.value as? [String: Any] {
                        
                        let uid = data.key
                        print(uid)
                        let name = value["fullName"] as? String ?? ""
                        
                        self.usersMap[name] = uid
                        
                        self.users.append(name)
                        print(self.users)
                        self.searchUsers.filterStrings(self.users)
                        
                    }
                }
            }
        })
    }
    
    @IBAction func addUser(_ sender: Any) {
        var currentWorkspace = ""
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        ref.child("users/\(uid)/currentWorkspace").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            
            currentWorkspace = value!
            
            let uid2 = self.usersMap[self.searchUsers.text!]
            
            self.searchUsers.text = ""
            
            let userAttrs = ["isAdmin": false, "name": currentWorkspace, "selected": false] as [String : Any]
            
            ref.child("users/\(uid2!)/Workspaces/\(currentWorkspace)").setValue(userAttrs) { (error, ref) in
                
                if let error = error {
                    
                    assertionFailure(error.localizedDescription)
                }
            }
            
            ref.child("workspaces/\(currentWorkspace)/users/\(uid2!)").setValue(false) { (error, ref) in
                
                if let error = error {
                    
                    assertionFailure(error.localizedDescription)
                }
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        
    }
    
    @IBAction func deleteWorkspace(_ sender: Any) {
        
    }
    
}
