//
//  BouncyButtons.swift - UIButtons with a bouncy animation when pressed (and subclasses).
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 5/5/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit

class BouncyButton: UIButton {
    
    public static let bouncyButtonEdgeInset: CGFloat = .getPercentageWidth(percentage: 3)
    private var bouncyButtonImage: UIImage?
    
    init(bouncyButtonImage: UIImage?) {
        
        super.init(frame: .zero)
        
        self.bouncyButtonImage = bouncyButtonImage
        setupButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupButton()
        
    }
    
    private func setupButton() {
        
        setImage(bouncyButtonImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        imageView?.contentMode = .scaleAspectFit
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])

    }
    
    @objc private func animateDown(sender: UIButton) {
        
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95), alpha: 0.9)
        
    }
    
    @objc private func animateUp(sender: UIButton) {
        
        animate(sender, transform: .identity, alpha: 1.0)
        
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform, alpha: CGFloat) {
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        button.alpha = alpha
                        button.transform = transform
                        
            }, completion: nil)
        
    }
    
    func changeBouncyButtonImage(image: UIImage?) {
        
        if let newImage = image {
            
            self.bouncyButtonImage = newImage
            setImage(bouncyButtonImage, for: .normal)
            
        }
        
    }
    
}

class BubbleButton: BouncyButton {
    
    private var isShadowed: Bool = true
    
    init(bubbleButtonImage: UIImage?) {
        
        super.init(bouncyButtonImage: bubbleButtonImage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    
        if isShadowed {
        
            addShadowAndRoundCorners(cornerRadius: min(frame.width, frame.height)/2, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0))
            
        } else {
            
            addShadowAndRoundCorners(cornerRadius: min(frame.width, frame.height)/2, shadowOpacity: 0.0)
            
        }
        
    }
    
    func toggleShadow() {
        
        isShadowed = !isShadowed
        
    }
    
}

final class ToggleButton: BubbleButton {
    
    private(set) var toggleState = false {
        
        willSet (newState) {
            
            if toggleState != newState {
                
                if newState { // Button is on
                    
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3,
                                   options: .curveEaseIn, animations: {
                    
                                    self.setImage(self.toggleButtonOnImage.withTintColor(self.toggleButtonOnImageColor), for: .normal)
                                    self.backgroundColor = self.toggleButtonOffImageColor
                                    
                    }, completion: nil)
                    
                } else { // Button is off
                    
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                    
                                    self.setImage(self.toggleButtonOffImage.withTintColor(self.toggleButtonOffImageColor), for: .normal)
                                    self.backgroundColor = self.toggleButtonOnImageColor
                                    
                    }, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    private var toggleButtonOffImage: UIImage = UIImage()
    private var toggleButtonOffImageColor: UIColor = .black
    private var toggleButtonOnImage: UIImage = UIImage()
    private var toggleButtonOnImageColor: UIColor = .black
    
    init(toggleButtonOffImage: UIImage?, toggleButtonOffImageColor: UIColor?, toggleButtonOnImage: UIImage?, toggleButtonOnImageColor: UIColor?) {
        
        if let newToggleButtonOffImage = toggleButtonOffImage { self.toggleButtonOffImage = newToggleButtonOffImage }
        if let newToggleButtonOffImageColor = toggleButtonOffImageColor { self.toggleButtonOffImageColor = newToggleButtonOffImageColor }
        if let newToggleButtonOnImage = toggleButtonOnImage { self.toggleButtonOnImage = newToggleButtonOnImage }
        if let newToggleButtonOnImageColor = toggleButtonOnImageColor { self.toggleButtonOnImageColor = newToggleButtonOnImageColor }
        
        super.init(bubbleButtonImage: self.toggleButtonOffImage.withTintColor(self.toggleButtonOffImageColor))
        
        configureButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureButton()
        
    }
    
    private func configureButton() {
        
        backgroundColor = self.toggleButtonOnImageColor
        addTarget(self, action: #selector(toggle), for: .touchUpInside)
        
    }
    
    @objc func toggle() {
        
        toggleState = !toggleState
        
    }
    
}

final class CheckBoxButton: BouncyButton {
    
    private(set) var isChecked = false {
        
        willSet (newState) {
            
            if isChecked != newState {
                
                if newState { // Button is on
                    
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3,
                                   options: .curveEaseIn, animations: {
                    
                                    self.setImage(UIImage.checkMarkIcon.withTintColor(self.checkMarkColor), for: .normal)
                                    
                    }, completion: nil)
                    
                } else { // Button is off
                    
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                    
                                    self.setImage(nil, for: .normal)
                                    
                    }, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    private var isShadowed: Bool = true
    private var checkMarkColor: UIColor = .black
    private let edgeInset: CGFloat = .getPercentageWidth(percentage: 2)
    
    convenience init() {
        
        self.init(checkMarkColor: nil)
        
    }
    
    init(checkMarkColor: UIColor?) {
        
        if let newCheckMarkColor = checkMarkColor { self.checkMarkColor = newCheckMarkColor }
        
        super.init(bouncyButtonImage: UIImage.checkMarkIcon.withTintColor(self.checkMarkColor))
        configureButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        configureButton()
        
    }
    
    private func configureButton() {
        
        backgroundColor = .white
        contentEdgeInsets = UIEdgeInsets(top: edgeInset/2, left: edgeInset/2, bottom: edgeInset/2, right: edgeInset/2)
        setImage(nil, for: .normal)
        addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    
        if isShadowed {
        
            addShadowAndRoundCorners(cornerRadius: edgeInset, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0))
            
        } else {
            
            addShadowAndRoundCorners(cornerRadius: edgeInset, shadowOpacity: 0.0)
            
        }
        
    }
    
    @objc func toggleCheck() {
        
        isChecked = !isChecked
        
    }
    
    func toggleShadow() {
        
        isShadowed = !isShadowed
        
    }
    
}

final class ImageBubbleButton: BubbleButton {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        imageView?.layer.cornerRadius = min(frame.width, frame.height)/2
        
    }
    
}

