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
