//
//  BleMessageEntity.swift
//  findx 的指令集
//
//  Created by lzx on 2018/8/10.
//  Copyright © 2018年 wulianedu. All rights reserved.
//

import Foundation
import UIKit

class BleMessageEntity: NSObject {
    public var keyCode:Int8?
    public let dataString:String?
    public let timeoutReSend:Bool?//回复数据超时后是否重发
    public let timeout:Int?//超时时长
    public let callBack:Bool?//等待回调
    public var delegate:CallBack?//消息回调
    typealias CallBack = (_ data : [UInt8]) -> Void

    let startString = "BB66"
    
    init(keyCode:Int8,dataString:String,timeoutReSend:Bool,timeout:Int,callBack:Bool) {
        self.keyCode = keyCode
        self.dataString = dataString.removeAllSapce
        self.timeoutReSend = timeoutReSend
        self.timeout = timeout
        self.callBack = callBack
    }
    init(keyCode:Int8,dataString:String,timeoutReSend:Bool,timeout:Int,callBack:Bool,delegate:@escaping CallBack) {
        self.keyCode = keyCode
        self.dataString = dataString.removeAllSapce
        self.timeoutReSend = timeoutReSend
        self.timeout = timeout
        self.callBack = callBack
        self.delegate = delegate
    }
    func setDelegate(delegate:@escaping CallBack) {
        self.delegate = delegate
    }
    
    func getMessageString() -> String {
        let count = dataString!.count/2 + 1  //获取String字符串的长度
        let countStr = StringUtils.int16To2Lenhex(number: Int16(count))
        let keyCodeStr = String(format: "%02d", keyCode!)
//        print("指令输出: 1 start 2 count 3 keyCode 4 dataString")
//        print(startString)
//        print(countStr)
//        print(keyCodeStr)
//        print(dataString!)
        let result = "\(startString)\(countStr)\(keyCodeStr)\(dataString!)"
        return result
    }
}
