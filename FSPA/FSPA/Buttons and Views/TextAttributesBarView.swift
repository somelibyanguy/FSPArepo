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

final class AttributedTextView: UITextView {
    
    private var textIsUnderlined: Bool = false // For bug purposes.
    private var highlightColor: UIColor = .yellow
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
    
    func toggleAttributedTextBar() {
        
        inputAccessoryView!.isHidden = !inputAccessoryView!.isHidden
        
    }
    
    func setHighlightColor(color: UIColor) {
        
        highlightColor = color
        
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
                
                textStorage.addAttribute(.backgroundColor, value: highlightColor, range: selectedRange)
                
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
