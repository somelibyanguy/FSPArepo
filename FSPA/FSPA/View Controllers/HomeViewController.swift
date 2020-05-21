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

protocol AnnouncementsPageViewControllerDelegate: class {
    
    func togglePin(forAnnouncementAt index: Int)
    func toggleVisibility(forAnnouncementAt index: Int)
    func editAnnouncement(forAnnouncementAt index: Int, newImage: UIImage?, newTitle: String?, newBody: NSAttributedString?)
    func deleteAnnouncement(forAnnouncementAt index: Int)
    
}

final class HomeViewController: UIViewController {
    
    lazy private(set) var topView: UIView = {
        
        var topView = UIView()
        topView.backgroundColor = UIColor.PrimaryCrimson
        topView.accessibilityIdentifier = "homeVC/topView"
        return topView
        
    }()
    
    lazy private(set) var topViewContentView: UIView = {
        
        var topView = UIView()
        topView.accessibilityIdentifier = "homeVC/topViewCV"
        return topView
        
    }()
    
    lazy private(set) var announcementsButton: SectionButton = {
        
        var announcementsButton = SectionButton(section: .Announcements)
        announcementsButton.setVisibility(isVisible: true)
        announcementsButton.addTarget(self, action: #selector(switchSection(sender:)), for: .touchUpInside)
        announcementsButton.accessibilityIdentifier = "homeVC/announButton"
        return announcementsButton
        
    }()
    
    lazy private(set) var toDoButton: SectionButton = {
        
        var toDoButton = SectionButton(section: .ToDo)
        toDoButton.addTarget(self, action: #selector(switchSection(sender:)), for: .touchUpInside)
        toDoButton.accessibilityIdentifier = "homeVC/toDoButton"
        return toDoButton
        
    }()
    
    lazy private(set) var membersButton: SectionButton = {
        
        var membersButton = SectionButton(section: .Members)
        membersButton.addTarget(self, action: #selector(switchSection(sender:)), for: .touchUpInside)
        membersButton.accessibilityIdentifier = "homeVC/membersButton"
        return membersButton
        
    }()
    
    lazy private(set) var calendarButton: BubbleButton = {
        
        var calendarButton = BubbleButton(bubbleButtonImage: UIImage.calendarIcon.withTintColor(.BgGray, renderingMode: .alwaysOriginal))
        calendarButton.addTarget(self, action: #selector(segueToCalendar), for: .touchUpInside)
        calendarButton.accessibilityIdentifier = "homeVC/calendarButton"
        return calendarButton
        
    }()
    
    lazy private(set) var searchBar: SearchBar = {
        
        var searchBar = SearchBar(tintColor: .gray)
        searchBar.delegate = self
        searchBar.accessibilityIdentifier = "homeVC/searchBar"
        return searchBar
        
    }()
    
    lazy private(set) var searchBarCancelButton: UIButton = {
        
        var searchBarCancelButton = UIButton()
        searchBarCancelButton.setTitle("Cancel", for: .normal)
        searchBarCancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: .getWidthFitSize(minSize: 14.0, maxSize: 19.0))
        searchBarCancelButton.setTitleColor(UIColor.BgGray, for: .normal)
        searchBarCancelButton.addTarget(self, action: #selector(closeSearchBar), for: .touchUpInside)
        searchBarCancelButton.alpha = 0.0
        searchBarCancelButton.accessibilityIdentifier = "homeVC/searchBarCB"
        return searchBarCancelButton
        
    }()
    
    lazy private(set) var searchBarHiddenConstraint: NSLayoutConstraint = NSLayoutConstraint()
    lazy private(set) var searchBarShowingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    lazy private(set) var tabNavigationCollectionView: TabNavigationCollectionView = {
        
        var tabNavigationCollectionView = TabNavigationCollectionView()
        tabNavigationCollectionView.delegate = self
        tabNavigationCollectionView.dataSource = self
        tabNavigationCollectionView.accessibilityIdentifier = "homeVC/tabNavigationCV"
        return tabNavigationCollectionView
        
    }()
    
    lazy private(set) var addCellButton: BubbleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 3.5)
        
        var addCellButton = BubbleButton(bubbleButtonImage: UIImage.addPlusIcon.withTintColor(UIColor.BgGray))
        addCellButton.backgroundColor = UIColor.PrimaryCrimson
        addCellButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        addCellButton.addTarget(self, action: #selector(addCell(sender:)), for: .touchUpInside)
        addCellButton.accessibilityIdentifier = "homeVC/addCellButton"
        return addCellButton
        
    }()
    
    private var currentPage: Int = 0
    private let edgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private var announcementList: [Announcement] = []
    private var pinAnnouncementIndexList: [Int] = []
    private var nonPinAnnouncementIndexList: [Int] = []
    private var toDoList: [String] = ["Example 1", "Very long toDo title to showcase functionality", "Completed toDo"]
    
    lazy private(set) var edgeFadeView: UIView = UIView()
    
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
        
        // topView
        
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: .getPercentageHeightFit(minPercentage: 14, maxPercentage: 15)).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // topViewContentView
        
        topView.addSubview(topViewContentView)
        topView.bringSubviewToFront(topViewContentView)
        topViewContentView.translatesAutoresizingMaskIntoConstraints = false
        topViewContentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topViewContentView.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        topViewContentView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        topViewContentView.trailingAnchor.constraint(equalTo: topView.trailingAnchor).isActive = true
        
        // calendarButton
        
        topViewContentView.addSubview(calendarButton)
        topViewContentView.bringSubviewToFront(calendarButton)
        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        calendarButton.topAnchor.constraint(equalTo: topViewContentView.topAnchor, constant: edgeInset).isActive = true
        calendarButton.bottomAnchor.constraint(equalTo: topViewContentView.bottomAnchor, constant: -edgeInset).isActive = true
        calendarButton.trailingAnchor.constraint(equalTo: topViewContentView.trailingAnchor, constant: -edgeInset).isActive = true
        calendarButton.widthAnchor.constraint(equalTo: calendarButton.heightAnchor).isActive = true
        
        // searchBarCancelButton
        
        topViewContentView.addSubview(searchBarCancelButton)
        topViewContentView.bringSubviewToFront(searchBarCancelButton)
        searchBarCancelButton.translatesAutoresizingMaskIntoConstraints = false
        searchBarCancelButton.topAnchor.constraint(equalTo: topViewContentView.topAnchor, constant: edgeInset).isActive = true
        searchBarCancelButton.bottomAnchor.constraint(equalTo: topViewContentView.bottomAnchor, constant: -edgeInset).isActive = true
        searchBarCancelButton.widthAnchor.constraint(equalToConstant: searchBarCancelButton.intrinsicContentSize.width).isActive = true
        searchBarCancelButton.trailingAnchor.constraint(equalTo: topViewContentView.trailingAnchor, constant: -edgeInset).isActive = true
        
        // searchBar and searchTextField
        
        topViewContentView.addSubview(searchBar)
        topViewContentView.bringSubviewToFront(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: topViewContentView.topAnchor, constant: edgeInset).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: topViewContentView.bottomAnchor, constant: -edgeInset).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: topViewContentView.leadingAnchor, constant: edgeInset).isActive = true
        
        searchBarHiddenConstraint = searchBar.trailingAnchor.constraint(equalTo: calendarButton.leadingAnchor, constant: -edgeInset)
        searchBarShowingConstraint = searchBar.trailingAnchor.constraint(equalTo: searchBarCancelButton.leadingAnchor, constant: -edgeInset)
        
        searchBarHiddenConstraint.isActive = true
        
        searchBar.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.topAnchor.constraint(equalTo: searchBar.topAnchor).isActive = true
        searchBar.searchTextField.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        searchBar.searchTextField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor).isActive = true
        searchBar.searchTextField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor).isActive = true
        
        // announcementsButton
        
        view.addSubview(announcementsButton)
        view.sendSubviewToBack(announcementsButton)
        announcementsButton.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        announcementsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        announcementsButton.widthAnchor.constraint(equalToConstant: announcementsButton.titleLabel!.intrinsicContentSize.width + (announcementsButton.horizontalEdgeInset*2)).isActive = true
        
        // membersButton
        
        view.addSubview(membersButton)
        view.sendSubviewToBack(membersButton)
        membersButton.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        membersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        membersButton.widthAnchor.constraint(equalToConstant: membersButton.titleLabel!.intrinsicContentSize.width + (membersButton.horizontalEdgeInset*2)).isActive = true
        
        // toDoButton
        
        view.addSubview(toDoButton)
        view.sendSubviewToBack(toDoButton)
        toDoButton.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        toDoButton.trailingAnchor.constraint(equalTo: membersButton.leadingAnchor).isActive = true
        toDoButton.leadingAnchor.constraint(equalTo: announcementsButton.trailingAnchor).isActive = true
        
        // tabNavigationCollectionView:
        
        view.addSubview(tabNavigationCollectionView)
        view.sendSubviewToBack(tabNavigationCollectionView)
        tabNavigationCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tabNavigationCollectionView.topAnchor.constraint(equalTo: membersButton.bottomAnchor).isActive = true
        tabNavigationCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabNavigationCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabNavigationCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tabNavigationCollectionView.reloadData()
        tabNavigationCollectionView.setContentOffset(.zero, animated: false)
        
        // edgeFadeView:
        
        view.addSubview(edgeFadeView)
        view.bringSubviewToFront(edgeFadeView)
        edgeFadeView.translatesAutoresizingMaskIntoConstraints = false
        edgeFadeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        edgeFadeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        edgeFadeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        edgeFadeView.heightAnchor.constraint(equalToConstant: edgeInset/2).isActive = true
        
        edgeFadeView.backgroundColor = UIColor.BgGray
        
        // addCellButton:
        
        view.addSubview(addCellButton)
        view.bringSubviewToFront(addCellButton)
        addCellButton.translatesAutoresizingMaskIntoConstraints = false
        addCellButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -edgeInset).isActive = true
        addCellButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgeInset).isActive = true
        addCellButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 14)).isActive = true
        addCellButton.heightAnchor.constraint(equalTo: addCellButton.widthAnchor).isActive = true
        
    }
    
    public func initialiseWorkspace() {
        
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
                        // self.editButton.isHidden = false
                    }else{
                        // self.editButton.isHidden = true
                    }
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func editWorkspace( sender: Any) {
        
        guard let window = self.view.window else {
            
            return
            
        }
        
        let vc = EditWorkspaceViewController()
        
        self.dismiss(animated: true, completion: nil)
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func logout( sender: Any) {
        
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
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = edgeFadeView.bounds
        
        gradientMaskLayer.colors =  [UIColor.BgGray.withAlphaComponent(0.0).cgColor, UIColor.BgGray.withAlphaComponent(1.0).cgColor]
        gradientMaskLayer.locations = [0.0, 1.0]
        
        edgeFadeView.layer.mask = gradientMaskLayer
        
    }
    
    @objc private func switchSection(sender: SectionButton) {
        
        if !sender.isVisible {
            
            if !sender.isVisible {
                
                switch sender.section {
                    
                case .Announcements:
                    
                    announcementsButton.setVisibility(isVisible: true)
                    toDoButton.setVisibility(isVisible: false)
                    membersButton.setVisibility(isVisible: false)
                    
                    tabNavigationCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                    
                case .ToDo:
                    
                    toDoButton.setVisibility(isVisible: true)
                    announcementsButton.setVisibility(isVisible: false)
                    membersButton.setVisibility(isVisible: false)
                    
                    tabNavigationCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
                    
                case .Members:
                    
                    membersButton.setVisibility(isVisible: true)
                    announcementsButton.setVisibility(isVisible: false)
                    toDoButton.setVisibility(isVisible: false)
                    
                    tabNavigationCollectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: true)
                    
                case .Default: print("ERROR: Trying to switch to Default Section.")
                    
                }
                
            }
            
        }
        
    }
    
    @objc private func addCell (sender: BouncyButton) {
        
        if tabNavigationCollectionView.visibleCells.count == 1, let tabNavigationCell = tabNavigationCollectionView.visibleCells.first as? tabNavigationCell {
            
            switch tabNavigationCell.cellCollectionView.section {
                
            case .Announcements:
                
                announcementList.insert(Announcement(), at: 0)
                refreshPinAnnouncements()
                tabNavigationCell.cellCollectionView.reloadData()
                
                if pinAnnouncementIndexList.isEmpty {
                    
                    tabNavigationCell.cellCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
                    collectionView(tabNavigationCell.cellCollectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
                    
                } else {
                    
                    tabNavigationCell.cellCollectionView.selectItem(at: IndexPath(row: pinAnnouncementIndexList.count, section: 0), animated: true, scrollPosition: .centeredVertically)
                    collectionView(tabNavigationCell.cellCollectionView, didSelectItemAt: IndexPath(row: pinAnnouncementIndexList.count, section: 0))
                    
                }
                
            case .ToDo: print("ERROR: Trying to add a cell to a toDo collectionView.")
            case .Members: print("ERROR: Trying to add a cell to a members collectionView.")
            case .Default: print("ERROR: Trying to add a cell to a default collectionView.")
                
            }
            
        }
        
    }
    
    @objc private func segueToCalendar (sender: UIButton) {
        
        print("Seguing to Calendar")
        
    }
    
    @objc private func closeSearchBar (sender: UIButton) {
        
        searchBar.endEditing(true)
        
    }
    
    private func refreshPinAnnouncements() {
        
        var index = 0
        pinAnnouncementIndexList = []
        nonPinAnnouncementIndexList = []
        
        while index < announcementList.count {
            
            if announcementList[index].isPin {
                
                pinAnnouncementIndexList.append(index)
                
            } else {
                
                nonPinAnnouncementIndexList.append(index)
                
            }
            
            index+=1
            
        }
        
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        print("searchBarEndEditing")
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                       options: .curveEaseOut, animations: {
                        
                        if (self.searchBar.text != "") {
                            
                            self.searchBar.text = ""
                            
                        }
                        
                        self.searchBarShowingConstraint.isActive = false
                        self.searchBarHiddenConstraint.isActive = true
                        self.searchBarCancelButton.alpha = 0.0
                        self.calendarButton.alpha = 1.0
                        self.view.layoutIfNeeded()
                        
        }, completion: nil)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        print("searchBarBeganEditing")
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                       options: .curveEaseOut, animations: {
                        
                        self.searchBarHiddenConstraint.isActive = false
                        self.searchBarShowingConstraint.isActive = true
                        self.searchBarCancelButton.alpha = 1.0
                        self.calendarButton.alpha = 0.0
                        self.view.layoutIfNeeded()
                        
        }, completion: nil)
        
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let collectionView = collectionView as? TabCollectionView {
            
            switch collectionView.section {
                
            case .Announcements:
                
                if announcementList.count == 0 {
                    
                    let placeholderImageView = UIImageView(image: UIImage.announcementsCollectionViewPlaceholder.withTintColor(UIColor.lightGray))
                    placeholderImageView.contentMode = .scaleAspectFit
                    
                    placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
                    placeholderImageView.heightAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 70)).isActive = true
                    placeholderImageView.widthAnchor.constraint(equalTo: placeholderImageView.heightAnchor).isActive = true
                    
                    let placeholderView = UIView()
                    placeholderView.addSubview(placeholderImageView)
                    placeholderImageView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor).isActive = true
                    placeholderImageView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor).isActive = true
                    
                    collectionView.backgroundView = placeholderView
                    
                } else {
                    
                    collectionView.backgroundView = nil
                    
                }
                
                return announcementList.count
                
            case .ToDo: return toDoList.count
            case .Members: return 3
            case .Default: return 1
                
            }
            
        } else if collectionView is TabNavigationCollectionView {
            
            return 3
            
        } else {
            
            return 0
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let collectionView = collectionView as? TabNavigationCollectionView {
            
            if let tabNavigationCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView.cellID, for: indexPath) as? tabNavigationCell {
                
                switch indexPath.item {
                    
                case 0: tabNavigationCell.setSection(section: .Announcements)
                case 1:
                    
                    tabNavigationCell.setSection(section: .ToDo)
                    tabNavigationCell.cellCollectionView.dragInteractionEnabled = true
                    tabNavigationCell.cellCollectionView.dragDelegate = self
                    tabNavigationCell.cellCollectionView.dropDelegate = self
                    
                case 2: tabNavigationCell.setSection(section: .Members)
                default: print("ERROR: IndexPath out of bounds. Setting extra cell to Default.")
                    
                }
                
                tabNavigationCell.cellCollectionView.delegate = self
                tabNavigationCell.cellCollectionView.dataSource = self
                
                return tabNavigationCell
                
            } else {
                
                print("ERROR: Unable to retrieve a reusableCell for TabNavigationCollectionView. Returning a default cell.")
                return DefaultCell()
                
            }
            
        } else if let collectionView = collectionView as? TabCollectionView {
            
            switch collectionView.section {
                
            case .Announcements:
                
                if let announcementsCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView.tabCellID, for: indexPath) as? AnnouncementsCell {
                    
                    if indexPath.item < pinAnnouncementIndexList.count {
                        
                        let index = pinAnnouncementIndexList[indexPath.item]
                        
                        announcementsCell.announcementsImageView.image = announcementList[index].image
                        announcementsCell.announcementsTitleLabel.text = announcementList[index].title
                        announcementsCell.announcementsBodyLabel.text = announcementList[index].body.string
                        announcementsCell.announcementsPinButton.isHidden = false
                        
                        if announcementList[index].isPublic {
                            
                            announcementsCell.announcementsVisibilityButton.isHidden = false
                            
                        } else {
                            
                            announcementsCell.announcementsVisibilityButton.isHidden = true
                            
                        }
                        
                    } else {
                        
                        let index = nonPinAnnouncementIndexList[indexPath.item-pinAnnouncementIndexList.count]
                        
                        announcementsCell.announcementsImageView.image = announcementList[index].image
                        announcementsCell.announcementsTitleLabel.text = announcementList[index].title
                        announcementsCell.announcementsBodyLabel.text = announcementList[index].body.string
                        announcementsCell.announcementsPinButton.isHidden = true
                        
                        if announcementList[index].isPublic {
                            
                            announcementsCell.announcementsVisibilityButton.isHidden = false
                            
                        } else {
                            
                            announcementsCell.announcementsVisibilityButton.isHidden = true
                            
                        }
                        
                    }
                    
                    return announcementsCell
                    
                } else {
                    
                    print("ERROR: Unable to retrieve an AnnouncementsCell. Returning a default cell.")
                    return DefaultCell()
                    
                }
                
            case .ToDo:
                
                if let toDoCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView.tabCellID, for: indexPath) as? ToDoCell {
                    
                    if indexPath.item % 2 == 0 {
                        
                        toDoCell.toDoLabel.text = toDoList[indexPath.item]
                        toDoCell.toDoDeadlineLabel.text = "May 25, 2020"
                        toDoCell.toggleToDo(isCompleted: true)
                        
                    }
                    
                    return toDoCell
                    
                } else {
                    
                    print("ERROR: Unable to retrieve a ToDoCell. Returning a default cell.")
                    return DefaultCell()
                    
                }
                
            case .Members:
                
                if let membersCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView.tabCellID, for: indexPath) as? MembersCell {
                    
                    if indexPath.item == 0 {
                        
                        membersCell.toggleMembers(isHighlighted: true)
                        membersCell.membersImageView.image = UIImage(named: "exampleMembersProfileImage")
                        membersCell.membersNameLabel.text = "Manuel Alejandro Martin Callejo"
                        membersCell.membersTitleLabel.text = "FSPA Developer Team - iOS Developer"
                        
                    }
                    
                    return membersCell
                    
                } else {
                    
                    print("ERROR: Unable to retrieve a MembersCell. Returning a default cell.")
                    return DefaultCell()
                    
                }
                
            case .Default:
                
                if let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView.tabCellID, for: indexPath) as? DefaultCell {
                    
                    return defaultCell
                    
                } else {
                    
                    print("ERROR: Unable to retrieve a DefaultCell. Returning a default cell.")
                    return DefaultCell()
                    
                }
                
            }
            
        } else {
            
            return DefaultCell()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let tabCollectionView = collectionView as? TabCollectionView, tabCollectionView.section == .Announcements {
            
            if indexPath.item < pinAnnouncementIndexList.count {
                
                let index = pinAnnouncementIndexList[indexPath.item]
                
                let announcementsPageVC = AnnouncementsPageViewController(announcement: announcementList[index], index: index)
                announcementsPageVC.delegate = self
                navigationController?.pushViewController(announcementsPageVC, animated: true)
                
            } else {
                
                let index = nonPinAnnouncementIndexList[indexPath.item-pinAnnouncementIndexList.count]
                
                let announcementsPageVC = AnnouncementsPageViewController(announcement: announcementList[index], index: index)
                announcementsPageVC.delegate = self
                navigationController?.pushViewController(announcementsPageVC, animated: true)
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView is TabNavigationCollectionView {
            
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        } else {
            
            return CGSize(width: 0.0, height: 0.0)
            
        }
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView is TabNavigationCollectionView {
            
            let index = Int(targetContentOffset.pointee.x / view.frame.width)
            
            if index != currentPage {
                
                switch index {
                    
                case 0:
                    
                    switchSection(sender: announcementsButton)
                    currentPage = 0
                    
                case 1:
                    
                    switchSection(sender: toDoButton)
                    currentPage = 1
                    
                case 2:
                    
                    switchSection(sender: membersButton)
                    currentPage = 2
                    
                default: print("ERROR: ScrollView index is out bounds. Rejecting Change.")
                    
                }
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        if collectionView is TabCollectionView {
            
            let item = toDoList[indexPath.row]
            let itemProvider = NSItemProvider(object: item as NSString)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
            
        } else {
            
            return []
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if collectionView is TabCollectionView, collectionView.hasActiveDrag {
            
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        if collectionView is TabCollectionView {
            
            var destinationIndexPath: IndexPath
            
            if let indexPath = coordinator.destinationIndexPath {
                
                destinationIndexPath = indexPath
                
            } else {
                
                let row = collectionView.numberOfItems(inSection: 0)
                destinationIndexPath = IndexPath(item: row - 1, section: 0)
                
            }
            
            if coordinator.proposal.operation == .move {
                
                if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
                    
                    collectionView.performBatchUpdates({
                        
                        self.toDoList.remove(at: sourceIndexPath.item)
                        self.toDoList.insert(item.dragItem.localObject as! String, at: destinationIndexPath.item)
                        
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                        
                    }, completion: nil)
                    
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    
                }
                
            }
            
        }
        
    }

}

extension HomeViewController: AnnouncementsPageViewControllerDelegate {
    
    func togglePin(forAnnouncementAt index: Int) {
        
        print("TOGGLING PIN STATE")
        
        if index == -1 {
            
            print("ERROR: Unable to perform action. Returned index is out of bounds (-1).")
            return
            
        }
        
        announcementList[index].isPin = !announcementList[index].isPin
        refreshPinAnnouncements()
        
        if tabNavigationCollectionView.visibleCells.count == 1,
            let tabNavigationCell = tabNavigationCollectionView.visibleCells.first as? tabNavigationCell, tabNavigationCell.cellCollectionView.section == .Announcements {
            
            tabNavigationCell.cellCollectionView.reloadData()
            
        } else {
            
            print("ERROR: Unable to refresh announcements. The announcements CollectionView is out of reach.")
            
        }
        
    }
    
    func toggleVisibility(forAnnouncementAt index: Int) {
        
        print("TOGGLING VISIBILITY")
        
        if index == -1 {
            
            print("ERROR: Unable to perform action. Returned index is out of bounds (-1).")
            return
            
        }
        
        announcementList[index].isPublic = !announcementList[index].isPublic
        
        if tabNavigationCollectionView.visibleCells.count == 1,
            let tabNavigationCell = tabNavigationCollectionView.visibleCells.first as? tabNavigationCell, tabNavigationCell.cellCollectionView.section == .Announcements {
            
            tabNavigationCell.cellCollectionView.reloadData()
            
        } else {
            
            print("ERROR: Unable to refresh announcements. The announcements CollectionView is out of reach.")
            
        }
        
    }
    
    func editAnnouncement(forAnnouncementAt index: Int, newImage: UIImage?, newTitle: String?, newBody: NSAttributedString?) {
        
        print("EDITING ANNOUNCEMENT")
        
        if index == -1 {
            
            print("ERROR: Unable to perform action. Returned index is out of bounds (-1).")
            return
            
        }
        
        if newImage != nil || newTitle != nil || newBody != nil {
            
            if let newImage = newImage { self.announcementList[index].image = newImage }
            if let newTitle = newTitle { self.announcementList[index].title = newTitle }
            if let newBody = newBody { self.announcementList[index].body = newBody }
            
            if tabNavigationCollectionView.visibleCells.count == 1,
                let tabNavigationCell = tabNavigationCollectionView.visibleCells.first as? tabNavigationCell, tabNavigationCell.cellCollectionView.section == .Announcements {
                
                tabNavigationCell.cellCollectionView.reloadData()
                
            } else {
                
                print("ERROR: Unable to refresh announcements. The announcements CollectionView is out of reach.")
                
            }
            
        }
        
    }
    
    func deleteAnnouncement(forAnnouncementAt index: Int) {
        
        if index == -1 {
            
            print("ERROR: Unable to perform action. Returned index is out of bounds (-1).")
            return
            
        }
        
        announcementList.remove(at: index)
        refreshPinAnnouncements()
        
        if tabNavigationCollectionView.visibleCells.count == 1,
            let tabNavigationCell = tabNavigationCollectionView.visibleCells.first as? tabNavigationCell, tabNavigationCell.cellCollectionView.section == .Announcements {
            
            tabNavigationCell.cellCollectionView.reloadData()
            
        } else {
            
            print("ERROR: Unable to refresh announcements. The announcements CollectionView is out of reach.")
            
        }
        
    }
    
}




