//
//  TabNavigationCollectionView.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 4/18/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit

final class TabNavigationCollectionView: UICollectionView {
    
    let cellID = "TabNavigationCell"
    
    init() {
        
        let tabNavigationCollectionViewLayout = UICollectionViewFlowLayout()
        tabNavigationCollectionViewLayout.minimumLineSpacing = 0
        tabNavigationCollectionViewLayout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: tabNavigationCollectionViewLayout)
        configureCollectionView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        configureCollectionView()
        
    }
    
    private func configureCollectionView() {
        
        self.register(tabNavigationCell.self, forCellWithReuseIdentifier: self.cellID)
        self.backgroundColor = UIColor.BgGray
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        
    }
    
}

final class tabNavigationCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    let cellCollectionView = TabCollectionView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configureCell()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        configureCell()
        
    }
    
    private func configureCell() {
        
        contentView.addSubview(cellCollectionView)
        cellCollectionView.translatesAutoresizingMaskIntoConstraints = false
        cellCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
    }
    
    func setSection(section: Section) {
        
        cellCollectionView.section = section
        
    }
    
}

final class TabCollectionView: UICollectionView {
    
    lazy fileprivate(set) var section: Section = .Default
    lazy private(set) var tabCellID: String = section.rawValue + "Cell"
    
    let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    
    convenience init() {
        
        self.init(section: nil)
        
    }
    
    init(section: Section?) {
        
        let tabCollectionViewLayout = DynamicHeightFlowLayout()
        tabCollectionViewLayout.minimumLineSpacing = verticalEdgeInset
        tabCollectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        tabCollectionViewLayout.sectionInset = UIEdgeInsets(top: verticalEdgeInset, left: horizontalEdgeInset, bottom: verticalEdgeInset, right: horizontalEdgeInset)
        tabCollectionViewLayout.scrollDirection = .vertical
        
        super.init(frame: .zero, collectionViewLayout: tabCollectionViewLayout)
        
        if let newSection = section { self.section = newSection }
        
        configureCollectionView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        configureCollectionView()
        
    }
    
    private func configureCollectionView() {
            
        self.register(AnnouncementsCell.self, forCellWithReuseIdentifier: Section.Announcements.rawValue + "Cell")
        self.register(ToDoCell.self, forCellWithReuseIdentifier: Section.ToDo.rawValue + "Cell")
        self.register(MembersCell.self, forCellWithReuseIdentifier: Section.Members.rawValue + "Cell")
        self.register(DefaultCell.self, forCellWithReuseIdentifier: Section.Default.rawValue + "Cell")
        
        self.backgroundColor = UIColor.BgGray
        self.showsVerticalScrollIndicator = false
        
    }
    
}

final class AnnouncementsCell: UICollectionViewCell {
    
    let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    lazy private(set) var newAnnouncementsNotificationView: UIView = {
        
        let newLabel = UILabel()
        newLabel.text = "· NEW ·"
        newLabel.textAlignment = .center
        newLabel.numberOfLines = 1
        newLabel.textColor = .white
        newLabel.font = UIFont(name: "HelveticaNeue-Bold", size: verticalEdgeInset*1.2)
        
        var newAnnouncementsNotificationView = UIView()
        newAnnouncementsNotificationView.addShadowAndRoundCorners(shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0))
        newAnnouncementsNotificationView.backgroundColor = .PrimaryCrimson
        
        newAnnouncementsNotificationView.translatesAutoresizingMaskIntoConstraints = false
        newAnnouncementsNotificationView.widthAnchor.constraint(equalToConstant: newLabel.intrinsicContentSize.width + (horizontalEdgeInset*0.8)).isActive = true
        
        newAnnouncementsNotificationView.addSubview(newLabel)
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.topAnchor.constraint(equalTo: newAnnouncementsNotificationView.topAnchor, constant: verticalEdgeInset*0.33).isActive = true
        newLabel.bottomAnchor.constraint(equalTo: newAnnouncementsNotificationView.bottomAnchor, constant: -verticalEdgeInset*0.33).isActive = true
        newLabel.leadingAnchor.constraint(equalTo: newAnnouncementsNotificationView.leadingAnchor, constant: horizontalEdgeInset*0.4).isActive = true
        newLabel.trailingAnchor.constraint(equalTo: newAnnouncementsNotificationView.trailingAnchor, constant: -horizontalEdgeInset*0.4).isActive = true
        
        newAnnouncementsNotificationView.alpha = 0.0
        
        return newAnnouncementsNotificationView
        
    }()
    
    lazy private(set) var announcementsImageView: UIImageView = {
        
        var announcementImageView = UIImageView()
        announcementImageView.image = .defaultAnnouncementsImage
        announcementImageView.contentMode = .scaleAspectFill
        announcementImageView.addShadowAndRoundCorners(shadowOpacity: 0.0, bottomRightMask: false, bottomLeftMask: false)
        announcementImageView.clipsToBounds = true
        return announcementImageView
        
    }()
    
    lazy private(set) var announcementsLabelsStackView: UIStackView = {
        
        var announcementsLabelsStackView = UIStackView(arrangedSubviews: [announcementsTitleLabel, announcementsBodyLabel])
        announcementsLabelsStackView.axis = .vertical
        announcementsLabelsStackView.alignment = .leading
        announcementsLabelsStackView.distribution = .fillProportionally
        announcementsLabelsStackView.spacing = verticalEdgeInset
        return announcementsLabelsStackView
        
    }()
    
    lazy private(set) var announcementsTitleLabel: UILabel = {
        
        var announcementsTitleLabel = UILabel()
        announcementsTitleLabel.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize)!)
        announcementsTitleLabel.text = "Title Text Placeholder"
        announcementsTitleLabel.textAlignment = .left
        announcementsTitleLabel.numberOfLines = 3
        announcementsTitleLabel.textColor = UIColor.black
        return announcementsTitleLabel
        
    }()
    
    lazy private(set) var announcementsBodyLabel: UILabel = {
        
        var announcementsBodyLabel = UILabel()
        announcementsBodyLabel.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-Medium", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize)!)
        announcementsBodyLabel.text = "Body Text Placeholder"
        announcementsBodyLabel.textAlignment = .left
        announcementsBodyLabel.numberOfLines = 2
        announcementsBodyLabel.textColor = UIColor.lightGray
        return announcementsBodyLabel
        
    }()
    
    lazy private(set) var announcementsPinButton: BubbleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2.3)
        
        var announcementsPinButton = BubbleButton(bubbleButtonImage: UIImage.pinIcon.withTintColor(UIColor.white))
        announcementsPinButton.backgroundColor = UIColor.PrimaryCrimson
        announcementsPinButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        announcementsPinButton.isUserInteractionEnabled = false
        announcementsPinButton.isHidden = true
        return announcementsPinButton
        
    }()
    
    lazy private(set) var announcementsVisibilityButton: BubbleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2.3)
        
        var announcementsVisibilityButton = BubbleButton(bubbleButtonImage: UIImage.visibleEyeIcon.withTintColor(UIColor.white))
        announcementsVisibilityButton.backgroundColor = UIColor.PrimaryCrimson
        announcementsVisibilityButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        announcementsVisibilityButton.isUserInteractionEnabled = false
        announcementsVisibilityButton.isHidden = true
        return announcementsVisibilityButton
        
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
        
        contentView.addShadowAndRoundCorners(shadowOffset: CGSize(width: 0.0, height: 0.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        contentView.backgroundColor = .white
        
        contentView.addSubview(announcementsImageView)
        announcementsImageView.translatesAutoresizingMaskIntoConstraints = false
        announcementsImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        announcementsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        announcementsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        announcementsImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2).isActive = true
        
        contentView.addSubview(announcementsLabelsStackView)
        announcementsLabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        announcementsLabelsStackView.topAnchor.constraint(equalTo: announcementsImageView.bottomAnchor, constant: verticalEdgeInset).isActive = true
        announcementsLabelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        announcementsLabelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalEdgeInset).isActive = true
        announcementsLabelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalEdgeInset).isActive = true
        
        contentView.addSubview(announcementsPinButton)
        announcementsPinButton.translatesAutoresizingMaskIntoConstraints = false
        announcementsPinButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalEdgeInset).isActive = true
        announcementsPinButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        announcementsPinButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1).isActive = true
        announcementsPinButton.heightAnchor.constraint(equalTo: announcementsPinButton.widthAnchor).isActive = true
        
        contentView.addSubview(announcementsVisibilityButton)
        announcementsVisibilityButton.translatesAutoresizingMaskIntoConstraints = false
        announcementsVisibilityButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalEdgeInset).isActive = true
        announcementsVisibilityButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalEdgeInset).isActive = true
        announcementsVisibilityButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1).isActive = true
        announcementsVisibilityButton.heightAnchor.constraint(equalTo: announcementsVisibilityButton.widthAnchor).isActive = true
        
        contentView.addSubview(newAnnouncementsNotificationView)
        newAnnouncementsNotificationView.translatesAutoresizingMaskIntoConstraints = false
        newAnnouncementsNotificationView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        newAnnouncementsNotificationView.centerYAnchor.constraint(equalTo: announcementsPinButton.centerYAnchor).isActive = true
        newAnnouncementsNotificationView.heightAnchor.constraint(equalTo: announcementsPinButton.heightAnchor, multiplier: 0.77).isActive = true
       
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        layoutAttributes.frame.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
        
    }
    
}

final class ToDoCell: UICollectionViewCell {
    
    let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 3)
    
    lazy private(set) var toDoTitleLabel: UILabel = {
        
        var toDoTitleLabel = UILabel()
        toDoTitleLabel.text = "To-Do Title Placeholder"
        toDoTitleLabel.textAlignment = .left
        toDoTitleLabel.numberOfLines = 1
        toDoTitleLabel.textColor = UIColor.BgGray
        toDoTitleLabel.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize)!)
        return toDoTitleLabel
        
    }()
    
    lazy private(set) var toDoDeadlineLabel: UILabel = {
        
        var toDoDeadlineLabel = UILabel()
        toDoDeadlineLabel.text = "No Deadline"
        toDoDeadlineLabel.textAlignment = .left
        toDoDeadlineLabel.numberOfLines = 1
        toDoDeadlineLabel.textColor = UIColor.AnalGold
        toDoDeadlineLabel.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-MediumItalic", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize)!)
        return toDoDeadlineLabel
        
    }()
    
    lazy private(set) var toDoCheckBoxButton: CheckBoxButton = {
        
        var toDoCheckBoxButton = CheckBoxButton(checkMarkColor: UIColor.PrimaryCrimson)
        return toDoCheckBoxButton
        
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
        
        contentView.addShadowAndRoundCorners(shadowOffset: CGSize(width: 0.0, height: 0.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        contentView.backgroundColor = .PrimaryCrimson
        
        contentView.addSubview(toDoCheckBoxButton)
        toDoCheckBoxButton.translatesAutoresizingMaskIntoConstraints = false
        toDoCheckBoxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        toDoCheckBoxButton.widthAnchor.constraint(equalToConstant: toDoTitleLabel.font.pointSize*1.6).isActive = true
        toDoCheckBoxButton.heightAnchor.constraint(equalTo: toDoCheckBoxButton.widthAnchor, multiplier: 1).isActive = true
        toDoCheckBoxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalEdgeInset).isActive = true
        
        contentView.addSubview(toDoTitleLabel)
        toDoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        toDoTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: horizontalEdgeInset).isActive = true
        toDoTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        toDoTitleLabel.trailingAnchor.constraint(equalTo: toDoCheckBoxButton.leadingAnchor, constant: -horizontalEdgeInset).isActive = true
        
        contentView.addSubview(toDoDeadlineLabel)
        toDoDeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        toDoDeadlineLabel.topAnchor.constraint(equalTo: toDoTitleLabel.bottomAnchor, constant: verticalEdgeInset).isActive = true
        toDoDeadlineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        toDoDeadlineLabel.trailingAnchor.constraint(equalTo: toDoCheckBoxButton.leadingAnchor, constant: -horizontalEdgeInset).isActive = true
        toDoDeadlineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -horizontalEdgeInset).isActive = true
        
    }
    
    func setToDoDeadline(deadline: Date?) {
        
        if let newDeadline = deadline {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy, h:mm a"
            
            toDoDeadlineLabel.text = "Deadline: " + formatter.string(from: newDeadline)
            
        } else {
            
            toDoDeadlineLabel.text = "No Deadline"
            
        }
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        layoutAttributes.frame.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
        
    }
    
}

final class MembersCell: UICollectionViewCell {
    
    let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    
    lazy private(set) var membersImageView: UIImageView = {
        
        var membersImageView = UIImageView()
        membersImageView.image = .defaultMembersProfileImage
        membersImageView.contentMode = .scaleAspectFill
        membersImageView.addShadowAndRoundCorners(shadowOpacity: 0.0, topLeftMask: false, bottomLeftMask: false)
        membersImageView.clipsToBounds = true
        return membersImageView
        
    }()
    
    lazy private(set) var membersInfoStackView: UIStackView = {
        
        var membersInfoStackView = UIStackView()
        membersInfoStackView.axis = .vertical
        membersInfoStackView.alignment = .leading
        membersInfoStackView.distribution = .fillProportionally
        membersInfoStackView.spacing = verticalEdgeInset
        
        membersInfoStackView.addArrangedSubview(membersNameLabel)
        membersInfoStackView.addArrangedSubview(membersTitleLabel)
        
        return membersInfoStackView
        
    }()
    
    lazy private(set) var membersNameLabel: UILabel = {
        
        var membersNameLabel = UILabel()
        membersNameLabel.text = "Members Name Placeholder"
        membersNameLabel.textAlignment = .left
        membersNameLabel.numberOfLines = 2
        membersNameLabel.textColor = UIColor.AnalGold
        membersNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: .getWidthFitSize(minSize: 16.0, maxSize: 20.0))
        return membersNameLabel
        
    }()
    
    lazy private(set) var membersTitleLabel: UILabel = {
        
        var membersTitleLabel = UILabel()
        membersTitleLabel.text = "Members Title Placeholder"
        membersTitleLabel.textAlignment = .left
        membersTitleLabel.numberOfLines = 2
        membersTitleLabel.textColor = UIColor.AnalGold
        membersTitleLabel.font = UIFont(name: "HelveticaNeue-MediumItalic", size: .getWidthFitSize(minSize: 13.0, maxSize: 17.0))
        return membersTitleLabel
        
        
    }()
    
    private(set) var membersIsHighlighted = false {
        
        willSet (newState) {
            
            if membersIsHighlighted != newState {
                
                if newState { // faculty is now highlighted:
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                    
                                    self.membersTitleLabel.textColor = UIColor.PrimaryCrimson
                                    self.membersNameLabel.textColor = UIColor.PrimaryCrimson
                                    self.contentView.backgroundColor = UIColor.AnalGold
                                    
                    })
                    
                } else { // faculty is not highlighted yet:
            
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                                    
                                    self.membersTitleLabel.textColor = UIColor.AnalGold
                                    self.membersNameLabel.textColor = UIColor.AnalGold
                                    self.contentView.backgroundColor = UIColor.PrimaryCrimson
                                    
                    })
                    
                }
                
            }
            
        }
        
    }
    
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
        
        contentView.addSubview(membersImageView)
        membersImageView.translatesAutoresizingMaskIntoConstraints = false
        membersImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        membersImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        membersImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        membersImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4).isActive = true
        
        contentView.addSubview(membersInfoStackView)
        membersInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        membersInfoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: horizontalEdgeInset).isActive = true
        membersInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        membersInfoStackView.trailingAnchor.constraint(equalTo: membersImageView.leadingAnchor, constant: -horizontalEdgeInset).isActive = true
        membersInfoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -horizontalEdgeInset).isActive = true
        
    }
    
    func toggleMembers(isHighlighted: Bool) {
        
        self.membersIsHighlighted = isHighlighted
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        layoutAttributes.frame.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
        
    }
    
}

final class DefaultCell: UICollectionViewCell {
    
    let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    
    lazy private(set) var defaultLabel: UILabel = {
        
        var defaultLabel = UILabel()
        defaultLabel.backgroundColor = .lightGray
        defaultLabel.text = "Default Cell"
        defaultLabel.textAlignment = .center
        defaultLabel.numberOfLines = 1
        defaultLabel.textColor = UIColor.BgGray
        defaultLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: UIFont(name: "HelveticaNeue-Light", size: UIFont.labelFontSize)!, maximumPointSize: 22.0)
        defaultLabel.adjustsFontForContentSizeCategory = true
        return defaultLabel
        
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
        
        contentView.addShadowAndRoundCorners(shadowOffset: CGSize(width: 0.0, height: 0.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        
        contentView.addSubview(defaultLabel)
        defaultLabel.translatesAutoresizingMaskIntoConstraints = false
        defaultLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        defaultLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        defaultLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        defaultLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        layoutAttributes.frame.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
        
    }
    
}

final class DynamicHeightFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
        
        layoutAttributesObjects?.forEach({ layoutAttributes in
            
            if layoutAttributes.representedElementCategory == .cell {
                
                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                    
                    layoutAttributes.frame = newFrame
                    
                }
                
            }
            
        })
        
        return layoutAttributesObjects
        
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let collectionView = collectionView else { fatalError() }
        
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else { return nil }

        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
        
    }

}




