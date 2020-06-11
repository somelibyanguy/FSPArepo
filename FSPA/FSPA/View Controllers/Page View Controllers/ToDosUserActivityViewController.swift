//
//  ToDosUserActivityViewController.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 6/3/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit

class ToDosUserActivityViewController: UIViewController {
    
    let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 3)
    let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 3)
    
    private(set) var userActivityList: [String] = []
    private(set) var userActivityType: String = "Completed List (0)"
    
    lazy private var userActivityContainerView: UIView = {
        
        var userActivityContainerView = UIView(frame: .zero)
        userActivityContainerView.backgroundColor = .AnalGold
        userActivityContainerView.addShadowAndRoundCorners(shadowOpacity: 0.0)
        
        userActivityContainerView.addSubview(userActivityCloseButton)
        userActivityCloseButton.translatesAutoresizingMaskIntoConstraints = false
        userActivityCloseButton.topAnchor.constraint(equalTo: userActivityContainerView.topAnchor, constant: verticalEdgeInset).isActive = true
        userActivityCloseButton.leadingAnchor.constraint(equalTo: userActivityContainerView.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        userActivityCloseButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 9)).isActive = true
        userActivityCloseButton.heightAnchor.constraint(equalTo: userActivityCloseButton.widthAnchor).isActive = true
        
        userActivityContainerView.addSubview(userActivityLabel)
        userActivityLabel.translatesAutoresizingMaskIntoConstraints = false
        userActivityLabel.topAnchor.constraint(equalTo: userActivityContainerView.topAnchor, constant: verticalEdgeInset).isActive = true
        userActivityLabel.trailingAnchor.constraint(equalTo: userActivityContainerView.trailingAnchor, constant: -horizontalEdgeInset*2).isActive = true
        userActivityLabel.leadingAnchor.constraint(equalTo: userActivityCloseButton.trailingAnchor, constant: horizontalEdgeInset).isActive = true
        userActivityLabel.bottomAnchor.constraint(equalTo: userActivityCloseButton.bottomAnchor).isActive = true
        
        userActivityContainerView.addSubview(userActivityCollectionView)
        userActivityCollectionView.translatesAutoresizingMaskIntoConstraints = false
        userActivityCollectionView.topAnchor.constraint(equalTo: userActivityCloseButton.bottomAnchor).isActive = true
        userActivityCollectionView.leadingAnchor.constraint(equalTo: userActivityContainerView.leadingAnchor).isActive = true
        userActivityCollectionView.trailingAnchor.constraint(equalTo: userActivityContainerView.trailingAnchor).isActive = true
        userActivityCollectionView.bottomAnchor.constraint(equalTo: userActivityContainerView.bottomAnchor).isActive = true
        
        return userActivityContainerView
        
    }()
    
    lazy private var userActivityCloseButton: BubbleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2)
        
        var userActivityCloseButton = BubbleButton(bubbleButtonImage: UIImage.closeXMarkIcon.withTintColor(UIColor.PrimaryCrimson))
        userActivityCloseButton.backgroundColor = UIColor.AnalGold
        userActivityCloseButton.toggleShadow()
        userActivityCloseButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        userActivityCloseButton.addTarget(self, action: #selector(closeUserActivity(sender:)), for: .touchUpInside)
        return userActivityCloseButton
        
    }()
    
    lazy private var userActivityLabel: UILabel = {
        
        var userActivityLabel = UILabel()
        userActivityLabel.text = userActivityType
        userActivityLabel.textColor = UIColor.PrimaryCrimson
        userActivityLabel.textAlignment = .right
        userActivityLabel.backgroundColor = .clear
        userActivityLabel.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize)!)
        return userActivityLabel
        
    }()
    
    lazy private var userActivityCollectionView: ToDoActivityCollectionView = {
        
        var userActivityCollectionView = ToDoActivityCollectionView()
        userActivityCollectionView.addShadowAndRoundCorners(shadowOpacity: 0.0)
        userActivityCollectionView.delegate = self
        userActivityCollectionView.dataSource = self
        return userActivityCollectionView
        
    }()
    
    convenience init() {
        
        self.init(userList: nil, activityType: nil)
        
    }
    
    init(userList: [String]?, activityType: String?) {
        
        super.init(nibName: nil, bundle: nil)
        
        if let newUserList = userList, !newUserList.isEmpty { userActivityList = newUserList }
        if let newActivityType = activityType { userActivityType = newActivityType }
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        
        view.addSubview(userActivityContainerView)
        userActivityContainerView.translatesAutoresizingMaskIntoConstraints = false
        userActivityContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userActivityContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        userActivityContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92).isActive = true
        userActivityContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.95).isActive = true
        
    }
    
    @objc private func closeUserActivity(sender: BubbleButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension ToDosUserActivityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let collectionView = collectionView as? ToDoActivityCollectionView {
            
            if userActivityList.count == 0 {
                
                let placeholderImageView = UIImageView(image: UIImage.membersCollectionViewPlaceholder.withTintColor(UIColor.PrimaryCrimson))
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
            
            return userActivityList.count
            
        } else {
            
            print("ERROR")
            
            return 0
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let collectionView = collectionView as? ToDoActivityCollectionView {
            
            if let toDoActivityCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView.cellID, for: indexPath) as? ToDoActivityCell {
                
                toDoActivityCell.toDoUsernameLabel.text = userActivityList[indexPath.item]
                
                return toDoActivityCell
                
            } else {
                
                return UICollectionViewCell()
                
            }
            
        } else {
            
            return UICollectionViewCell()
            
        }
        
    }
    
}

final class ToDoActivityCollectionView: UICollectionView {
    
    let cellID = "ToDoActivityCell"
    
    private let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    private let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    init() {
        
        let toDoActivityCollectionViewLayout = DynamicHeightFlowLayout()
        toDoActivityCollectionViewLayout.minimumLineSpacing = verticalEdgeInset
        toDoActivityCollectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        toDoActivityCollectionViewLayout.sectionInset = UIEdgeInsets(top: verticalEdgeInset, left: horizontalEdgeInset, bottom: verticalEdgeInset, right: horizontalEdgeInset)
        toDoActivityCollectionViewLayout.scrollDirection = .vertical
        
        super.init(frame: .zero, collectionViewLayout: toDoActivityCollectionViewLayout)
        configureCollectionView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        configureCollectionView()
        
    }
    
    private func configureCollectionView() {
        
        self.register(ToDoActivityCell.self, forCellWithReuseIdentifier: self.cellID)
        self.backgroundColor = UIColor.AnalGold
        self.showsVerticalScrollIndicator = false
        
    }
    
}

final class ToDoActivityCell: UICollectionViewCell {
    
    let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    lazy private(set) var toDoUserImageView: UIImageView = {
        
        var toDoUserImageView = UIImageView()
        toDoUserImageView.image = .defaultMembersProfileImage
        toDoUserImageView.contentMode = .scaleAspectFill
        toDoUserImageView.addShadowAndRoundCorners(shadowOpacity: 0.0, topLeftMask: false, bottomLeftMask: false)
        toDoUserImageView.clipsToBounds = true
        return toDoUserImageView
        
    }()
    
    lazy private(set) var toDoUsernameLabel: UILabel = {
        
        var toDoUsernameLabel = UILabel()
        toDoUsernameLabel.text = "Name Placeholder"
        toDoUsernameLabel.textAlignment = .left
        toDoUsernameLabel.numberOfLines = 2
        toDoUsernameLabel.textColor = UIColor.AnalGold
        toDoUsernameLabel.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .callout).pointSize)!)
        return toDoUsernameLabel
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configureCell()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        configureCell()
        
    }
    
    private func configureCell() {
        
        contentView.addShadowAndRoundCorners()
        contentView.backgroundColor = UIColor.PrimaryCrimson
        
        contentView.addSubview(toDoUserImageView)
        toDoUserImageView.translatesAutoresizingMaskIntoConstraints = false
        toDoUserImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        toDoUserImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        toDoUserImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        toDoUserImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25).isActive = true
        toDoUserImageView.heightAnchor.constraint(equalTo: toDoUserImageView.widthAnchor).isActive = true
        
        contentView.addSubview(toDoUsernameLabel)
        toDoUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        toDoUsernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalEdgeInset).isActive = true
        toDoUsernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        toDoUsernameLabel.trailingAnchor.constraint(equalTo: toDoUserImageView.leadingAnchor, constant: -horizontalEdgeInset).isActive = true
        toDoUsernameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalEdgeInset).isActive = true
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        layoutAttributes.frame.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
        
    }
    
}
