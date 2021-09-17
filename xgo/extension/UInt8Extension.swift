//
//  UInt8Extension.swift
//  xgo
//
//  Created by 袁文麟 on 2021/9/17.
//

import Foundation

extension UInt8 {
    func integerValue() -> Int{
        return NSString(format: "%d", self).integerValue
    }
}
