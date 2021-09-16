//
//  FindBleHelper.swift
//  xgo
//
//  Created by 袁文麟 on 2021/8/25.
//

import Foundation
class FindBleHelper {
    
    //用于收到消息后,检查消息是否完整
    static func checkData(data:[UInt8]) -> Bool {
        //筛除长度过短消息
        if data.count < 7 {//TODO 在这里添加分包的判断处理
            return false
        }
        //数据长度错误
        let length = data[2]
        if data.count != length.integerValue() {//TODO 在这里添加粘包的判断
            return false
        }
        //判断开头结尾
        if !(data[0] == 0x55 && data[1] == 0x00 && data[data.count-2] == 0x00 && data[data.count-1] == 0xAA) {
            return false
        }
        //校验位判断
        var checkSum: UInt8 = 0
        for i in 2...data.count-4 {
            checkSum = checkSum &+ data[i]
        }
        if 0xff - checkSum != data[data.count-3] {
            return false
        }        
        return true
    }
    
    //MARK:从获取的完整消息里去除消息头消息尾获取内容
    static func getMessageInData(data:[UInt8]) -> [UInt8] {
        var result:[UInt8] = [UInt8]()
        for i in 3...data.count-4{
            result.append(data[i])
        }
        return result
    }
}
