//
//  XgoBleMessageEntity.swift
//  xgo
//
//  Created by 袁文麟 on 2021/8/28.
//

import Foundation

class XgoBleMessageEntity: NSObject {
    public var keyCode:Int8?
    public var data:[UInt8] = [UInt8]() //消息内容(无包头包尾,无)
    public let timeoutReSend:Bool?//回复数据超时后是否重发
    public let timeout:Int?//对于需要回执的应用为回执超时时长
    public let callBack:Bool?//等待回调
    public var delegate:CallBack?//消息回调
    typealias CallBack = (_ data : [UInt8]) -> Void
    
    init(keyCode:Int8,data:[UInt8],timeoutReSend:Bool,timeout:Int,callBack:Bool) {
        self.keyCode = keyCode
        self.data = data
        self.timeoutReSend = timeoutReSend
        self.timeout = timeout
        self.callBack = callBack
    }
    
    init(keyCode:Int8,data:[UInt8],timeoutReSend:Bool,timeout:Int,callBack:Bool,delegate:@escaping CallBack) {
        self.keyCode = keyCode
        self.data = data
        self.timeoutReSend = timeoutReSend
        self.timeout = timeout
        self.callBack = callBack
        self.delegate = delegate
    }
    
    func setDelegate(delegate:@escaping CallBack) {
        self.delegate = delegate
    }
    
    func getMessageData() -> [UInt8] {
        let count = data.count + 6 //获取String字符串的长度 + 加头尾格式
        let countByte = UInt8(truncating: NSNumber(value: count))
        //校验位判断
        var checkSum: UInt8 = countByte
        for i in 0...self.data.count-1 {
            checkSum = checkSum &+ data[i]
        }
        checkSum = 0xff - checkSum
        
        let result1:[UInt8] = BLE_WORD_BEGIN + [countByte] + self.data + [checkSum] + BLE_WORD_END
        return result1
    }
}
