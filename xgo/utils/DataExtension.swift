//
//  DataExtension.swift
//  findx
//
//  Created by lzx on 2018/8/8.
//  Copyright © 2018年 wulianedu. All rights reserved.
//

import Foundation

extension Data {
    
    /// Create hexadecimal string representation of `Data` object.
    /// data转hexString
    /// - returns: `String` representation of this `Data` object.
    
    func hexadecimal() -> String {
        return map { String(format: "%02x", $0) }
            .joined(separator: "")
    }
}
