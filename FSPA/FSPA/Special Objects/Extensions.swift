//
//  Extensions.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 5/4/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit
import MapKit

extension UIColor {
    
    static let AnalCream: UIColor = UIColor(named: "AnalCream")!
    static let AnalDarkCrimson: UIColor = UIColor(named: "AnalDarkCrimson")!
    static let AnalGold: UIColor = UIColor(named: "AnalGold")!
    static let BgGray: UIColor = UIColor(named: "BgGray")!
    static let BgLightCream: UIColor = UIColor(named: "BgLightCream")!
    static let PrimaryBrown: UIColor = UIColor(named: "PrimaryBrown")!
    static let PrimaryCrimson: UIColor = UIColor(named: "PrimaryCrimson")!
    
    static func UIColorFromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
        
    }
    
}

extension UIImage {
    
    static let calendarIcon: UIImage = UIImage(named: "calendarIcon")!
    static let checkMarkIcon: UIImage = UIImage(named: "checkMarkIcon")!
    static let defaultMembersProfileImage: UIImage = UIImage(named: "defaultMembersProfileImage")!
    static let defaultAnnouncementsImage: UIImage = UIImage(named: "defaultAnnouncementsImage")!
    static let closeXMarkIcon: UIImage = UIImage(named: "closeXMarkIcon")!
    static let editPencilIcon: UIImage = UIImage(named: "editPencilIcon")!
    static let notVisibleEyeIcon: UIImage = UIImage(named: "notVisibleEyeIcon")!
    static let pinIcon: UIImage = UIImage(named: "pinIcon")!
    static let unpinIcon: UIImage = UIImage(named: "unpinIcon")!
    static let visibleEyeIcon: UIImage = UIImage(named: "visibleEyeIcon")!
    static let deleteIcon: UIImage = UIImage(named: "deleteIcon")!
    static let boldTextIcon: UIImage = UIImage(named: "boldTextIcon")!
    static let italicTextIcon: UIImage = UIImage(named: "italicTextIcon")!
    static let underlineTextIcon: UIImage = UIImage(named: "underlineTextIcon")!
    static let strikeTextIcon: UIImage = UIImage(named: "strikeTextIcon")!
    static let highlightTextIcon: UIImage = UIImage(named: "highlightTextIcon")!
    static let alignTextLeftIcon: UIImage = UIImage(named: "alignTextLeftIcon")!
    static let alignTextCenterIcon: UIImage = UIImage(named: "alignTextCenterIcon")!
    static let alignTextRightIcon: UIImage = UIImage(named: "alignTextRightIcon")!
    static let increaseIndentIcon: UIImage = UIImage(named: "increaseIndentIcon")!
    static let decreaseIndentIcon: UIImage = UIImage(named: "decreaseIndentIcon")!
    static let announcementsCollectionViewPlaceholder: UIImage = UIImage(named: "announcementsCollectionViewPlaceholder")!
    static let addPlusIcon: UIImage = UIImage(named: "addPlusIcon")!
    
}

extension UIView {
    
    final func addShadowAndRoundCorners(cornerRadius: CGFloat? = nil, shadowColor: UIColor? = nil, shadowOffset: CGSize? = nil, shadowOpacity: Float? = nil, shadowRadius: CGFloat? = nil, topRightMask: Bool = true, topLeftMask: Bool = true, bottomRightMask: Bool = true, bottomLeftMask: Bool = true) {
            
        layer.masksToBounds = false
        layer.cornerRadius = 8.0
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0) // Shifts shadow
        layer.shadowOpacity = 0.3 // Higher value means more opaque
        layer.shadowRadius = 3 // Higher value means more blurry
        var maskedCorners = CACornerMask()
        
        if let cr = cornerRadius { layer.cornerRadius = cr }
        if let sc = shadowColor { layer.shadowColor = sc.cgColor }
        if let sof = shadowOffset { layer.shadowOffset = sof }
        if let sop = shadowOpacity { layer.shadowOpacity = sop }
        if let sr = shadowRadius { layer.shadowRadius = sr }
        
        if topRightMask { maskedCorners.insert(.layerMaxXMinYCorner) }
        if topLeftMask { maskedCorners.insert(.layerMinXMinYCorner) }
        if bottomRightMask { maskedCorners.insert(.layerMaxXMaxYCorner) }
        if bottomLeftMask { maskedCorners.insert(.layerMinXMaxYCorner) }
        if !maskedCorners.isEmpty { layer.maskedCorners = maskedCorners }
        
    }
    
    final func getCornerRadiusFit(percentage: CGFloat) -> CGFloat {
        
        return (CGFloat(abs(percentage))/100)*0.5*min(frame.height, frame.width)
        
    }
    
}

extension CGFloat {
    
    static func getWidthFitSize (minSize: CGFloat, maxSize: CGFloat) -> CGFloat {
        
        return CGSize.currentIphoneSize.width*(((minSize/CGSize.smallestIphoneSize.width) + (maxSize/CGSize.largestIphoneSize.width))/2)
        
    }
    
    static func getHeightFitSize (minSize: CGFloat, maxSize: CGFloat) -> CGFloat {
        
        return CGSize.currentIphoneSize.height*(((minSize/CGSize.smallestIphoneSize.height) + (maxSize/CGSize.largestIphoneSize.height))/2)
        
    }
    
    static func getPercentageWidth(percentage: CGFloat) -> CGFloat {
        
        return (CGFloat(abs(percentage))/100)*CGSize.currentIphoneSize.width
        
    }
    
    static func getPercentageHeight(percentage: CGFloat) -> CGFloat {
        
        return (CGFloat(abs(percentage))/100)*CGSize.currentIphoneSize.height
        
    }
    
    static func getPercentageWidthFit(minPercentage: CGFloat, maxPercentage: CGFloat) -> CGFloat {
        
        return (getPercentageWidth(percentage: minPercentage) + getPercentageWidth(percentage: maxPercentage))/2
        
    }
    
    static func getPercentageHeightFit(minPercentage: CGFloat, maxPercentage: CGFloat) -> CGFloat {
        
        return (getPercentageHeight(percentage: minPercentage) + getPercentageHeight(percentage: maxPercentage))/2
        
    }
    
}

extension CGSize {
    
    static let currentIphoneSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    static let smallestIphoneSize = CGSize(width: 320.0, height: 568.0) // Iphone SE
    static let largestIphoneSize = CGSize(width: 414.0, height: 896.0) // Iphone 11 Pro Max
    
    static func getBestFitSize (minSize: CGSize, maxSize: CGSize) -> CGSize {
        
        let widthFit = CGFloat.getWidthFitSize(minSize: minSize.width, maxSize: maxSize.width)
        let heightFit = CGFloat.getHeightFitSize(minSize: minSize.height, maxSize: maxSize.height)
        
        return CGSize(width: widthFit, height: heightFit)
        
    }
    
    static func getPercentageSize(percentage: CGFloat) -> CGSize {
        
        return CGSize(width: CGFloat.getPercentageWidth(percentage: percentage), height: CGFloat.getPercentageHeight(percentage: percentage))
        
    }
    
    static func getPercentageBestFit(minPercentage: CGFloat, maxPercentage: CGFloat) -> CGSize {
        
        return CGSize(width: CGFloat.getPercentageWidthFit(minPercentage: minPercentage, maxPercentage: maxPercentage), height: CGFloat.getPercentageHeightFit(minPercentage: minPercentage, maxPercentage: maxPercentage))
        
    }
    
}
