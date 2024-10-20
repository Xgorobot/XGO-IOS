//
//  FindBleManager.swift
//  findx
//
//  Created by lzx on 2018/8/9.
//  Copyright © 2018年 wulianedu. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import DownPicker


class FindBleManager:NSObject,CBCentralManagerDelegate, CBPeripheralDelegate{
    
    /*********************** 说明 ******************/
    // [UUID_Characteristic] 常量，里面对应的值是蓝牙设备对应服务的UUID。
    let UUID_Characteristic:[String] = ["FFF0","FFF1","FFF2","FFF3"]
    /***********************   说明END   ******************/
    
    var trCharacteristicDownPicker: DownPicker!
    var myTimer: Timer!

    let TIMEOUT: TimeInterval = 0.5//超时时长
    var nowCode: Int8? = -1 //当前指令的编号
    
    // MARK:属性
    var trCharacteristicDownPickerElements: [String] = []
    var trFlagLastConnectState : Bool! = false
//    var trCommunicationArray : [UInt8] = [UInt8](repeating: 0,count: 3) //创建传输数据
//    var trWriteCount: UInt64 = 0 //写入计数器
//    var trWriteErroCount: UInt64 = 0 //写入错误计数器
//    var checkDelay: Int = 0 //写入错误计数器
//    var trDownPickLastSelected: Int = -1
    var resendTimes = 0//当前重试次数
    var RESEND_MAX = 3//最多重试次数
    //容器，保存搜索到的蓝牙设备
    var PeripheralToConncet : CBPeripheral!
    var trCBCentralManager : CBCentralManager!
    var trIOService : CBService!               //用于储存读写操作对应的CBService uuid  = AABB
    var trWriteCharacteristic : CBCharacteristic! //用于储存待写入的Characteristic   uuid =
    var trReadCharacteristic : CBCharacteristic! //用于储存待读取的Characteristic   uuid =
    var trNotifyCharacteristic : CBCharacteristic! //用处储存通知的Characteristic uuid =
    var trServices : NSMutableArray = NSMutableArray() //初始化动态数组用于储存Service
    var trArrayCharacteristic: [CBCharacteristic] = []//数组 用于储存全部的服务
    
    var messageList:[XgoBleMessageEntity] = []//数组 用于储存全部的消息
    var keyCode:Int8 = 0

    var deviceType = -1 //设备类型
    
    let lock = NSLock.init()//线程锁
    // MARK:初始化
    init(centralManager:CBCentralManager,peripheral:CBPeripheral) {
        self.PeripheralToConncet = peripheral
        self.trCBCentralManager = centralManager
    }
    
    // 蓝牙函数委托响应
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case CBManagerState.poweredOn:  //蓝牙已打开正常
            print("启动成功，开始搜索")
        case CBManagerState.unauthorized: //无BLE权限
            print("无BLE权限")
        case CBManagerState.poweredOff: //蓝牙未打开
            print("蓝牙未开启")
        default:
            print("状态无变化")
        }
    }
    
    //连接后调用,查找服务
    func peripheralStateDetect(currentPeripheral: CBPeripheral){
        //设备状态判断
        switch currentPeripheral.state {
        case CBPeripheralState.connected:
            print("已连接")
            currentPeripheral.discoverServices(nil)//搜索服务
            trFlagLastConnectState = true
        case CBPeripheralState.disconnected:
            print("未连接")
            if trFlagLastConnectState {
                print("设备\(currentPeripheral.name!)已断开连接")
                trFlagLastConnectState = false
            }else{
                print("设备\(currentPeripheral.name!)连接失败")
                trFlagLastConnectState = false
            }
        default:
            print("状态错误")
        }
    }
    
    //搜索到服务，开始搜索Characteristic
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        print("搜索到\(String(describing: peripheral.services?.count))个服务")
        //数据显示
        if peripheral.services?.count != 0{
            for service in peripheral.services! {
                //trTextInfo.insertText("服务:\(service.description)")
                if service.uuid.uuidString.contains("FFF0") {
                    print("获取到指定服务 \(service.uuid.uuidString)")
                    trIOService = service as CBService  //获取到指定读写的服务
                }
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }else{
            print("无有效服务")
        }
    }
    
    //设置notify
    func openNotify() {
        if trNotifyCharacteristic != nil {
            PeripheralToConncet.setNotifyValue(true, for: trNotifyCharacteristic)
            print("打开notify,uuid=\(trNotifyCharacteristic.uuid.uuidString)")
        }
    }
    
    //搜索到Characteristic   查找指定读写的属性
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        print("从服务\(service.uuid.uuidString) 搜索到\(String(describing: service.characteristics?.count))个属性")
        if service.characteristics!.count != 0 {
            for Characteristic in service.characteristics!{
                //此处有未知bug for in 循环无法给变量正确定义属性，所需要我们自己找个中介变量定义一下
                let aC :CBCharacteristic = Characteristic as CBCharacteristic
                if trIOService != nil {
                    if  trIOService == service {
                        for uuid in UUID_Characteristic {
                            if aC.uuid.uuidString.contains(uuid) {
                                print("获取到指定属性\(aC.uuid.uuidString)")
                                trArrayCharacteristic.append(aC as CBCharacteristic)  //添加到数组中
                                print("添加到数组 idx = \(trArrayCharacteristic.endIndex)")
                                trCharacteristicDownPickerElements.append(uuid)
                            }
                        }
                    }
                }
            }
        }
        setCharacteristic()
    }
    
    //读取响应
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        if error == nil {
            //显示数据
            var readValue : [UInt8] = [UInt8]()
            for readData in characteristic.value! {
                readValue += [readData]
            }
            onDataReceive(data: readValue)
        }else{
            NSLog("读取错误 \(error.debugDescription)")
        }
    }
    
    //设置读写的Charateristic
    func setCharacteristic(){
        if trArrayCharacteristic.count>0 {
            //此处用于设置所选的属性
            trWriteCharacteristic = trArrayCharacteristic[1]
            trNotifyCharacteristic = trArrayCharacteristic[0]
            openNotify()
        }
    }
    
//    var runString = "BB6608010002010100FF00"
    
    // MARK:功能模块
    //写入响应函数
    func writeData(data:[UInt8]) {
        var string = ""
        for hexData in data {
            string = string + String(format:" %02X", hexData)
        }
        print("发送数据:\(string)")
        // MARK: 发送数据
        if PeripheralToConncet.state == CBPeripheralState.connected {
            if trWriteCharacteristic != nil {
                //启动写入， 向trWriteCharacteristic写入数据
//                PeripheralToConncet.writeValue(data, for:   trWriteCharacteristic, type: CBCharacteristicWriteType.withResponse)
                PeripheralToConncet.writeValue(Data(data), for: trWriteCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }else{
            print("未连接")
        }
    }
    
    var dataAll: [UInt8] = []//保存未处理的分包数据
   
    func onDataReceive(data:[UInt8]) {
        if FindBleHelper.checkData(data: data) {
            let msg = FindBleHelper.getMessageInData(data: data)
            getDataDealled(data: msg)
//            print("格式检查通过 \(msg)")
        }else{
            print("消息格式不正确")
        }
    }
    
    func getDataDealled(data:[UInt8]){
        //MARK: 收到数据 分包 沾包
        var string = ""
        for hexData in data {
            string = string + String(format:" %02X", hexData)
        }
        print("数据收发 收到数据测试完整: data:\(string) 数据长度: \(data.count)")
    
        if messageList.count>0 {
            print("上一条:\(messageList[0].keyCode!) 返回值:\(data[2])")
            let key = String(data[2])
            let task = taskDictionary[key]
            DelayUtils.cancel(task)
            //注释掉的是keycode 消息指令认证,现在只发一条消息
//            if messageList[0].keyCode! == data[2] {
                let codeTimerKey = String(messageList[0].keyCode!)
                print("关闭超时检查 检查key:"+codeTimerKey+"    超时时长:\(messageList[0].timeout)" )
                nowCode = -1
                let nowMsg = messageList[0]
                messageList.remove(at: 0)
                sendNext()
                Thread.sleep(forTimeInterval: 0.1)
                if let callBack = nowMsg.delegate{
                    callBack(data)
                }
//            }else{
//                print("不是上一条发出指令的回复")
//            }
        }
    }
    
    
    func addMsg(msg:XgoBleMessageEntity){
        lock.lock()
        keyCode = keyCode + 1
        if keyCode > 9 {
            keyCode = 0
        }
        msg.keyCode = self.keyCode
        print("添加新的消息,添加前数量:\(messageList.count)")
        if messageList.count > 40 {
            return
        }
        
        messageList.append(msg)
        if messageList.count == 1 {
            print(" 数量为1 ,添加后直接发送")
            sendNext()
        }
        lock.unlock()
    }
    
    //清空未发送的msg
    func clearMsg(){
        if messageList.count>0 {
            let msg = messageList[0]
            messageList.removeAll()
            messageList.append(msg)
        }
    }

    func sendNext() {
        self.resendTimes = 0
        print("sendNext: 剩余指令:", messageList.count,"个")
        if messageList.count>0 {
            let msgData = messageList[0]
            writeData(data: msgData.getMessageData())
            checkTimeOut(msgData: msgData)
        }else{
            print("发完所有指令,停止")
        }
    }

    var taskDictionary: [String: Task] = [:]
    
    func checkTimeOut(msgData:XgoBleMessageEntity){
        if !msgData.callBack! {
            print("不需要等待成功回执 ")
            print("准备移除第一个\(messageList.count)")
            messageList.remove(at: 0)
            sendNext()
        }else{
            self.nowCode = msgData.keyCode!
            var timeDelay: TimeInterval = TIMEOUT
            timeDelay = Double(msgData.timeout ?? 0)/1000
            let codeTimerKey = self.messageList[0].keyCode!
            let mTask = DelayUtils.delay(timeDelay) {
                //code
                if(self.messageList.count>0){
                    let codeTimerKey = self.messageList[0].keyCode!
                    if(self.nowCode! == codeTimerKey){
                        print("超时检查未通过 超时:\(timeDelay)",self.nowCode,codeTimerKey,"进行超时处理:",self.resendTimes," MAX:",self.RESEND_MAX)
                        if self.resendTimes < self.RESEND_MAX-1 && self.messageList[0].timeoutReSend ?? true{
                            //重发
                            let msgData = self.messageList[0]
                            self.writeData(data: msgData.getMessageData())
                            self.checkTimeOut(msgData: msgData)
                            self.resendTimes = self.resendTimes + 1
                        }else{
                            print("超时检查未通过  放弃指令")
                            self.resendTimes = 0
                            if let callBack = self.messageList[0].delegate{
                                callBack([])
                            }
                            self.messageList.remove(at: 0)
                            self.sendNext()
                        }
                    }else{
                        self.resendTimes = 0
                        print("超时检查通过")
                    }
                }else{
                    self.resendTimes = 0
                    print("指令已发完,通过超时检查")
                }
            }
            taskDictionary.updateValue(mTask!, forKey: String(codeTimerKey))
        }
    }

    
    func start() {
        //绑定CBPeripheral委托
        self.PeripheralToConncet.delegate = self
        peripheralStateDetect(currentPeripheral: PeripheralToConncet)  //获取当前设备状态,查找服务
    }
    
    func close() {

        //判断是否已连接,并且断开连接
        if PeripheralToConncet.state == CBPeripheralState.connected {
            trCBCentralManager.cancelPeripheralConnection(PeripheralToConncet) //页面关闭时断开连接
        }
    }
    
    func isConnect() -> Bool {
        return PeripheralToConncet.state == CBPeripheralState.connected
    }
    
//    func checkRepeat() -> Bool {
//        let nowTime = Int(Date().timeIntervalSince1970)
//        if nowTime - currentTimestamp > 200 {
//            currentTimestamp = nowTime
//            return true
//        }
//        return false
//    }
    private static var lastTimestamp: Int = 0

    func checkRepeat(action: () -> Void) {
        
        let nowTime = Int(Date().timeIntervalSince1970 * 1000) // 使用毫秒
        if nowTime - FindBleManager.lastTimestamp > 200 {
            action()
            FindBleManager.lastTimestamp = nowTime
        }
        
    }
    
}

