//
//  AnnouncementsPageViewController.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 5/8/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit

struct Announcement {
    
    var image: UIImage = UIImage.defaultAnnouncementsImage
    var title: String = "Title Text Placeholder"
    var body: NSAttributedString = NSAttributedString(string: "Body Text Placeholder", attributes: [NSAttributedString.Key.font : UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize)!)])
    var isPin: Bool = false
    var isPublic: Bool = false
    
}

final class AnnouncementsPageViewController: UIViewController {
    
    let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    private var currentAnnouncement: Announcement = Announcement()
    private var imageWasChanged = false
    private var announcementIndex: Int = -1
    
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
        
        var announcementEditButton = ToggleButton(toggleButtonOffImage: UIImage.editPencilIcon, toggleButtonOffImageColor: UIColor.PrimaryCrimson, toggleButtonOnImage: UIImage.checkMarkIcon, toggleButtonOnImageColor: UIColor.white)
        announcementEditButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        announcementEditButton.addTarget(self, action: #selector(toggleAnnouncementEditing(sender:)), for: .touchUpInside)
        return announcementEditButton
        
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
        
        var announcementInfoStackView = UIStackView(arrangedSubviews: [announcementTitleLabel, announcementTitleTextView, announcementBodyLabel, announcementBodyTextView])
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
        announcementTitleTextView.backgroundColor = .clear
        return announcementTitleTextView
        
    }()
    
    lazy private var announcementBodyTextView: AttributedTextView = {
        
        var announcementBodyTextView = AttributedTextView()
        announcementBodyTextView.attributedText = currentAnnouncement.body
        announcementBodyTextView.delegate = self
        return announcementBodyTextView
        
    }()
    
    lazy private var announcementTitleLabel: UILabel = {
        
        var announcementTitleLabel = UILabel()
        announcementTitleLabel.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3).pointSize)!)
        announcementTitleLabel.text = "Announcement Title:"
        announcementTitleLabel.textColor = .PrimaryCrimson
        announcementTitleLabel.textAlignment = .left
        announcementTitleLabel.numberOfLines = 0
        announcementTitleLabel.isHidden = true
        announcementTitleLabel.alpha = 0.0
        return announcementTitleLabel
        
    }()
    
    lazy private var announcementBodyLabel: UILabel = {
        
        var announcementBodyLabel = UILabel()
        announcementBodyLabel.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue-Bold", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3).pointSize)!)
        announcementBodyLabel.text = "Announcement Body:"
        announcementBodyLabel.textColor = .PrimaryCrimson
        announcementBodyLabel.textAlignment = .left
        announcementBodyLabel.numberOfLines = 0
        announcementBodyLabel.isHidden = true
        announcementBodyLabel.alpha = 0.0
        return announcementBodyLabel
        
    }()
    
    convenience init() {
        
        self.init(announcement: nil, index: nil)
        
    }
    
    init(announcement: Announcement?, index: Int?) {
        
        super.init(nibName: nil, bundle: nil)
        
        if let newAnnouncement = announcement { currentAnnouncement = newAnnouncement }
        if let newIndex = index { self.announcementIndex = newIndex }
        
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
                            self.announcementTitleTextView.layer.cornerRadius = 8
                            self.announcementTitleTextView.layer.borderColor = UIColor.PrimaryCrimson.cgColor
                            self.announcementTitleTextView.layer.borderWidth = 2
                            self.announcementBodyTextView.layer.cornerRadius = 8
                            self.announcementBodyTextView.layer.borderColor = UIColor.PrimaryCrimson.cgColor
                            self.announcementBodyTextView.layer.borderWidth = 2
                            self.announcementTitleLabel.isHidden = false
                            self.announcementBodyLabel.isHidden = false
                            self.announcementTitleLabel.alpha = 1.0
                            self.announcementBodyLabel.alpha = 1.0
                            self.announcementPublishButton.alpha = 0.0
                            self.announcementPublishButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                            self.announcementDeleteButton.alpha = 1.0
                            self.announcementDeleteButton.transform = .identity
                            self.announcementImageView.innerEditingButton.alpha = 1.0
                            
            }, completion: { _ in
            
                self.announcementPublishButton.transform = CGAffineTransform.identity
                
                if self.announcementPublishButton.toggleState { self.toggleAnnouncementVisibility(sender: self.announcementPublishButton) }
            
            })
            
        } else { // Announcement will end editing
            
            announcementPublishButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3,
                           options: .curveEaseOut, animations: {
                            
                            self.announcementInfoStackView.spacing = self.announcementInfoStackView.spacing/2
                            self.announcementTitleTextView.layer.cornerRadius = 0
                            self.announcementTitleTextView.layer.borderWidth = 0
                            self.announcementBodyTextView.layer.cornerRadius = 0
                            self.announcementBodyTextView.layer.borderWidth = 0
                            self.announcementTitleLabel.alpha = 0.0
                            self.announcementBodyLabel.alpha = 0.0
                            self.announcementTitleLabel.isHidden = true
                            self.announcementBodyLabel.isHidden = true
                            self.announcementPublishButton.alpha = 1.0
                            self.announcementPublishButton.transform = CGAffineTransform.identity
                            self.announcementDeleteButton.alpha = 0.0
                            self.announcementDeleteButton.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
                            self.announcementImageView.innerEditingButton.alpha = 0.0
                            
            }, completion: { _ in
                
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
    
    @objc private func toggleAnnouncementVisibility(sender: ToggleButton) {
        
        if announcementPublishButton.toggleState && announcementEditButton.toggleState {
            
            delegate?.toggleVisibility(forAnnouncementAt: announcementIndex)
            
        } else if announcementPublishButton.toggleState && !announcementEditButton.toggleState {
            
            let alert = UIAlertController(title: "Warning", message: "If you proceed, the announcement will be public for all members.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
                self.announcementPublishButton.toggle()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                
                self.delegate?.toggleVisibility(forAnnouncementAt: self.announcementIndex)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Warning", message: "If you proceed, the announcement will be hidden from all members.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
                self.announcementPublishButton.toggle()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                
                self.delegate?.toggleVisibility(forAnnouncementAt: self.announcementIndex)
                
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

final class AttributedTextView: UITextView {
    
    private var textIsUnderlined: Bool = false // For bug purposes.
    private var indentRatio: Int = 0
    
    lazy private(set) var attributedTextBar: TextAtrributesBarView = {
        
        var attributedTextBar = TextAtrributesBarView(withHeight: nil)
        attributedTextBar.boldTextButton.addTarget(self, action: #selector(boldText(sender:)), for: .touchUpInside)
        attributedTextBar.italicTextButton.addTarget(self, action: #selector(italicText(sender:)), for: .touchUpInside)
        attributedTextBar.underlineTextButton.addTarget(self, action: #selector(underlineText(sender:)), for: .touchUpInside)
        attributedTextBar.strikeTextButton.addTarget(self, action: #selector(strikeText(sender:)), for: .touchUpInside)
        attributedTextBar.highlightTextButton.addTarget(self, action: #selector(highlightText(sender:)), for: .touchUpInside)
        attributedTextBar.alignTextLeftButton.addTarget(self, action: #selector(alignTextLeft(sender:)), for: .touchUpInside)
        attributedTextBar.alignTextCenterButton.addTarget(self, action: #selector(alignTextCenter(sender:)), for: .touchUpInside)
        attributedTextBar.alignTextRightButton.addTarget(self, action: #selector(alignTextRight(sender:)), for: .touchUpInside)
        attributedTextBar.increaseIndentButton.addTarget(self, action: #selector(increaseIndentText(sender:)), for: .touchUpInside)
        attributedTextBar.decreaseIndentButton.addTarget(self, action: #selector(decreaseIndentText(sender:)), for: .touchUpInside)
        return attributedTextBar
        
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
        
        font = UIFontMetrics.default.scaledFont(for: UIFont(name: "HelveticaNeue", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize)!)
        text = "Description Placeholder..."
        textAlignment = .left
        allowsEditingTextAttributes = true
        sizeToFit()
        isScrollEnabled = false
        isEditable = false
        dataDetectorTypes = [.link, .lookupSuggestion, .address, .calendarEvent, .phoneNumber]
        textColor = UIColor.black
        backgroundColor = .clear
        inputAccessoryView = attributedTextBar
        inputAccessoryView?.isHidden = true
        linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.PrimaryCrimson,
                              NSAttributedString.Key.underlineColor: UIColor.PrimaryCrimson,
                              NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        
    }
    
    fileprivate func toggleAttributedTextBar() {
        
        inputAccessoryView!.isHidden = !inputAccessoryView!.isHidden
        
    }
    
    @objc private func boldText(sender: ToggleButton) {
        
        toggleBoldface(self)
        
    }
    
    @objc private func italicText(sender: ToggleButton) {
        
        toggleItalics(self)
        
    }
    
    @objc private func underlineText(sender: ToggleButton) {
        
        toggleUnderline(self) // For bug purposes.
        
    }
    
    @objc private func strikeText(sender: ToggleButton) {
        
        if sender.toggleState {
            
            if selectedRange.length > 0 {
                
                textStorage.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: selectedRange)
                
            } else {
            
                typingAttributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
                
            }
            
        } else {
            
            if selectedRange.length > 0 {
                
                textStorage.removeAttribute(.strikethroughStyle, range: selectedRange)
                
            } else {
            
                typingAttributes[.strikethroughStyle] = nil
                
            }
            
        }
        
    }
    
    @objc private func highlightText(sender: ToggleButton) {
        
        if sender.toggleState {
            
            if selectedRange.length > 0 {
                
                textStorage.addAttribute(.backgroundColor, value: UIColor.yellow, range: selectedRange)
                
            } else {
            
                typingAttributes[.backgroundColor] = UIColor.yellow
                
            }
            
        } else {
            
            if selectedRange.length > 0 {
                
                textStorage.removeAttribute(.backgroundColor, range: selectedRange)
                
            } else {
            
                typingAttributes[.backgroundColor] = nil
                
            }
            
        }
        
    }
    
    @objc private func alignTextLeft(sender: ToggleButton) {
        
        if sender.toggleState {
            
            if text == "" {
                
                textAlignment = .left
                
            } else {
                
                let leftParagraph = NSMutableParagraphStyle()
                leftParagraph.alignment = .left
                self.textStorage.addAttribute(.paragraphStyle, value: leftParagraph, range: selectedRange)
                self.typingAttributes[.paragraphStyle] = leftParagraph
            
                text.enumerateSubstrings(in: text.startIndex..., options: .byParagraphs, { substring, range, _, stop in
                    
                    let paragraphRange = NSRange(range, in: self.text)
                    
                    if self.selectedRange.length == 0, NSLocationInRange(self.selectedRange.location, paragraphRange) {
                        
                        let leftParagraph = NSMutableParagraphStyle()
                        leftParagraph.alignment = .left
                        self.textStorage.addAttribute(.paragraphStyle, value: leftParagraph, range: paragraphRange)
                        
                    } else if self.selectedRange.length == 0, NSLocationInRange(self.selectedRange.location-1, paragraphRange) {
                        
                        let leftParagraph = NSMutableParagraphStyle()
                        leftParagraph.alignment = .left
                        self.textStorage.addAttribute(.paragraphStyle, value: leftParagraph, range: paragraphRange)
                        
                    } else if self.selectedRange.length > 0, NSIntersectionRange(paragraphRange, self.selectedRange).length > 0 {
                        
                        let leftParagraph = NSMutableParagraphStyle()
                        leftParagraph.alignment = .left
                        self.textStorage.addAttribute(.paragraphStyle, value: leftParagraph, range: paragraphRange)
                        
                    }
                    
                })
                
                
            }
            
            if attributedTextBar.alignTextCenterButton.toggleState {
                
                attributedTextBar.alignTextCenterButton.toggle()
                
            }
            
            if attributedTextBar.alignTextRightButton.toggleState {
                
                attributedTextBar.alignTextRightButton.toggle()
                
            }
            
        } else {
            
            sender.toggle()
            
        }
        
    }
    
    @objc private func alignTextCenter(sender: ToggleButton) {
        
        if sender.toggleState {
            
            if text == "" {
                
                textAlignment = .center
                
            } else {
                
                let centerParagraph = NSMutableParagraphStyle()
                centerParagraph.alignment = .center
                self.textStorage.addAttribute(.paragraphStyle, value: centerParagraph, range: selectedRange)
                self.typingAttributes[.paragraphStyle] = centerParagraph
                
                text.enumerateSubstrings(in: text.startIndex..., options: .byParagraphs, { substring, range, _, stop in
                    
                    let paragraphRange = NSRange(range, in: self.text)
                    
                    if self.selectedRange.length == 0, NSLocationInRange(self.selectedRange.location, paragraphRange) {
                        
                        let centerParagraph = NSMutableParagraphStyle()
                        centerParagraph.alignment = .center
                        self.textStorage.addAttribute(.paragraphStyle, value: centerParagraph, range: paragraphRange)
                        self.typingAttributes[.paragraphStyle] = centerParagraph
                        
                    } else if self.selectedRange.length == 0, NSLocationInRange(self.selectedRange.location-1, paragraphRange) {
                        
                        let centerParagraph = NSMutableParagraphStyle()
                        centerParagraph.alignment = .center
                        self.textStorage.addAttribute(.paragraphStyle, value: centerParagraph, range: paragraphRange)
                        self.typingAttributes[.paragraphStyle] = centerParagraph
                        
                    } else if self.selectedRange.length > 0, NSIntersectionRange(paragraphRange, self.selectedRange).length > 0 {
                        
                        let centerParagraph = NSMutableParagraphStyle()
                        centerParagraph.alignment = .center
                        self.textStorage.addAttribute(.paragraphStyle, value: centerParagraph, range: paragraphRange)
                        self.typingAttributes[.paragraphStyle] = centerParagraph
                        
                    }
                    
                })
                
            }
            
            if attributedTextBar.alignTextLeftButton.toggleState {
                
                attributedTextBar.alignTextLeftButton.toggle()
                
            }
            
            if attributedTextBar.alignTextRightButton.toggleState {
                
                attributedTextBar.alignTextRightButton.toggle()
                
            }
            
        } else {
            
            sender.toggle()
            
        }
        
    }
    
    @objc private func alignTextRight(sender: ToggleButton) {
        
        if sender.toggleState {
            
            if text == "" {
                
                textAlignment = .right
                
            } else {
                
                let rightParagraph = NSMutableParagraphStyle()
                rightParagraph.alignment = .right
                self.textStorage.addAttribute(.paragraphStyle, value: rightParagraph, range: selectedRange)
                self.typingAttributes[.paragraphStyle] = rightParagraph
                
                text.enumerateSubstrings(in: text.startIndex..., options: .byParagraphs, { substring, range, _, stop in
                    
                    let paragraphRange = NSRange(range, in: self.text)
                    
                    if self.selectedRange.length == 0, NSLocationInRange(self.selectedRange.location, paragraphRange) {
                        
                        let rightParagraph = NSMutableParagraphStyle()
                        rightParagraph.alignment = .right
                        self.textStorage.addAttribute(.paragraphStyle, value: rightParagraph, range: paragraphRange)
                        self.typingAttributes[.paragraphStyle] = rightParagraph
                        
                    } else if self.selectedRange.length == 0, NSLocationInRange(self.selectedRange.location-1, paragraphRange) {
                        
                        let rightParagraph = NSMutableParagraphStyle()
                        rightParagraph.alignment = .right
                        self.textStorage.addAttribute(.paragraphStyle, value: rightParagraph, range: paragraphRange)
                        self.typingAttributes[.paragraphStyle] = rightParagraph
                        
                    } else if self.selectedRange.length > 0, NSIntersectionRange(paragraphRange, self.selectedRange).length > 0 {
                        
                        let rightParagraph = NSMutableParagraphStyle()
                        rightParagraph.alignment = .right
                        self.textStorage.addAttribute(.paragraphStyle, value: rightParagraph, range: paragraphRange)
                        self.typingAttributes[.paragraphStyle] = rightParagraph
                        
                    }
                    
                })
                
            }
            
            if attributedTextBar.alignTextLeftButton.toggleState {
                
                attributedTextBar.alignTextLeftButton.toggle()
                
            }
            
            if attributedTextBar.alignTextCenterButton.toggleState {
                
                attributedTextBar.alignTextCenterButton.toggle()
                
            }
            
        } else {
            
            sender.toggle()
            
        }
        
    }
    
    @objc func increaseIndentText(sender: BubbleButton) {
        
        if indentRatio >= 7 {
            
            indentRatio = 7
            
        } else {
            
            indentRatio+=1
            
        }
        
        applyIndent(indentRatio: indentRatio)
        
    }
    
    @objc func decreaseIndentText(sender: BubbleButton) {
        
        if indentRatio <= 0 {
            
            indentRatio = 0
            
        } else {
            
            indentRatio-=1
            
        }
        
        applyIndent(indentRatio: indentRatio)
        
    }
    
    private func applyIndent(indentRatio: Int) {
        
        if text == "" {
            
            let indentParagraph = NSMutableParagraphStyle()
            indentParagraph.alignment = .left
            indentParagraph.firstLineHeadIndent = CGFloat(indentRatio * 20)
            indentParagraph.headIndent = CGFloat(indentRatio * 30)
            self.textStorage.addAttribute(.paragraphStyle, value: indentParagraph, range: selectedRange)
            self.typingAttributes[.paragraphStyle] = indentParagraph
            
        } else {
            
            let indentParagraph = NSMutableParagraphStyle()
            indentParagraph.alignment = .left
            indentParagraph.firstLineHeadIndent = CGFloat(indentRatio * 20)
            indentParagraph.headIndent = CGFloat(indentRatio * 30)
            self.textStorage.addAttribute(.paragraphStyle, value: indentParagraph, range: selectedRange)
            self.typingAttributes[.paragraphStyle] = indentParagraph
            
            text.enumerateSubstrings(in: text.startIndex..., options: .byParagraphs, { substring, range, _, stop in
                
                let paragraphRange = NSRange(range, in: self.text)
                
                if self.selectedRange.length == 0, NSLocationInRange(self.selectedRange.location, paragraphRange) {
                    
                    let indentParagraph = NSMutableParagraphStyle()
                    indentParagraph.alignment = .left
                    indentParagraph.firstLineHeadIndent = CGFloat(self.indentRatio * 20)
                    indentParagraph.headIndent = CGFloat(self.indentRatio * 30)
                    self.textStorage.addAttribute(.paragraphStyle, value: indentParagraph, range: paragraphRange)
                    self.typingAttributes[.paragraphStyle] = indentParagraph
                    
                } else if self.selectedRange.length == 0, NSLocationInRange(self.selectedRange.location-1, paragraphRange) {
                    
                    let indentParagraph = NSMutableParagraphStyle()
                    indentParagraph.alignment = .left
                    indentParagraph.firstLineHeadIndent = CGFloat(self.indentRatio * 20)
                    indentParagraph.headIndent = CGFloat(self.indentRatio * 30)
                    self.textStorage.addAttribute(.paragraphStyle, value: indentParagraph, range: paragraphRange)
                    self.typingAttributes[.paragraphStyle] = indentParagraph
                    
                } else if self.selectedRange.length > 0, NSIntersectionRange(paragraphRange, self.selectedRange).length > 0 {
                    
                    let indentParagraph = NSMutableParagraphStyle()
                    indentParagraph.alignment = .left
                    indentParagraph.firstLineHeadIndent = CGFloat(self.indentRatio * 20)
                    indentParagraph.headIndent = CGFloat(self.indentRatio * 30)
                    self.textStorage.addAttribute(.paragraphStyle, value: indentParagraph, range: paragraphRange)
                    self.typingAttributes[.paragraphStyle] = indentParagraph
                    
                }
                
            })
            
        }
        
    }
    
    override func toggleUnderline(_ sender: Any?) { // For bug purposes
        
        if textIsUnderlined {
            
            if selectedRange.length > 0 {
                
                textStorage.removeAttribute(.underlineStyle, range: selectedRange)
                
            } else {
            
                typingAttributes[.underlineStyle] = nil
                
            }
            
        } else {
            
            if selectedRange.length > 0 {
                
                textStorage.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: selectedRange)
                
            } else {
            
                typingAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
                
            }
            
        }
        
        textIsUnderlined = !textIsUnderlined
        
    }
    
}

