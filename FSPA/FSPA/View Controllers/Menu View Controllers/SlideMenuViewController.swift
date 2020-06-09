//
//  SlideMenuViewController.swift
//  FSPA
//
//  Created by Abdulrahman Ayad on 4/20/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit
import Firebase

class SlideMenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
	
	lazy var logoutButton: UIButton = {
		var logoutButton = UIButton()
		logoutButton.setTitle("Logout", for: .normal)
		logoutButton.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
		logoutButton.titleLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/45)!)
		logoutButton.backgroundColor = UIColor.PrimaryCrimson
		logoutButton.setTitleColor(UIColor.AnalCream, for: .normal)
		logoutButton.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
		return logoutButton
	}()
	
	lazy var topView: UIView = {
		var topView = UIView()
		topView.backgroundColor = UIColor.PrimaryCrimson
		topView.addShadowAndRoundCorners(shadowOffset: CGSize(width: 0.0, height: 5.0), topRightMask: false, topLeftMask: false)
		return topView
	}()
	
	lazy var nameLabel: UILabel = {
		var nameLabel = UILabel()
		let ref = Database.database().reference()
		let uid = Auth.auth().currentUser!.uid
		ref.child("users/\(uid)/fullName").observeSingleEvent(of: .value, with: { (snapshot) in
			let value = snapshot.value as? String
			
			self.nameLabel.text = value
			
		}) { (error) in
			print(error.localizedDescription)
		}
		nameLabel.numberOfLines = 1
		nameLabel.textColor = UIColor.AnalCream
		nameLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/45)!)
		nameLabel.textAlignment = .center
		return nameLabel
	}()
	
	lazy var workspaceCollection: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		var workspaceCollection = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
		workspaceCollection.register(Workspace.self, forCellWithReuseIdentifier: "collectionCell")
		workspaceCollection.delegate = self
		workspaceCollection.dataSource = self
		workspaceCollection.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
		workspaceCollection.backgroundColor = UIColor.AnalCream
		return workspaceCollection
	}()
	
	
	
	var cell: Workspace!
	
	var workspaces: [String:Workspace] = [:]
	
	var workspaceNames: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.BgGray
		
		let ref = Database.database().reference()
	    let uid = Auth.auth().currentUser!.uid
		
        ref.child("users/\(uid)").observe(.childChanged) { (snapshot) in
			if(snapshot.key == "currentWorkspace"){
				self.getWorkspaces()
			}
            
        }
		
		getWorkspaces()
		
		cell = Workspace()
		
		view.addSubview(logoutButton)
		logoutButton.translatesAutoresizingMaskIntoConstraints = false
		logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height/50).isActive = true
		logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width/16).isActive = true
		logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/16).isActive = true
		
		view.addSubview(topView)
		topView.translatesAutoresizingMaskIntoConstraints = false
		topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		topView.heightAnchor.constraint(equalToConstant: view.bounds.height/5.65).isActive = true
		topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		
		topView.addSubview(nameLabel)
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -view.bounds.height/70).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor).isActive = true
		
		view.addSubview(workspaceCollection)
		workspaceCollection.translatesAutoresizingMaskIntoConstraints = false
		workspaceCollection.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: view.bounds.height/70).isActive = true
		workspaceCollection.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -view.bounds.height/70).isActive = true
		workspaceCollection.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: view.bounds.width/50).isActive = true
		workspaceCollection.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -view.bounds.width/50).isActive = true
		
	}
	
	private func getWorkspaces(){
		let ref = Database.database().reference()
		let uid = Auth.auth().currentUser!.uid
		
		workspaces.removeAll()
		workspaceNames.removeAll()
		ref.child("users/\(uid)/workspaces").observeSingleEvent(of: .value, with: { (snapshot) in
			if snapshot.childrenCount > 0 {
				for data in snapshot.children.allObjects as! [DataSnapshot] {
					if let value = data.value as? [String: Any] {
						
						let workspaceName = data.key
						let current = value["selected"] as? Bool ?? false
						
						let workspaceToAdd = Workspace()
						workspaceToAdd.workspaceName = workspaceName
						workspaceToAdd.current = current
						
						self.workspaces[workspaceName] = workspaceToAdd
						self.workspaceNames.append(workspaceName)
						
						
						
					}
				}
			}
			
			DispatchQueue.global(qos: .background).async {
				
				// Background Thread
				
				DispatchQueue.main.async {
					// Run UI Updates
					
					let workspaceToAdd = Workspace()
					workspaceToAdd.workspaceName = "Add workspace"
					workspaceToAdd.current = false
					self.workspaces["Add workspace"] = workspaceToAdd
					self.workspaceNames.append("Add workspace")
					self.workspaceCollection.reloadData()
				}
			}
		})
		
		
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
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return workspaces.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		cell = workspaceCollection.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? Workspace
		
		
		
		cell.workspaceLabel.text = workspaces[workspaceNames[indexPath.row]]!.workspaceName
		if(workspaces[workspaceNames[indexPath.row]]!.current){
			cell.backgroundColor = UIColor(red: 0.323, green: 0.049, blue: 0.06157, alpha: 1)
		}else{
			cell.backgroundColor = UIColor.PrimaryCrimson
		}
		cell.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
		cell.workspaceLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: view.bounds.height/45)!)
		cell.workspaceLabel.textAlignment = .center
		
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if(indexPath.row == workspaces.count - 1){
			let vc = CreateWorkspaceViewController()
			self.present(vc, animated: true, completion: nil)
		}else{
			var currentWorkspace = ""
			let ref = Database.database().reference()
			let uid = Auth.auth().currentUser!.uid
			
			ref.child("users/\(uid)/currentWorkspace").observeSingleEvent(of: .value, with: { (snapshot) in
				let value = snapshot.value as? String
				currentWorkspace = value!
				ref.child("users/\(uid)/workspaces/\(currentWorkspace)/selected").setValue(false)
				self.workspaces[currentWorkspace]!.current = false
				ref.child("users/\(uid)/workspaces/\(self.workspaces[self.workspaceNames[indexPath.row]]!.workspaceName!)/selected").setValue(true)
				self.workspaces[self.workspaceNames[indexPath.row]]!.current = true
				ref.child("users/\(uid)/currentWorkspace").setValue(self.workspaces[self.workspaceNames[indexPath.row]]!.workspaceName)
				
				self.workspaceCollection.reloadData()
				self.dismiss(animated: true)
				
			})
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: workspaceCollection.bounds.width * 0.95, height: workspaceCollection.bounds.height/10)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
	}
	
}
