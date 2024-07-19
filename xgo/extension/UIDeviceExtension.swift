//
//  UIDeviceExtension.swift
//  findx
//
//  Created by admin on 2019/11/29.
//  Copyright © 2019 wulianedu. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice{
    
    public class func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    class func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}



public extension UIColor {
    /**
     Helper extension for creating a UIColor based on a hex value

     -parameter hex: The hex value (like 0xffffff) that wil be used for the color
     */
    convenience init(hex: Int) {
        let red = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00ff00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000ff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
