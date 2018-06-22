//
//  HexConverter.swift
//  Teammate Finder
//
//  Created by Conner Christianson on 6/21/18.
//  Copyright © 2018 Conner Christianson. All rights reserved.
//

import UIKit

class HexConverter: NSObject {
    static func hexStringToUIColor (hex:String) -> UIColor {
        let cString:String = hex.uppercased()
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
