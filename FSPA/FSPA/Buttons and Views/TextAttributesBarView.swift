//
//  TextAttributesBarView.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 5/14/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit

class TextAtrributesBarView: UIScrollView {
    
    let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 1.6)
    let buttonEdgeInset: CGFloat = .getPercentageWidth(percentage: 2.1)
    private(set) var barHeight: CGFloat = .getPercentageWidth(percentage: 12)
    
    lazy private var textAttributesBarStackView: UIStackView = {
        
        var textAttributesBarStackView = UIStackView(arrangedSubviews: [boldTextButton, italicTextButton, underlineTextButton, strikeTextButton, highlightTextButton, alignTextLeftButton, alignTextCenterButton, alignTextRightButton, increaseIndentButton, decreaseIndentButton])
        textAttributesBarStackView.axis = .horizontal
        textAttributesBarStackView.alignment = .fill
        textAttributesBarStackView.distribution = .fill
        textAttributesBarStackView.spacing = horizontalEdgeInset
        return textAttributesBarStackView
        
    }()
    
    lazy private(set) var boldTextButton: ToggleButton = {
        
        var boldTextButton = ToggleButton(toggleButtonOffImage: UIImage.boldTextIcon, toggleButtonOffImageColor: UIColor.white, toggleButtonOnImage: UIImage.boldTextIcon, toggleButtonOnImageColor: UIColor.PrimaryCrimson)
        boldTextButton.contentEdgeInsets = UIEdgeInsets(top: buttonEdgeInset, left: buttonEdgeInset, bottom: buttonEdgeInset, right: buttonEdgeInset)
        boldTextButton.translatesAutoresizingMaskIntoConstraints = false
        boldTextButton.widthAnchor.constraint(equalTo: boldTextButton.heightAnchor).isActive = true
        return boldTextButton
        
    }()
    
    lazy private(set) var italicTextButton: ToggleButton = {
        
        var italicTextButton = ToggleButton(toggleButtonOffImage: UIImage.italicTextIcon, toggleButtonOffImageColor: UIColor.white, toggleButtonOnImage: UIImage.italicTextIcon, toggleButtonOnImageColor: UIColor.PrimaryCrimson)
        italicTextButton.contentEdgeInsets = UIEdgeInsets(top: buttonEdgeInset, left: buttonEdgeInset, bottom: buttonEdgeInset, right: buttonEdgeInset)
        italicTextButton.translatesAutoresizingMaskIntoConstraints = false
        italicTextButton.widthAnchor.constraint(equalTo: italicTextButton.heightAnchor).isActive = true
        return italicTextButton
        
    }()
    
    lazy private(set) var underlineTextButton: ToggleButton = {
        
        var underlineTextButton = ToggleButton(toggleButtonOffImage: UIImage.underlineTextIcon, toggleButtonOffImageColor: UIColor.white, toggleButtonOnImage: UIImage.underlineTextIcon, toggleButtonOnImageColor: UIColor.PrimaryCrimson)
        underlineTextButton.contentEdgeInsets = UIEdgeInsets(top: buttonEdgeInset, left: buttonEdgeInset, bottom: buttonEdgeInset, right: buttonEdgeInset)
        underlineTextButton.translatesAutoresizingMaskIntoConstraints = false
        underlineTextButton.widthAnchor.constraint(equalTo: underlineTextButton.heightAnchor).isActive = true
        return underlineTextButton
        
    }()
    
    lazy private(set) var strikeTextButton: ToggleButton = {
        
        var strikeTextButton = ToggleButton(toggleButtonOffImage: UIImage.strikeTextIcon, toggleButtonOffImageColor: UIColor.white, toggleButtonOnImage: UIImage.strikeTextIcon, toggleButtonOnImageColor: UIColor.PrimaryCrimson)
        strikeTextButton.contentEdgeInsets = UIEdgeInsets(top: buttonEdgeInset, left: buttonEdgeInset, bottom: buttonEdgeInset, right: buttonEdgeInset)
        strikeTextButton.translatesAutoresizingMaskIntoConstraints = false
        strikeTextButton.widthAnchor.constraint(equalTo: strikeTextButton.heightAnchor).isActive = true
        return strikeTextButton
        
    }()
    
    lazy private(set) var highlightTextButton: ToggleButton = {
        
        var highlightTextButton = ToggleButton(toggleButtonOffImage: UIImage.highlightTextIcon, toggleButtonOffImageColor: UIColor.white, toggleButtonOnImage: UIImage.highlightTextIcon, toggleButtonOnImageColor: UIColor.PrimaryCrimson)
        highlightTextButton.contentEdgeInsets = UIEdgeInsets(top: buttonEdgeInset, left: buttonEdgeInset, bottom: buttonEdgeInset, right: buttonEdgeInset)
        highlightTextButton.translatesAutoresizingMaskIntoConstraints = false
        highlightTextButton.widthAnchor.constraint(equalTo: highlightTextButton.heightAnchor).isActive = true
        return highlightTextButton
        
    }()
    
    lazy private(set) var alignTextLeftButton: ToggleButton = {
        
        var alignTextLeftButton = ToggleButton(toggleButtonOffImage: UIImage.alignTextLeftIcon, toggleButtonOffImageColor: UIColor.white, toggleButtonOnImage: UIImage.alignTextLeftIcon, toggleButtonOnImageColor: UIColor.PrimaryCrimson)
        alignTextLeftButton.contentEdgeInsets = UIEdgeInsets(top: buttonEdgeInset, left: buttonEdgeInset, bottom: buttonEdgeInset, right: buttonEdgeInset)
        alignTextLeftButton.translatesAutoresizingMaskIntoConstraints = false
        alignTextLeftButton.widthAnchor.constraint(equalTo: alignTextLeftButton.heightAnchor).isActive = true
        return alignTextLeftButton
        
    }()
    
    lazy private(set) var alignTextCenterButton: ToggleButton = {
        
        var alignTextCenterButton = ToggleButton(toggleButtonOffImage: UIImage.alignTextCenterIcon, toggleButtonOffImageColor: UIColor.white, toggleButtonOnImage: UIImage.alignTextCenterIcon, toggleButtonOnImageColor: UIColor.PrimaryCrimson)
        alignTextCenterButton.contentEdgeInsets = UIEdgeInsets(top: buttonEdgeInset, left: buttonEdgeInset, bottom: buttonEdgeInset, right: buttonEdgeInset)
        alignTextCenterButton.translatesAutoresizingMaskIntoConstraints = false
        alignTextCenterButton.widthAnchor.constraint(equalTo: alignTextCenterButton.heightAnchor).isActive = true
        return alignTextCenterButton
        
    }()
    
    lazy private(set) var alignTextRightButton: ToggleButton = {
        
        var alignTextRightButton = ToggleButton(toggleButtonOffImage: UIImage.alignTextRightIcon, toggleButtonOffImageColor: UIColor.white, toggleButtonOnImage: UIImage.alignTextRightIcon, toggleButtonOnImageColor: UIColor.PrimaryCrimson)
        alignTextRightButton.contentEdgeInsets = UIEdgeInsets(top: buttonEdgeInset, left: buttonEdgeInset, bottom: buttonEdgeInset, right: buttonEdgeInset)
        alignTextRightButton.translatesAutoresizingMaskIntoConstraints = false
        alignTextRightButton.widthAnchor.constraint(equalTo: alignTextRightButton.heightAnchor).isActive = true
        return alignTextRightButton
        
    }()
    
    lazy private(set) var increaseIndentButton: BubbleButton = {
        
        var increaseIndentButton = BubbleButton(bubbleButtonImage: UIImage.increaseIndentIcon.withTintColor(UIColor.white))
        increaseIndentButton.backgroundColor = UIColor.PrimaryCrimson
        increaseIndentButton.contentEdgeInsets = UIEdgeInsets(top: buttonEdgeInset, left: buttonEdgeInset, bottom: buttonEdgeInset, right: buttonEdgeInset)
        increaseIndentButton.translatesAutoresizingMaskIntoConstraints = false
        increaseIndentButton.widthAnchor.constraint(equalTo: increaseIndentButton.heightAnchor).isActive = true
        return increaseIndentButton
        
    }()
    
    lazy private(set) var decreaseIndentButton: BubbleButton = {
        
        var decreaseIndentButton = BubbleButton(bubbleButtonImage: UIImage.decreaseIndentIcon.withTintColor(UIColor.white))
        decreaseIndentButton.backgroundColor = UIColor.PrimaryCrimson
        decreaseIndentButton.contentEdgeInsets = UIEdgeInsets(top: buttonEdgeInset, left: buttonEdgeInset, bottom: buttonEdgeInset, right: buttonEdgeInset)
        decreaseIndentButton.translatesAutoresizingMaskIntoConstraints = false
        decreaseIndentButton.widthAnchor.constraint(equalTo: decreaseIndentButton.heightAnchor).isActive = true
        return decreaseIndentButton
        
    }()
    
    init(withHeight height: CGFloat?) {
        
        if let height = height { barHeight = height }
        
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: .getPercentageWidth(percentage: 100), height: barHeight))
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        backgroundColor = .PrimaryCrimson
        addShadowAndRoundCorners(cornerRadius: 0.0, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: -1.0))
        isScrollEnabled = true
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal = true
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(textAttributesBarStackView)
        textAttributesBarStackView.translatesAutoresizingMaskIntoConstraints = false
        textAttributesBarStackView.topAnchor.constraint(equalTo: topAnchor, constant: verticalEdgeInset).isActive = true
        textAttributesBarStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalEdgeInset).isActive = true
        textAttributesBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -buttonEdgeInset).isActive = true
        textAttributesBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonEdgeInset).isActive = true
        textAttributesBarStackView.heightAnchor.constraint(equalTo: heightAnchor, constant: -verticalEdgeInset*2).isActive = true
        
    }
    
}
