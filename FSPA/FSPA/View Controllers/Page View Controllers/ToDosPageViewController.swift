//
//  ToDosPageViewController.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 5/24/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit

struct ToDo {
    
    var title: String = "Title Text Placeholder"
    var details: NSAttributedString = NSAttributedString(string: "Details Text Placeholder", attributes: [NSAttributedString.Key.font : UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .callout).pointSize)!)])
    var deadline: Date?
    var usersLeftToComplete: [String] = []
    var usersThatCompleted: [String] = []
    var isPublic = false
    
}

class ToDosPageViewController: UIViewController {
    
    let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    private var currentToDo: ToDo = ToDo()
    private var toDoIndex: Int = -1
    
    weak var delegate: ToDosPageViewControllerDelegate?
    
    lazy private var tapOutGesture: UITapGestureRecognizer = {
        
        var tapOutGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTapOut))
        tapOutGesture.cancelsTouchesInView = true
        return tapOutGesture
        
    }()
    
    lazy private var toDoCloseButton: BubbleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2)
        
        var toDoCloseButton = BubbleButton(bubbleButtonImage: UIImage.closeXMarkIcon.withTintColor(UIColor.white))
        toDoCloseButton.backgroundColor = UIColor.PrimaryCrimson
        toDoCloseButton.toggleShadow()
        toDoCloseButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        toDoCloseButton.addTarget(self, action: #selector(closeToDo(sender:)), for: .touchUpInside)
        return toDoCloseButton
        
    }()
    
    lazy private var toDoDeleteButton: BubbleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2)
        
        var toDoDeleteButton = BubbleButton(bubbleButtonImage: UIImage.deleteIcon.withTintColor(UIColor.PrimaryCrimson))
        toDoDeleteButton.backgroundColor = .white
        toDoDeleteButton.toggleShadow()
        toDoDeleteButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        toDoDeleteButton.addTarget(self, action: #selector(deleteToDo(sender:)), for: .touchUpInside)
        toDoDeleteButton.alpha = 0.0
        return toDoDeleteButton
        
    }()
    
    lazy private var toDoRevertChangesButton: BubbleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2.5)
        
        var toDoRevertChangesButton = BubbleButton(bubbleButtonImage: UIImage.revertChangesArrowIcon.withTintColor(UIColor.PrimaryCrimson))
        toDoRevertChangesButton.backgroundColor = .white
        toDoRevertChangesButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        toDoRevertChangesButton.alpha = 0.0
        toDoRevertChangesButton.addTarget(self, action: #selector(revertEditingChanges(sender:)), for: .touchUpInside)
        return toDoRevertChangesButton
        
    }()
    
    lazy private var toDoEditButton: ToggleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2)
        
        var toDoEditButton = ToggleButton(toggleButtonOffImage: UIImage.editPencilIcon, toggleButtonOffImageColor: UIColor.white, toggleButtonOnImage: UIImage.floppyDiskSaveIcon, toggleButtonOnImageColor: UIColor.PrimaryCrimson)
        toDoEditButton.toggleShadow()
        toDoEditButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        toDoEditButton.addTarget(self, action: #selector(toggleToDoEditing(sender:)), for: .touchUpInside)
        return toDoEditButton
        
    }()
    
    lazy private var toDoPublishButton: ToggleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 1.5)
        
        var toDoPublishButton = ToggleButton(toggleButtonOffImage: UIImage.notVisibleEyeIcon, toggleButtonOffImageColor: UIColor.white, toggleButtonOnImage: UIImage.visibleEyeIcon, toggleButtonOnImageColor: UIColor.PrimaryCrimson)
        toDoPublishButton.toggleShadow()
        toDoPublishButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        
        if currentToDo.isPublic { toDoPublishButton.toggle() }
        
        toDoPublishButton.addTarget(self, action: #selector(toggleToDoVisibility(sender:)), for: .touchUpInside)
        return toDoPublishButton
        
    }()
    
    lazy private var toDoScrollView: UIScrollView = {
        
        var titleAndCheckBoxContainerView = UIView(frame: .zero)
        titleAndCheckBoxContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleAndCheckBoxContainerView.addSubview(toDoCheckBoxButton)
        toDoCheckBoxButton.topAnchor.constraint(equalTo: titleAndCheckBoxContainerView.topAnchor, constant: toDoTitleTextView.textContainerInset.top).isActive = true
        toDoCheckBoxButton.leadingAnchor.constraint(equalTo: titleAndCheckBoxContainerView.leadingAnchor).isActive = true
        titleAndCheckBoxContainerView.addSubview(toDoTitleTextView)
        toDoTitleTextView.translatesAutoresizingMaskIntoConstraints = false
        toDoTitleTextView.topAnchor.constraint(equalTo: titleAndCheckBoxContainerView.topAnchor).isActive = true
        toDoTitleTextView.leadingAnchor.constraint(equalTo: toDoCheckBoxButton.trailingAnchor, constant: horizontalEdgeInset).isActive = true
        toDoTitleTextView.trailingAnchor.constraint(equalTo: titleAndCheckBoxContainerView.trailingAnchor).isActive = true
        toDoTitleTextView.bottomAnchor.constraint(equalTo: titleAndCheckBoxContainerView.bottomAnchor).isActive = true
        
        var toDoStackView = UIStackView(arrangedSubviews: [titleAndCheckBoxContainerView, toDoDeadlineTextView, toDoDetailsTextView, toDoCompletedUsersButton, toDoLeftToCompleteUsersButton])
        toDoStackView.axis = .vertical
        toDoStackView.alignment = .fill
        toDoStackView.distribution = .fill
        toDoStackView.spacing = verticalEdgeInset
        toDoStackView.isLayoutMarginsRelativeArrangement = true
        toDoStackView.layoutMargins = UIEdgeInsets(top: verticalEdgeInset, left: horizontalEdgeInset, bottom: verticalEdgeInset, right: horizontalEdgeInset)
       
        var toDoScrollView = UIScrollView()
        toDoScrollView.isScrollEnabled = true
        toDoScrollView.alwaysBounceVertical = true
        toDoScrollView.showsVerticalScrollIndicator = false
        
        toDoScrollView.translatesAutoresizingMaskIntoConstraints = false
        toDoScrollView.addSubview(toDoStackView)
        toDoStackView.translatesAutoresizingMaskIntoConstraints = false
        toDoStackView.topAnchor.constraint(equalTo: toDoScrollView.topAnchor).isActive = true
        toDoStackView.leadingAnchor.constraint(equalTo: toDoScrollView.leadingAnchor).isActive = true
        toDoStackView.trailingAnchor.constraint(equalTo: toDoScrollView.trailingAnchor).isActive = true
        toDoStackView.bottomAnchor.constraint(equalTo: toDoScrollView.bottomAnchor).isActive = true
        toDoStackView.widthAnchor.constraint(equalTo: toDoScrollView.widthAnchor).isActive = true
        
        return toDoScrollView
        
    }()
    
    lazy private var toDoCheckBoxButton: CheckBoxButton = {
        
        var toDoCheckBoxButton = CheckBoxButton(checkMarkColor: .PrimaryCrimson)
        
        if currentToDo.usersLeftToComplete.count == 0 && currentToDo.usersThatCompleted.count != 0 { toDoCheckBoxButton.toggleCheck() }
        
        toDoCheckBoxButton.addTarget(self, action: #selector(toggleToDoCheckBox(sender:)), for: .touchUpInside)
        toDoCheckBoxButton.translatesAutoresizingMaskIntoConstraints = false
        toDoCheckBoxButton.heightAnchor.constraint(equalToConstant: toDoTitleTextView.font!.pointSize*1.17).isActive = true
        toDoCheckBoxButton.widthAnchor.constraint(equalTo: toDoCheckBoxButton.heightAnchor).isActive = true
        return toDoCheckBoxButton
        
    }()
    
    lazy private var toDoTitleTextView: UITextView = {
        
        var toDoTitleTextView = UITextView()
        toDoTitleTextView.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2).pointSize)!)
        toDoTitleTextView.text = currentToDo.title
        toDoTitleTextView.textAlignment = .left
        toDoTitleTextView.sizeToFit()
        toDoTitleTextView.isScrollEnabled = false
        toDoTitleTextView.isEditable = false
        toDoTitleTextView.delegate = self
        toDoTitleTextView.textColor = UIColor.white
        toDoTitleTextView.backgroundColor = .PrimaryCrimson
        
        return toDoTitleTextView
        
    }()
    
    lazy private var toDoDeadlineTextView: DateTextView = {
        
        var toDoDeadlineTextView = DateTextView()
        toDoDeadlineTextView.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-MediumItalic", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize)!)
        toDoDeadlineTextView.textContainerInset = UIEdgeInsets(top: .zero, left: .zero, bottom: toDoDeadlineTextView.textContainerInset.bottom, right: .zero)
        toDoDeadlineTextView.textAlignment = .left
        toDoDeadlineTextView.sizeToFit()
        toDoDeadlineTextView.isScrollEnabled = false
        toDoDeadlineTextView.isEditable = false
        toDoDeadlineTextView.delegate = self
        toDoDeadlineTextView.textColor = UIColor.AnalGold
        toDoDeadlineTextView.backgroundColor = .PrimaryCrimson
        
        if let newDeadline = currentToDo.deadline {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy, h:mm a"
            
            toDoDeadlineTextView.text = "Deadline: " + formatter.string(from: newDeadline)
            
        } else {
            
            toDoDeadlineTextView.text = "No Deadline"
            
        }
        
        return toDoDeadlineTextView
        
    }()
    
    lazy private var toDoDetailsTextView: AttributedTextView = {
        
        var toDoDetailsTextView = AttributedTextView()
        toDoDetailsTextView.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .callout).pointSize)!)
        toDoDetailsTextView.textContainerInset = UIEdgeInsets(top: .zero, left: .zero, bottom: toDoDetailsTextView.textContainerInset.bottom, right: .zero)
        toDoDetailsTextView.attributedText = currentToDo.details
        toDoDetailsTextView.setHighlightColor(color: .AnalGold)
        toDoDetailsTextView.textColor = UIColor.white
        toDoDetailsTextView.backgroundColor = .PrimaryCrimson
        toDoDetailsTextView.delegate = self
        
        return toDoDetailsTextView
        
    }()
    
    lazy private var toDoCompletedUsersButton: BouncyButton = {
        
        var toDoCompletedUsersButton = BouncyButton(bouncyButtonImage: nil)
        toDoCompletedUsersButton.setImage(nil, for: .normal)
        toDoCompletedUsersButton.setTitle("Completed List (" + String(currentToDo.usersThatCompleted.count) + ")", for: .normal)
        toDoCompletedUsersButton.titleLabel!.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize)!)
        toDoCompletedUsersButton.titleLabel!.textAlignment = .center
        toDoCompletedUsersButton.setTitleColor(.PrimaryCrimson, for: .normal)
        toDoCompletedUsersButton.backgroundColor = .AnalGold
        toDoCompletedUsersButton.addShadowAndRoundCorners(shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0))
        toDoCompletedUsersButton.addTarget(self, action: #selector(showCompletedUserActivity(sender:)), for: .touchUpInside)
        return toDoCompletedUsersButton
        
    }()
    
    lazy private var toDoLeftToCompleteUsersButton: BouncyButton = {
        
        var toDoLeftToCompleteUsersButton = BouncyButton(bouncyButtonImage: nil)
        toDoLeftToCompleteUsersButton.setImage(nil, for: .normal)
        toDoLeftToCompleteUsersButton.setTitle("Left To Complete List (" + String(currentToDo.usersLeftToComplete.count) + ")", for: .normal)
        toDoLeftToCompleteUsersButton.titleLabel!.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize)!)
        toDoLeftToCompleteUsersButton.titleLabel!.textAlignment = .center
        toDoLeftToCompleteUsersButton.setTitleColor(.PrimaryCrimson, for: .normal)
        toDoLeftToCompleteUsersButton.backgroundColor = .AnalGold
        toDoLeftToCompleteUsersButton.addShadowAndRoundCorners(shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0))
        toDoLeftToCompleteUsersButton.addTarget(self, action: #selector(showLeftToCompleteUserActivity(sender:)), for: .touchUpInside)
        return toDoLeftToCompleteUsersButton
        
    }()
    
    convenience init() {
        
        self.init(toDo: nil, index: nil)
        
    }
    
    init(toDo: ToDo?, index: Int?) {
        
        super.init(nibName: nil, bundle: nil)
        
        if let newToDo = toDo { currentToDo = newToDo }
        if let newIndex = index { self.toDoIndex = newIndex }
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .PrimaryCrimson
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(toDoEditButton)
        toDoEditButton.translatesAutoresizingMaskIntoConstraints = false
        toDoEditButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset).isActive = true
        toDoEditButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalEdgeInset).isActive = true
        toDoEditButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 9)).isActive = true
        toDoEditButton.heightAnchor.constraint(equalTo: toDoEditButton.widthAnchor).isActive = true
        
        view.addSubview(toDoScrollView)
        toDoScrollView.topAnchor.constraint(equalTo: toDoEditButton.bottomAnchor).isActive = true
        toDoScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        toDoScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toDoScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(toDoCloseButton)
        toDoCloseButton.translatesAutoresizingMaskIntoConstraints = false
        toDoCloseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset).isActive = true
        toDoCloseButton.centerXAnchor.constraint(equalTo: toDoCheckBoxButton.centerXAnchor).isActive = true
        toDoCloseButton.widthAnchor.constraint(equalTo: toDoEditButton.widthAnchor).isActive = true
        toDoCloseButton.heightAnchor.constraint(equalTo: toDoCloseButton.widthAnchor).isActive = true
        
        view.addSubview(toDoRevertChangesButton)
        toDoRevertChangesButton.translatesAutoresizingMaskIntoConstraints = false
        toDoRevertChangesButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset).isActive = true
        toDoRevertChangesButton.trailingAnchor.constraint(equalTo: toDoEditButton.leadingAnchor, constant: -horizontalEdgeInset).isActive = true
        toDoRevertChangesButton.widthAnchor.constraint(equalTo: toDoEditButton.widthAnchor).isActive = true
        toDoRevertChangesButton.heightAnchor.constraint(equalTo: toDoRevertChangesButton.widthAnchor).isActive = true
        
        view.addSubview(toDoPublishButton)
        toDoPublishButton.translatesAutoresizingMaskIntoConstraints = false
        toDoPublishButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset).isActive = true
        toDoPublishButton.trailingAnchor.constraint(equalTo: toDoEditButton.leadingAnchor, constant: -horizontalEdgeInset).isActive = true
        toDoPublishButton.widthAnchor.constraint(equalTo: toDoEditButton.widthAnchor).isActive = true
        toDoPublishButton.heightAnchor.constraint(equalTo: toDoPublishButton.widthAnchor).isActive = true
        
        view.addSubview(toDoDeleteButton)
        toDoDeleteButton.translatesAutoresizingMaskIntoConstraints = false
        toDoDeleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset).isActive = true
        toDoDeleteButton.trailingAnchor.constraint(equalTo: toDoPublishButton.leadingAnchor, constant: -horizontalEdgeInset).isActive = true
        toDoDeleteButton.widthAnchor.constraint(equalTo: toDoEditButton.widthAnchor).isActive = true
        toDoDeleteButton.heightAnchor.constraint(equalTo: toDoDeleteButton.widthAnchor).isActive = true
        
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        view.addGestureRecognizer(tapOutGesture)
        let userInfo = notification.userInfo!
        let keyboardSize: CGSize = ((userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size)
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + toDoDetailsTextView.attributedTextBar.frame.height, right: 0.0)
        toDoScrollView.contentInset = contentInsets
        toDoScrollView.scrollIndicatorInsets = contentInsets
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height

        if toDoTitleTextView.isFirstResponder, !visibleRect.contains(toDoTitleTextView.frame.origin)  {
        
            self.toDoScrollView.scrollRectToVisible((toDoTitleTextView.frame), animated: true)

        } else if toDoDetailsTextView.isFirstResponder {
            
            if !visibleRect.contains(toDoDetailsTextView.frame.origin) {
            
                self.toDoScrollView.scrollRectToVisible((toDoDetailsTextView.frame), animated: true)
                
            }
            
            if toDoDetailsTextView.isEditable {
                
                toDoDetailsTextView.toggleAttributedTextBar()
                
            }
            
        } else if toDoDeadlineTextView.isFirstResponder {
            
            if !visibleRect.contains(toDoDeadlineTextView.frame.origin) {
            
                self.toDoScrollView.scrollRectToVisible((toDoDeadlineTextView.frame), animated: true)
                
            }
            
        }
        
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        
        view.removeGestureRecognizer(tapOutGesture)
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        toDoScrollView.contentInset = contentInset
        
        if !toDoDetailsTextView.inputAccessoryView!.isHidden {
            
            toDoDetailsTextView.toggleAttributedTextBar()
            
        }
        
    }
    
    @objc private func hideKeyboardOnTapOut() {
        
        if toDoTitleTextView.isFirstResponder {
            
            toDoTitleTextView.resignFirstResponder()
            
        } else if toDoDetailsTextView.isFirstResponder {
            
            toDoDetailsTextView.resignFirstResponder()
            
        } else if toDoDeadlineTextView.isFirstResponder {
            
            toDoDeadlineTextView.resignFirstResponder()
            
        }
        
    }
    
    @objc private func closeToDo(sender: BouncyButton) {
        
       navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func deleteToDo(sender: BubbleButton) {
        
        let alert = UIAlertController(title: "Warning", message: "If you proceed, this to-do will be deleted indifinitely.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            
            self.delegate?.deleteToDo(forToDoAt: self.toDoIndex)
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func toggleToDoEditing(sender: ToggleButton) {
        
        if toDoEditButton.toggleState && toDoPublishButton.toggleState {
            
            let alert = UIAlertController(title: "Warning", message: "If you proceed, this to-do will be hidden for editing.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
                self.toDoEditButton.toggle()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
    
                self.toggleToDoEditingHelper()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            toggleToDoEditingHelper()
            
        }
        
    }
    
    private func toggleToDoEditingHelper() {
        
        toDoTitleTextView.isEditable = !toDoTitleTextView.isEditable
        toDoDeadlineTextView.isEditable = !toDoDeadlineTextView.isEditable
        toDoDetailsTextView.isEditable = !toDoDetailsTextView.isEditable
        
        if toDoEditButton.toggleState { // To-do will begin editing
            
            toDoDeleteButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3,
                           options: .curveEaseIn, animations: {
                            
                            self.toDoPublishButton.alpha = 0.0
                            self.toDoPublishButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                            self.toDoDeleteButton.alpha = 1.0
                            self.toDoDeleteButton.transform = .identity
                            self.toDoTitleTextView.setBottomBorder(color: .white, width: .getWidthFitSize(minSize: 2.5, maxSize: 3.5))
                            self.toDoDeadlineTextView.setBottomBorder(color: .AnalGold, width: .getWidthFitSize(minSize: 2.0, maxSize: 3.0))
                            self.toDoDetailsTextView.setBottomBorder(color: .white, width: .getWidthFitSize(minSize: 1.5, maxSize: 2.5))
                            self.toDoCompletedUsersButton.alpha = 0.0
                            self.toDoCompletedUsersButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                            self.toDoLeftToCompleteUsersButton.alpha = 0.0
                            self.toDoLeftToCompleteUsersButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                            self.toDoRevertChangesButton.alpha = 1.0
                            
            }, completion: { _ in
            
                self.toDoPublishButton.transform = CGAffineTransform.identity
                
                if self.toDoPublishButton.toggleState { self.toggleToDoVisibility(sender: self.toDoPublishButton) }
            
            })
            
        } else { // To-do will end editing
            
            toDoPublishButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            toDoCompletedUsersButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            toDoLeftToCompleteUsersButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3,
                           options: .curveEaseOut, animations: {
                            
                            self.toDoPublishButton.alpha = 1.0
                            self.toDoPublishButton.transform = CGAffineTransform.identity
                            self.toDoDeleteButton.alpha = 0.0
                            self.toDoDeleteButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                            self.toDoTitleTextView.setBottomBorder(color: .white, width: 0.0)
                            self.toDoDeadlineTextView.setBottomBorder(color: .AnalGold, width: 0.0)
                            self.toDoDetailsTextView.setBottomBorder(color: .white, width: 0.0)
                            self.toDoCompletedUsersButton.alpha = 1.0
                            self.toDoCompletedUsersButton.transform = CGAffineTransform.identity
                            self.toDoLeftToCompleteUsersButton.alpha = 1.0
                            self.toDoLeftToCompleteUsersButton.transform = CGAffineTransform.identity
                            self.toDoRevertChangesButton.alpha = 0.0
                            
            }, completion: { _ in
                
                var titleToReturn: String?
                var deadlineToReturn: Date?
                var detailsToReturn: NSAttributedString?
                
                if self.toDoTitleTextView.text != self.currentToDo.title {
                    
                    titleToReturn = self.toDoTitleTextView.text
                    self.currentToDo.title = titleToReturn!
                    
                }
                
                if self.toDoDeadlineTextView.text != "", self.toDoDeadlineTextView.getDate() != self.currentToDo.deadline  {
                    
                    deadlineToReturn = self.toDoDeadlineTextView.getDate()
                    self.currentToDo.deadline = deadlineToReturn
                    
                }
                
                if !self.toDoDetailsTextView.attributedText.isEqual(self.currentToDo.details) {
                    
                    detailsToReturn = self.toDoDetailsTextView.attributedText
                    self.currentToDo.details = detailsToReturn!
                    
                }
                
                self.delegate?.editToDo(forToDoAt: self.toDoIndex, newTitle: titleToReturn, newDeadline: deadlineToReturn, newDetails: detailsToReturn)
                
            })
            
        }
        
    }
    
    @objc private func revertEditingChanges(sender: BubbleButton) {
        
        toDoTitleTextView.text = currentToDo.title
        
        if currentToDo.deadline == nil {
            
            toDoDeadlineTextView.text = "No Deadline"
            
        } else {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy, h:mm a"
            toDoDeadlineTextView.text = "Deadline: " + formatter.string(from: currentToDo.deadline!)
            
        }

        toDoDetailsTextView.attributedText = currentToDo.details
        toDoEditButton.toggle()
        toggleToDoEditingHelper()
        
    }
    
    @objc private func toggleToDoVisibility(sender: ToggleButton) {
        
        if toDoPublishButton.toggleState && toDoEditButton.toggleState {
            
            delegate?.toggleVisibility(forToDoAt: toDoIndex)
            toDoPublishButton.toggle()
            
        } else if toDoPublishButton.toggleState && !toDoEditButton.toggleState {
            
            let alert = UIAlertController(title: "Warning", message: "If you proceed, this to-do will be public for all members.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
                self.toDoPublishButton.toggle()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                
                self.delegate?.toggleVisibility(forToDoAt: self.toDoIndex)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Warning", message: "If you proceed, this to-do will be hidden from all members.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
                self.toDoPublishButton.toggle()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                
                self.delegate?.toggleVisibility(forToDoAt: self.toDoIndex)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @objc private func toggleToDoCheckBox(sender: CheckBoxButton) {
        
        // Future Action
        
    }
    
    @objc private func showCompletedUserActivity(sender: BouncyButton) {
        
        let vc = ToDosUserActivityViewController(userList: currentToDo.usersThatCompleted, activityType: toDoCompletedUsersButton.titleLabel?.text)
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc private func showLeftToCompleteUserActivity(sender: BouncyButton) {
        
        let vc = ToDosUserActivityViewController(userList: currentToDo.usersLeftToComplete, activityType: toDoLeftToCompleteUsersButton.titleLabel?.text)
        present(vc, animated: true, completion: nil)
        
    }
    
}

final class DateTextView: UITextView {
    
    private var date: Date?
    
    lazy private var datePicker: UIDatePicker = {
        
        var datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        return datePicker
        
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        let dateToolbar = UIToolbar()
        dateToolbar.sizeToFit()
        let dateRemoveButton = UIBarButtonItem(title: "Remove", style: .done, target: self, action: #selector(removeActionDate))
        let dateSaveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveActionDate))
        let dateFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        dateToolbar.setItems([dateRemoveButton, dateFlexSpace, dateSaveButton], animated: true)
        
        inputView = datePicker
        inputAccessoryView = dateToolbar
        
    }
    
    @objc private func removeActionDate() {
        
        text = "No Deadline"
        
        if date != nil { date = nil }
        
        endEditing(true)
        
    }
    
    @objc private func saveActionDate() {
        
        setDateFromPicker()
        date = datePicker.date
        endEditing(true)
        
    }
    
    private func setDateFromPicker() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, h:mm a"
        text = "Deadline: " + formatter.string(from: datePicker.date)
        
    }
    
    fileprivate func getDate() -> Date? { return date }
    
}

extension ToDosPageViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView is AttributedTextView, textView.text == "" {
            
            textView.text = "Details Text Placeholder"
            
        } else if textView is DateTextView, textView.text == "" {
            
            textView.text = "No Deadline"
            
        } else if textView.text == "" {
            
            textView.text = "Title Text Placeholder"
            
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView is AttributedTextView, textView.text == "Details Text Placeholder" {
            
            textView.text = ""
            
        } else if textView.text == "Title Text Placeholder" {
            
            textView.text = ""
            
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if let detailsTextView = textView as? AttributedTextView, detailsTextView.isEditable, detailsTextView.text == "" {
            
            detailsTextView.textAlignment = .left
            
            if !detailsTextView.attributedTextBar.alignTextLeftButton.toggleState {
                
                detailsTextView.attributedTextBar.alignTextLeftButton.toggle()
                
            }
            
            if detailsTextView.attributedTextBar.alignTextCenterButton.toggleState {
                
                detailsTextView.attributedTextBar.alignTextCenterButton.toggle()
                
            }
            
            if detailsTextView.attributedTextBar.alignTextRightButton.toggleState {
                
                detailsTextView.attributedTextBar.alignTextRightButton.toggle()
                
            }
            
        }
        
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if let detailsTextView = textView as? AttributedTextView, detailsTextView.isEditable {
            
            if let attributedFont = detailsTextView.typingAttributes[.font] as? UIFont {
                
                // Bold Text Check
                
                if attributedFont.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    
                    if !toDoDetailsTextView.attributedTextBar.boldTextButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.boldTextButton.toggle()
                        
                    }
                    
                } else {
                    
                    if toDoDetailsTextView.attributedTextBar.boldTextButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.boldTextButton.toggle()
                        
                    }
                    
                }
                
                // Italics Text Check
                
                if attributedFont.fontDescriptor.symbolicTraits.contains(.traitItalic) {
                    
                    if !toDoDetailsTextView.attributedTextBar.italicTextButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.italicTextButton.toggle()
                        
                    }
                    
                } else {
                    
                    if toDoDetailsTextView.attributedTextBar.italicTextButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.italicTextButton.toggle()
                        
                    }
                    
                }
                
            }
            
            // Underline Text Check
            
            if detailsTextView.typingAttributes.keys.contains(.underlineStyle) {
                
                if !toDoDetailsTextView.attributedTextBar.underlineTextButton.toggleState {
                    
                    toDoDetailsTextView.attributedTextBar.underlineTextButton.toggle()
                    
                }
                
            } else {
                
                if toDoDetailsTextView.attributedTextBar.underlineTextButton.toggleState {
                    
                    toDoDetailsTextView.attributedTextBar.underlineTextButton.toggle()
                    
                }
                
            }
            
            // Strikethrough Text Check
            
            if detailsTextView.typingAttributes.keys.contains(.strikethroughStyle) {
                
                if !toDoDetailsTextView.attributedTextBar.strikeTextButton.toggleState {
                    
                    toDoDetailsTextView.attributedTextBar.strikeTextButton.toggle()
                    
                }
                
            } else {
                
                if toDoDetailsTextView.attributedTextBar.strikeTextButton.toggleState {
                    
                    toDoDetailsTextView.attributedTextBar.strikeTextButton.toggle()
                    
                }
                
            }
            
            // Highlight Text Check
            
            if detailsTextView.typingAttributes.keys.contains(.backgroundColor) {
                
                if !toDoDetailsTextView.attributedTextBar.highlightTextButton.toggleState {
                    
                    toDoDetailsTextView.attributedTextBar.highlightTextButton.toggle()
                    
                }
                
            } else {
                
                if toDoDetailsTextView.attributedTextBar.highlightTextButton.toggleState {
                    
                    toDoDetailsTextView.attributedTextBar.highlightTextButton.toggle()
                    
                }
                
            }
            
            // Text Alignment and Bullet/Number List Check
            
            if let attributedParagraph = detailsTextView.typingAttributes[.paragraphStyle] as? NSParagraphStyle {
                
                if attributedParagraph.alignment == .left || attributedParagraph.alignment == .natural || attributedParagraph.alignment == .justified { // Left Alignment
                
                    if !toDoDetailsTextView.attributedTextBar.alignTextLeftButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.alignTextLeftButton.toggle()
                        
                    }
                    
                    if toDoDetailsTextView.attributedTextBar.alignTextCenterButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.alignTextCenterButton.toggle()
                        
                    }
                    
                    if toDoDetailsTextView.attributedTextBar.alignTextRightButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.alignTextRightButton.toggle()
                        
                    }
                
                } else if attributedParagraph.alignment == .center { // Center Alignment
                    
                    if toDoDetailsTextView.attributedTextBar.alignTextLeftButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.alignTextLeftButton.toggle()
                        
                    }
                    
                    if !toDoDetailsTextView.attributedTextBar.alignTextCenterButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.alignTextCenterButton.toggle()
                        
                    }
                    
                    if toDoDetailsTextView.attributedTextBar.alignTextRightButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.alignTextRightButton.toggle()
                        
                    }
                    
                } else if attributedParagraph.alignment == .right { // Right Alignment
                    
                    if toDoDetailsTextView.attributedTextBar.alignTextLeftButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.alignTextLeftButton.toggle()
                        
                    }
                    
                    if toDoDetailsTextView.attributedTextBar.alignTextCenterButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.alignTextCenterButton.toggle()
                        
                    }
                    
                    if !toDoDetailsTextView.attributedTextBar.alignTextRightButton.toggleState {
                        
                        toDoDetailsTextView.attributedTextBar.alignTextRightButton.toggle()
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
