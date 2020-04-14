//
//  CustomColors.swift
//  FSPA
//
//  Created by Manuel Alejandro Martin Callejo on 4/14/20.
//  Copyright © 2020 Poppin Software. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let AccDark = UIColor(named: "AccDark")
    
    static let AccGreen = UIColor(named: "AccGreen")
    
    static let AnalCream = UIColor(named: "AnalCream")
    
    static let AnalDarkCrimson = UIColor(named: "AnalDarkCrimson")
    
    static let AnalGold = UIColor(named: "AnalGold")
    
    static let BgGray = UIColor(named: "BgGray")
    
    static let BgLightCream = UIColor(named: "BgLightCream")
    
    static let PrimaryBrown = UIColor(named: "PrimaryBrown")
    
    static let PrimaryCrimson = UIColor(named: "PrimaryCrimson")
    
    static func UIColorFromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
        
    }
    
}
