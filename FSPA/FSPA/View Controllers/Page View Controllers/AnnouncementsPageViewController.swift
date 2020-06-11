//
//  AnnouncementsPageViewController.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 5/8/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit
import Firebase

struct Announcement {
    
    var image: UIImage = UIImage.defaultAnnouncementsImage
    var title: String = "Title Text Placeholder"
    var body: NSAttributedString = NSAttributedString(string: "Body Text Placeholder", attributes: [NSAttributedString.Key.font : UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize)!)])
    var isPin: Bool = false
    var isPublic: Bool = false
    var uid: String = ""
    
}

//var admin: String

final class AnnouncementsPageViewController: UIViewController {
    
    let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    private var currentAnnouncement: Announcement = Announcement()
    private var imageWasChanged = false
    private var announcementIndex: Int = -1
    private var isAdmin: Bool = false
    
    weak var delegate: AnnouncementsPageViewControllerDelegate?
    
    lazy private(set) var imagePicker: UIImagePickerController = UIImagePickerController()
    
    lazy private var tapOutGesture: UITapGestureRecognizer = {
        
        var tapOutGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTapOut))
        tapOutGesture.cancelsTouchesInView = true
        return tapOutGesture
        
    }()
    
    lazy private var announcementCloseButton: BubbleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2.5)
        
        var announcementCloseButton = BubbleButton(bubbleButtonImage: UIImage.closeXMarkIcon.withTintColor(UIColor.PrimaryCrimson))
        announcementCloseButton.backgroundColor = .white
        announcementCloseButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        announcementCloseButton.addTarget(self, action: #selector(closeAnnouncement(sender:)), for: .touchUpInside)
        return announcementCloseButton
        
    }()
    
    lazy private var announcementDeleteButton: BubbleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2.5)
        
        var announcementDeleteButton = BubbleButton(bubbleButtonImage: UIImage.deleteIcon.withTintColor(UIColor.white))
        announcementDeleteButton.backgroundColor = .red
        announcementDeleteButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        announcementDeleteButton.addTarget(self, action: #selector(deleteAnnouncement(sender:)), for: .touchUpInside)
        announcementDeleteButton.alpha = 0.0
        return announcementDeleteButton
        
    }()
    
    lazy private var announcementEditButton: ToggleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2.5)
        
        var announcementEditButton = ToggleButton(toggleButtonOffImage: UIImage.editPencilIcon, toggleButtonOffImageColor: UIColor.PrimaryCrimson, toggleButtonOnImage: UIImage.floppyDiskSaveIcon, toggleButtonOnImageColor: UIColor.white)
        announcementEditButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        announcementEditButton.addTarget(self, action: #selector(toggleAnnouncementEditing(sender:)), for: .touchUpInside)
        return announcementEditButton
        
    }()
    
    lazy private var announcementRevertChangesButton: BubbleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2.5)
        
        var announcementRevertChangesButton = BubbleButton(bubbleButtonImage: UIImage.revertChangesArrowIcon.withTintColor(UIColor.white))
        announcementRevertChangesButton.backgroundColor = .PrimaryCrimson
        announcementRevertChangesButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        announcementRevertChangesButton.alpha = 0.0
        announcementRevertChangesButton.addTarget(self, action: #selector(revertEditingChanges(sender:)), for: .touchUpInside)
        return announcementRevertChangesButton
        
    }()
    
    lazy private var announcementPublishButton: ToggleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2)
        
        var announcementPublishButton = ToggleButton(toggleButtonOffImage: UIImage.notVisibleEyeIcon, toggleButtonOffImageColor: UIColor.PrimaryCrimson, toggleButtonOnImage: UIImage.visibleEyeIcon, toggleButtonOnImageColor: UIColor.white)
        announcementPublishButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        
        if currentAnnouncement.isPublic { announcementPublishButton.toggle() }
        
        announcementPublishButton.addTarget(self, action: #selector(toggleAnnouncementVisibility(sender:)), for: .touchUpInside)
        return announcementPublishButton
        
    }()
    
    lazy private var announcementPinButton: ToggleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2.3)
        
        var announcementPinButton = ToggleButton(toggleButtonOffImage: UIImage.unpinIcon, toggleButtonOffImageColor: UIColor.PrimaryCrimson, toggleButtonOnImage: UIImage.pinIcon, toggleButtonOnImageColor: UIColor.white)
        announcementPinButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        
        if currentAnnouncement.isPin { announcementPinButton.toggle() }
        
        announcementPinButton.addTarget(self, action: #selector(toggleAnnouncementPin(sender:)), for: .touchUpInside)
        return announcementPinButton
        
    }()
    
    lazy private var announcementScrollView: UIScrollView = {
        
        let announcementScrollViewContentView = UIView()
        announcementScrollViewContentView.translatesAutoresizingMaskIntoConstraints = false
        announcementScrollViewContentView.addSubview(announcementImageView)
        announcementImageView.topAnchor.constraint(equalTo: announcementScrollViewContentView.topAnchor).isActive = true
        announcementScrollViewContentView.addSubview(announcementInfoStackView)
        announcementInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        announcementInfoStackView.topAnchor.constraint(equalTo: announcementImageView.bottomAnchor).isActive = true
        announcementInfoStackView.bottomAnchor.constraint(equalTo: announcementScrollViewContentView.bottomAnchor).isActive = true
        
        var announcementScrollView = UIScrollView()
        announcementScrollView.isScrollEnabled = true
        announcementScrollView.alwaysBounceVertical = true
        announcementScrollView.showsVerticalScrollIndicator = false
        
        announcementScrollView.translatesAutoresizingMaskIntoConstraints = false
        announcementScrollView.addSubview(announcementScrollViewContentView)
        announcementScrollViewContentView.topAnchor.constraint(equalTo: announcementScrollView.topAnchor).isActive = true
        announcementScrollViewContentView.leadingAnchor.constraint(equalTo: announcementScrollView.leadingAnchor).isActive = true
        announcementScrollViewContentView.trailingAnchor.constraint(equalTo: announcementScrollView.trailingAnchor).isActive = true
        announcementScrollViewContentView.bottomAnchor.constraint(equalTo: announcementScrollView.bottomAnchor).isActive = true
        announcementScrollViewContentView.widthAnchor.constraint(equalTo: announcementScrollView.widthAnchor).isActive = true
        
        return announcementScrollView
        
    }()
    
    lazy private var announcementImageView: EditableImageView = {
        
        var announcementImageView = EditableImageView(editableImage: currentAnnouncement.image)
        announcementImageView.addShadowAndRoundCorners(cornerRadius: 0.0, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0))
        announcementImageView.innerEditingButton.addTarget(self, action: #selector(editImage(sender:)), for: .touchUpInside)
        
        announcementImageView.translatesAutoresizingMaskIntoConstraints = false
        announcementImageView.heightAnchor.constraint(equalTo: announcementImageView.widthAnchor, multiplier: 0.6).isActive = true
        
        return announcementImageView
        
    }()
    
    lazy private var announcementInfoStackView: UIStackView = {
        
        var announcementInfoStackView = UIStackView(arrangedSubviews: [announcementTitleTextView, announcementBodyTextView])
        announcementInfoStackView.axis = .vertical
        announcementInfoStackView.alignment = .fill
        announcementInfoStackView.distribution = .fill
        announcementInfoStackView.spacing = verticalEdgeInset/2
        announcementInfoStackView.isLayoutMarginsRelativeArrangement = true
        announcementInfoStackView.layoutMargins = UIEdgeInsets(top: verticalEdgeInset, left: horizontalEdgeInset, bottom: verticalEdgeInset, right: horizontalEdgeInset)
        return announcementInfoStackView
        
    }()
    
    lazy private var announcementTitleTextView: UITextView = {
        
        var announcementTitleTextView = UITextView()
        announcementTitleTextView.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3).pointSize)!)
        announcementTitleTextView.text = currentAnnouncement.title
        announcementTitleTextView.textAlignment = .left
        announcementTitleTextView.sizeToFit()
        announcementTitleTextView.isScrollEnabled = false
        announcementTitleTextView.isEditable = false
        announcementTitleTextView.delegate = self
        announcementTitleTextView.textColor = UIColor.black
        announcementTitleTextView.backgroundColor = .white
        return announcementTitleTextView
        
    }()
    
    lazy private var announcementBodyTextView: AttributedTextView = {
        
        var announcementBodyTextView = AttributedTextView()
        announcementBodyTextView.attributedText = currentAnnouncement.body
        announcementBodyTextView.backgroundColor = .white
        announcementBodyTextView.delegate = self
        return announcementBodyTextView
        
    }()
    
    convenience init() {
        
        self.init(announcement: nil, index: nil, admin: nil)
        
    }
    
    init(announcement: Announcement?, index: Int?, admin: Bool?) {
        
        super.init(nibName: nil, bundle: nil)
        
        if let newAnnouncement = announcement { currentAnnouncement = newAnnouncement }
        if let newIndex = index { self.announcementIndex = newIndex }
        if let newAdmin = admin { self.isAdmin = newAdmin }
        
    }
    
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.backgroundColor = .white
        
        print(currentAnnouncement.uid)
        view.addSubview(announcementScrollView)
        announcementScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        announcementScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        announcementScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        announcementScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        announcementImageView.innerImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        announcementImageView.innerEditingButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        announcementImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        announcementImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        announcementInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        announcementInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(announcementCloseButton)
        announcementCloseButton.translatesAutoresizingMaskIntoConstraints = false
        announcementCloseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset).isActive = true
        announcementCloseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        announcementCloseButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 9)).isActive = true
        announcementCloseButton.heightAnchor.constraint(equalTo: announcementCloseButton.widthAnchor).isActive = true
                
        view.addSubview(announcementPinButton)
        announcementPinButton.translatesAutoresizingMaskIntoConstraints = false
        announcementPinButton.topAnchor.constraint(equalTo: announcementCloseButton.bottomAnchor, constant: verticalEdgeInset).isActive = true
        announcementPinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        announcementPinButton.widthAnchor.constraint(equalTo: announcementCloseButton.widthAnchor).isActive = true
        announcementPinButton.heightAnchor.constraint(equalTo: announcementPinButton.widthAnchor).isActive = true
        
        view.addSubview(announcementEditButton)
        announcementEditButton.translatesAutoresizingMaskIntoConstraints = false
        announcementEditButton.topAnchor.constraint(equalTo: announcementPinButton.bottomAnchor, constant: verticalEdgeInset).isActive = true
        announcementEditButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        announcementEditButton.widthAnchor.constraint(equalTo: announcementCloseButton.widthAnchor).isActive = true
        announcementEditButton.heightAnchor.constraint(equalTo: announcementEditButton.widthAnchor).isActive = true
        
        view.addSubview(announcementRevertChangesButton)
        announcementRevertChangesButton.translatesAutoresizingMaskIntoConstraints = false
        announcementRevertChangesButton.topAnchor.constraint(equalTo: announcementEditButton.bottomAnchor, constant: verticalEdgeInset).isActive = true
        announcementRevertChangesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        announcementRevertChangesButton.widthAnchor.constraint(equalTo: announcementCloseButton.widthAnchor).isActive = true
        announcementRevertChangesButton.heightAnchor.constraint(equalTo: announcementRevertChangesButton.widthAnchor).isActive = true
        
        view.addSubview(announcementPublishButton)
        announcementPublishButton.translatesAutoresizingMaskIntoConstraints = false
        announcementPublishButton.topAnchor.constraint(equalTo: announcementEditButton.bottomAnchor, constant: verticalEdgeInset).isActive = true
        announcementPublishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        announcementPublishButton.widthAnchor.constraint(equalTo: announcementCloseButton.widthAnchor).isActive = true
        announcementPublishButton.heightAnchor.constraint(equalTo: announcementPublishButton.widthAnchor).isActive = true
        
        view.addSubview(announcementDeleteButton)
        announcementDeleteButton.translatesAutoresizingMaskIntoConstraints = false
        announcementDeleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset).isActive = true
        announcementDeleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalEdgeInset).isActive = true
        announcementDeleteButton.widthAnchor.constraint(equalTo: announcementCloseButton.widthAnchor).isActive = true
        announcementDeleteButton.heightAnchor.constraint(equalTo: announcementDeleteButton.widthAnchor).isActive = true
        
        if(!isAdmin){
            announcementEditButton.isHidden = true
            //announcementCloseButton.isHidden = true
            //announcementPinButton.isHidden = true
            announcementPublishButton.isHidden = true
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        view.addGestureRecognizer(tapOutGesture)
        let userInfo = notification.userInfo!
        let keyboardSize: CGSize = ((userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size)
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + announcementBodyTextView.attributedTextBar.frame.height, right: 0.0)
        announcementScrollView.contentInset = contentInsets
        announcementScrollView.scrollIndicatorInsets = contentInsets
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height

        if announcementTitleTextView.isFirstResponder, !visibleRect.contains(announcementTitleTextView.frame.origin)  {
        
            self.announcementScrollView.scrollRectToVisible((announcementTitleTextView.frame), animated: true)

        } else if announcementBodyTextView.isFirstResponder {
            
            if !visibleRect.contains(announcementBodyTextView.frame.origin) {
            
                self.announcementScrollView.scrollRectToVisible((announcementBodyTextView.frame), animated: true)
                
            }
            
            if announcementBodyTextView.isEditable {
                
                announcementBodyTextView.toggleAttributedTextBar()
                
            }
            
        }
        
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        
        view.removeGestureRecognizer(tapOutGesture)
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        announcementScrollView.contentInset = contentInset
        
        if !announcementBodyTextView.inputAccessoryView!.isHidden {
            
            announcementBodyTextView.toggleAttributedTextBar()
            
        }
        
    }
    
    @objc private func hideKeyboardOnTapOut() {
        
        if announcementTitleTextView.isFirstResponder {
            
            announcementTitleTextView.resignFirstResponder()
            
        } else if announcementBodyTextView.isFirstResponder {
            
            announcementBodyTextView.resignFirstResponder()
            
        }
        
    }
    
    @objc private func closeAnnouncement(sender: BubbleButton) {
        
        let ref = Database.database().reference()
               let uid = Auth.auth().currentUser!.uid
               
               ref.child("users/\(uid)/currentWorkspace").observeSingleEvent(of: .value, with: { (snapshot) in
                   // Get user value
                   let value = snapshot.value as? String
                   
                   let currentWorkspace = value!
        
                let body = self.currentAnnouncement.body.string
                let annAttrs = ["title": self.currentAnnouncement.title, "body": body, "isPin": self.currentAnnouncement.isPin, "isPublic": self.currentAnnouncement.isPublic] as [String : Any]
                                              
                ref.child("workspaces/\(currentWorkspace)/announcements/\(self.currentAnnouncement.uid)").setValue(annAttrs) { (error, ref) in
                           
                           if let error = error {
                               
                               assertionFailure(error.localizedDescription)
                           }
                       }
        }
        )
        
        if announcementEditButton.toggleState {
            
            let alert = UIAlertController(title: "Warning", message: "If you proceed, any edits done on the announcement will be lost.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                
                self.navigationController?.popViewController(animated: true)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    @objc private func toggleAnnouncementEditing(sender: ToggleButton) {
        
        if announcementEditButton.toggleState && announcementPublishButton.toggleState {
            
            let alert = UIAlertController(title: "Warning", message: "If you proceed, the announcement will be hidden for editing.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
                self.announcementEditButton.toggle()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                self.currentAnnouncement.isPublic = false
                self.toggleAnnouncementEditingHelper()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            toggleAnnouncementEditingHelper()
            
        }
        
    }
    
    private func toggleAnnouncementEditingHelper() {
        
        announcementTitleTextView.isEditable = !announcementTitleTextView.isEditable
        announcementBodyTextView.isEditable = !announcementBodyTextView.isEditable
        
        if announcementEditButton.toggleState { // Announcement will begin editing
            
            announcementDeleteButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3,
                           options: .curveEaseIn, animations: {
                            
                            self.announcementInfoStackView.spacing = self.announcementInfoStackView.spacing*2
                            self.announcementTitleTextView.setBottomBorder(color: .PrimaryCrimson, width: .getWidthFitSize(minSize: 2.5, maxSize: 3.5))
                            self.announcementBodyTextView.setBottomBorder(color: .PrimaryCrimson, width: .getWidthFitSize(minSize: 2.0, maxSize: 3.0))
                            self.announcementPublishButton.alpha = 0.0
                            self.announcementPublishButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                            self.announcementDeleteButton.alpha = 1.0
                            self.announcementDeleteButton.transform = .identity
                            self.announcementImageView.innerEditingButton.alpha = 1.0
                            self.announcementRevertChangesButton.alpha = 1.0
                            
            }, completion: { _ in
            
                self.announcementPublishButton.transform = CGAffineTransform.identity
                
                if self.announcementPublishButton.toggleState { self.toggleAnnouncementVisibility(sender: self.announcementPublishButton) }
            
            })
            
        } else { // Announcement will end editing
            
            announcementPublishButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3,
                           options: .curveEaseOut, animations: {
                            
                            self.announcementInfoStackView.spacing = self.announcementInfoStackView.spacing/2
                            self.announcementTitleTextView.setBottomBorder(color: .PrimaryCrimson, width: 0.0)
                            self.announcementBodyTextView.setBottomBorder(color: .PrimaryCrimson, width: 0.0)
                            self.announcementPublishButton.alpha = 1.0
                            self.announcementPublishButton.transform = CGAffineTransform.identity
                            self.announcementDeleteButton.alpha = 0.0
                            self.announcementDeleteButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                            self.announcementImageView.innerEditingButton.alpha = 0.0
                            self.announcementRevertChangesButton.alpha = 0.0
                            
            }, completion: { _ in
                
                self.announcementRevertChangesButton.transform = CGAffineTransform.identity
                
                var imageToReturn: UIImage?
                var titleToReturn: String?
                var bodyToReturn: NSAttributedString?
            
                if self.imageWasChanged {
                    
                    imageToReturn = self.announcementImageView.innerImageView.image
                    self.imageWasChanged = false
                    
                }
                
                if self.announcementTitleTextView.text != self.currentAnnouncement.title {
                    
                    titleToReturn = self.announcementTitleTextView.text
                    self.currentAnnouncement.title = titleToReturn!
                    
                }
                
                if !self.announcementBodyTextView.attributedText.isEqual(self.currentAnnouncement.body) {
                    
                    bodyToReturn = self.announcementBodyTextView.attributedText
                    self.currentAnnouncement.body = bodyToReturn!
                    
                }
                
                self.delegate?.editAnnouncement(forAnnouncementAt: self.announcementIndex, newImage: imageToReturn, newTitle: titleToReturn, newBody: bodyToReturn)
            
            })
            
        }
        
    }
    
    @objc private func revertEditingChanges(sender: BubbleButton) {
        
        imageWasChanged = false
        announcementImageView.innerImageView.image = currentAnnouncement.image
        announcementTitleTextView.text = currentAnnouncement.title
        announcementBodyTextView.attributedText = currentAnnouncement.body
        announcementEditButton.toggle()
        toggleAnnouncementEditingHelper()
        
    }
    
    @objc private func toggleAnnouncementVisibility(sender: ToggleButton) {
        
        if announcementPublishButton.toggleState && announcementEditButton.toggleState {
            
            delegate?.toggleVisibility(forAnnouncementAt: announcementIndex)
            announcementPublishButton.toggle()
            
        } else if announcementPublishButton.toggleState && !announcementEditButton.toggleState {
            
            let alert = UIAlertController(title: "Warning", message: "If you proceed, the announcement will be public for all members.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
                self.announcementPublishButton.toggle()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                
                self.delegate?.toggleVisibility(forAnnouncementAt: self.announcementIndex)
                self.currentAnnouncement.isPublic = true
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Warning", message: "If you proceed, the announcement will be hidden from all members.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
                self.announcementPublishButton.toggle()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                
                self.delegate?.toggleVisibility(forAnnouncementAt: self.announcementIndex)
                self.currentAnnouncement.isPublic = false
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @objc private func toggleAnnouncementPin(sender: ToggleButton) {
        
        delegate?.togglePin(forAnnouncementAt: announcementIndex)
        
    }
    
    @objc private func editImage(sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Warning", message: "Unable to access a camera.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func deleteAnnouncement(sender: BubbleButton) {
        
        
        
        let alert = UIAlertController(title: "Warning", message: "If you proceed, this announcement will be deleted indifinitely.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            
            let ref = Database.database().reference()
                   let uid = Auth.auth().currentUser!.uid
                   
                   ref.child("users/\(uid)/currentWorkspace").observeSingleEvent(of: .value, with: { (snapshot) in
                       // Get user value
                       let value = snapshot.value as? String
                       
                       let currentWorkspace = value!
                                                  
                    ref.child("workspaces/\(currentWorkspace)/announcements/\(self.currentAnnouncement.uid)").removeValue() { (error, ref) in
                               
                               if let error = error {
                                   
                                   assertionFailure(error.localizedDescription)
                               }
                           }
            }
            )
            
            self.delegate?.deleteAnnouncement(forAnnouncementAt: self.announcementIndex)
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension AnnouncementsPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        let cameraImage = info[.editedImage] as? UIImage
        announcementImageView.innerImageView.image = cameraImage
        imageWasChanged = true
        
    }
    
}

extension AnnouncementsPageViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView is AttributedTextView, textView.text == "" {
            
            textView.text = "Body Text Placeholder"
            
        } else if textView.text == "" {
            
            textView.text = "Title Text Placeholder"
            
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView is AttributedTextView, textView.text == "Body Text Placeholder" {
            
            textView.text = ""
            
        } else if textView.text == "Title Text Placeholder" {
            
            textView.text = ""
            
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if let bodyTextView = textView as? AttributedTextView, bodyTextView.isEditable, bodyTextView.text == "" {
            
            bodyTextView.textAlignment = .left
            
            if !bodyTextView.attributedTextBar.alignTextLeftButton.toggleState {
                
                bodyTextView.attributedTextBar.alignTextLeftButton.toggle()
                
            }
            
            if bodyTextView.attributedTextBar.alignTextCenterButton.toggleState {
                
                bodyTextView.attributedTextBar.alignTextCenterButton.toggle()
                
            }
            
            if bodyTextView.attributedTextBar.alignTextRightButton.toggleState {
                
                bodyTextView.attributedTextBar.alignTextRightButton.toggle()
                
            }
            
        }
        
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if let bodyTextView = textView as? AttributedTextView, bodyTextView.isEditable {
            
            if let attributedFont = bodyTextView.typingAttributes[.font] as? UIFont {
                
                // Bold Text Check
                
                if attributedFont.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    
                    if !announcementBodyTextView.attributedTextBar.boldTextButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.boldTextButton.toggle()
                        
                    }
                    
                } else {
                    
                    if announcementBodyTextView.attributedTextBar.boldTextButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.boldTextButton.toggle()
                        
                    }
                    
                }
                
                // Italics Text Check
                
                if attributedFont.fontDescriptor.symbolicTraits.contains(.traitItalic) {
                    
                    if !announcementBodyTextView.attributedTextBar.italicTextButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.italicTextButton.toggle()
                        
                    }
                    
                } else {
                    
                    if announcementBodyTextView.attributedTextBar.italicTextButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.italicTextButton.toggle()
                        
                    }
                    
                }
                
            }
            
            // Underline Text Check
            
            if bodyTextView.typingAttributes.keys.contains(.underlineStyle) {
                
                if !announcementBodyTextView.attributedTextBar.underlineTextButton.toggleState {
                    
                    announcementBodyTextView.attributedTextBar.underlineTextButton.toggle()
                    
                }
                
            } else {
                
                if announcementBodyTextView.attributedTextBar.underlineTextButton.toggleState {
                    
                    announcementBodyTextView.attributedTextBar.underlineTextButton.toggle()
                    
                }
                
            }
            
            // Strikethrough Text Check
            
            if bodyTextView.typingAttributes.keys.contains(.strikethroughStyle) {
                
                if !announcementBodyTextView.attributedTextBar.strikeTextButton.toggleState {
                    
                    announcementBodyTextView.attributedTextBar.strikeTextButton.toggle()
                    
                }
                
            } else {
                
                if announcementBodyTextView.attributedTextBar.strikeTextButton.toggleState {
                    
                    announcementBodyTextView.attributedTextBar.strikeTextButton.toggle()
                    
                }
                
            }
            
            // Highlight Text Check
            
            if bodyTextView.typingAttributes.keys.contains(.backgroundColor) {
                
                if !announcementBodyTextView.attributedTextBar.highlightTextButton.toggleState {
                    
                    announcementBodyTextView.attributedTextBar.highlightTextButton.toggle()
                    
                }
                
            } else {
                
                if announcementBodyTextView.attributedTextBar.highlightTextButton.toggleState {
                    
                    announcementBodyTextView.attributedTextBar.highlightTextButton.toggle()
                    
                }
                
            }
            
            // Text Alignment and Bullet/Number List Check
            
            if let attributedParagraph = bodyTextView.typingAttributes[.paragraphStyle] as? NSParagraphStyle {
                
                if attributedParagraph.alignment == .left || attributedParagraph.alignment == .natural || attributedParagraph.alignment == .justified { // Left Alignment
                
                    if !announcementBodyTextView.attributedTextBar.alignTextLeftButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.alignTextLeftButton.toggle()
                        
                    }
                    
                    if announcementBodyTextView.attributedTextBar.alignTextCenterButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.alignTextCenterButton.toggle()
                        
                    }
                    
                    if announcementBodyTextView.attributedTextBar.alignTextRightButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.alignTextRightButton.toggle()
                        
                    }
                
                } else if attributedParagraph.alignment == .center { // Center Alignment
                    
                    if announcementBodyTextView.attributedTextBar.alignTextLeftButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.alignTextLeftButton.toggle()
                        
                    }
                    
                    if !announcementBodyTextView.attributedTextBar.alignTextCenterButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.alignTextCenterButton.toggle()
                        
                    }
                    
                    if announcementBodyTextView.attributedTextBar.alignTextRightButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.alignTextRightButton.toggle()
                        
                    }
                    
                } else if attributedParagraph.alignment == .right { // Right Alignment
                    
                    if announcementBodyTextView.attributedTextBar.alignTextLeftButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.alignTextLeftButton.toggle()
                        
                    }
                    
                    if announcementBodyTextView.attributedTextBar.alignTextCenterButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.alignTextCenterButton.toggle()
                        
                    }
                    
                    if !announcementBodyTextView.attributedTextBar.alignTextRightButton.toggleState {
                        
                        announcementBodyTextView.attributedTextBar.alignTextRightButton.toggle()
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

final class EditableImageView: UIView {
    
    lazy private(set) var innerImageView: UIImageView = {
        
        var innerImageView = UIImageView()
        innerImageView.contentMode = .scaleAspectFill
        innerImageView.clipsToBounds = true
        return innerImageView
        
    }()
    
    lazy private(set) var innerEditingButton: UIButton = {
        
        var innerEditingButton = UIButton()
        innerEditingButton.setTitle("Change image", for: .normal)
        innerEditingButton.setTitleColor(.white, for: .normal)
        innerEditingButton.titleLabel!.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3).pointSize)!)
        innerEditingButton.backgroundColor = UIColor.PrimaryCrimson.withAlphaComponent(0.5)
        innerEditingButton.alpha = 0.0
        return innerEditingButton
        
    }()
    
    convenience init() {
        
        self.init(editableImage: nil)
        
    }
    
    init(editableImage: UIImage?) {
        
        super.init(frame: .zero)
        
        if let newEditableImage = editableImage { innerImageView.image = newEditableImage }
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        addSubview(innerImageView)
        innerImageView.translatesAutoresizingMaskIntoConstraints = false
        innerImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        innerImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        innerImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(innerEditingButton)
        innerEditingButton.translatesAutoresizingMaskIntoConstraints = false
        innerEditingButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        innerEditingButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        innerEditingButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
}

