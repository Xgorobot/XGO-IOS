//
//  DateExtension.swift
//  xgo
//
//  Created by 袁文麟 on 2021/9/17.
//

import Foundation

extension Date {

    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : Double {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return round(timeInterval*1000)
    }
}
