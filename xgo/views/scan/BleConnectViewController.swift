//
//  BleConnectViewController.swift
//  findx
//
//  Created by admin on 2019/4/3.
//  Copyright © 2019 wulianedu. All rights reserved.
//

import UIKit
import CoreBluetooth


class BleConnectViewController: UIViewController,CBCentralManagerDelegate,UITextFieldDelegate {

    //UI按钮
    @IBOutlet weak var renameBtn: UIButton!
    @IBOutlet weak var disconnectBtn: UIButton!
    @IBOutlet weak var connectedImg: UIImageView!//已连接图标
    @IBOutlet weak var connectedView: UIView!//包含断开连接和重新命名按钮的两个链接
    @IBOutlet weak var connectedTitleView: UIView!//已成功连接
    @IBOutlet weak var shakeView: UIView!//未连接的 摇一摇的按钮
    //蓝牙相关:
    var myCentralManager: CBCentralManager!
    var myPeripherals: NSMutableArray = NSMutableArray() //保存扫描到的手环
    var myPeripheralToMainView :CBPeripheral! //初始化外设，用以传递给主页面
    
    let alertShaked = UIAlertController(title: NSLocalizedString("系统提示", comment: "系统提示"),
                                         message: NSLocalizedString("正在扫描", comment: "正在扫描")+":...", preferredStyle: .alert)
    let alertConnect = UIAlertController(title: NSLocalizedString("系统提示", comment: "系统提示"),
                                         message: NSLocalizedString("正在连接", comment: "正在连接")+":...", preferredStyle: .alert)
    let alertError = UIAlertController(title: NSLocalizedString("系统提示", comment: "系统提示"),
                                       message: NSLocalizedString("连接失败", comment: "连接失败"), preferredStyle: .alert)
    let alertTIMEOUT = UIAlertController(title: NSLocalizedString("系统提示", comment: "系统提示"),
                                         message: NSLocalizedString("连接超时", comment: "连接超时"), preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
        initBle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshHidden()
    }

    func initView() {
        refreshHidden()
        renameBtn.layer.cornerRadius = 10
        disconnectBtn.layer.cornerRadius = 10
        disconnectBtn.layer.borderWidth = 1
        disconnectBtn.layer.borderColor = RGB(r: 39, g: 233, b: 158).cgColor
        //添加提示框
        let cancelAction = UIAlertAction(title: NSLocalizedString("取消连接", comment: "取消连接"), style: .default, handler: {
            action in self.myCentralManager.cancelPeripheralConnection(self.myPeripheralToMainView)
        })
        alertConnect.addAction(cancelAction)
        let okAction = UIAlertAction(title: NSLocalizedString("好的", comment: "好的"), style: .cancel, handler: nil)
        alertShaked.addAction(okAction)
        alertError.addAction(okAction)
        alertTIMEOUT.addAction(okAction)
    }
    
    func initBle(){
        myCentralManager = CBCentralManager(delegate: self , queue: nil)
    }
    
    func refreshHidden() {
        if BLEMANAGER?.isConnect() ?? false{
            print("连接了")
            connectedImg.isHidden = false
            connectedView.isHidden = false
            connectedTitleView.isHidden = false
            shakeView.isHidden = true
        }else{
            print("未连接")
            connectedImg.isHidden = true
            connectedView.isHidden = true
            connectedTitleView.isHidden = true
            shakeView.isHidden = false
        }
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        self.present(alertShaked, animated: true, completion: nil)
        myPeripherals.removeAllObjects()
        myCentralManager.scanForPeripherals(withServices: nil, options: nil) //不限制
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.navigationController?.popViewController(animated: true)
            if(self.myPeripherals.count==0){
                CBToast.showToastAction(message: NSLocalizedString("未发现设备", comment: "未发现设备") as NSString)
            }else{
                
                self.myPeripherals.sorted(by: { (s1, s2) -> Bool in
                    let fb = (s1 as! CBPeripheral).readRSSI() < (s2 as! CBPeripheral).readRSSI()
                    return fb
                })
                self.myPeripheralToMainView = self.myPeripherals[0] as! CBPeripheral
                self.connectPeripheral(peripheral: self.myPeripheralToMainView)
            }
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //蓝牙检查
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case CBManagerState.poweredOn:  //蓝牙已打开正常
            NSLog("状态正常")
        case CBManagerState.unauthorized: //无BLE权限
            NSLog("无BLE权限")
        case CBManagerState.poweredOff: //蓝牙未打开
            NSLog("蓝牙未开启")
            CBToast.showToastAction(message: NSLocalizedString("蓝牙未开启", comment: "蓝牙未开启") as NSString)
        default:
            NSLog("状态无变化")
        }
    }
    
    //蓝牙搜索回调
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        if(peripheral.name?.isEmpty == false && peripheral.name!.hasPrefix("XGO")){
            print("peripheral:\(peripheral)")
            print("rssi:\(RSSI)")
            if Int(RSSI) > -80{
                myPeripherals.add(peripheral)
            }
        }
    }
    
    //连接设备
    func connectPeripheral(peripheral:CBPeripheral){
        myCentralManager.connect(peripheral, options: nil)
        var nameToConnect : String!
        if peripheral.name == nil {
            nameToConnect = NSLocalizedString("无名设备", comment: "无名设备")
        }else{
            nameToConnect = peripheral.name!
        }
        alertConnect.message = NSLocalizedString("正在连接", comment: "正在连接")+":\(nameToConnect!)..."
        self.present(alertConnect, animated: true, completion: nil)
    }
    
    //链接成功，相应函数
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("已连接\(peripheral.name!)")
        self.myPeripheralToMainView! = peripheral
        self.alertConnect.dismiss(animated: false) {
            self.navigationController?.popViewController(animated: true)
        }
        
        if BLEMANAGER == nil {
            BLEMANAGER = FindBleManager(centralManager: myCentralManager, peripheral: myPeripheralToMainView)
            BLEMANAGER?.start()
            
        }else{
            BLEMANAGER?.close()
            BLEMANAGER = FindBleManager(centralManager: myCentralManager, peripheral: myPeripheralToMainView)
            BLEMANAGER?.start()
        }
    }
    
 
    
    @IBAction func onClick(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            print("退出按钮")
            self.navigationController?.popViewController(animated: true)
        case 102:
            print("搜索按钮")
            if BLEMANAGER != nil {
                BLEMANAGER?.close()
            }
            let vc = DeviceScanViewController(nibName:"DeviceScanViewController",bundle: nil)
            self.present(vc, animated: true, completion: nil);
        case 103:
            print("断开连接")
            if BLEMANAGER != nil {
                BLEMANAGER?.close()
            }
            if UIDevice.isPad() {
                CBToast.showToast(message: NSLocalizedString("disconnect", comment: "断开连接") as NSString, aLocationStr: "bottom", aShowTime: 2)
                self.navigationController?.popViewController(animated: true)
            }
            refreshHidden()
        case 104:
            print("重新命名")
            
            //初始化UITextField
            var inputText:UITextField = UITextField();
            let msgAlertCtr = UIAlertController.init(title: NSLocalizedString("提示", comment: "提示"), message: NSLocalizedString("请输入设备名", comment: "请输入设备名"), preferredStyle: .alert)
            
            //添加textField输入框
            msgAlertCtr.addTextField { (textField) in
                //设置传入的textField为初始化UITextField
                inputText = textField
                inputText.placeholder = NSLocalizedString("输入数据", comment: "输入数据")
                inputText.keyboardType = UIKeyboardType.namePhonePad;
                inputText.delegate = self
            }
            let ok = UIAlertAction.init(title: NSLocalizedString("确定", comment: "确定"), style:.default) { (action:UIAlertAction) ->() in
                if((inputText.text) != ""){
                    print("你输入的是：\(String(describing: inputText.text))")
                    let name = inputText.text!
                    //            FindControlUtil.setName(name: "123")
//                    FindControlUtil.setName(name: name)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        print("未连接")
                        self.connectedImg.isHidden = true
                        self.connectedView.isHidden = true
                        self.connectedTitleView.isHidden = true
                        self.shakeView.isHidden = false
                    }
                }
            }
            
            let cancel = UIAlertAction.init(title: NSLocalizedString("取消", comment: "取消"), style:.cancel) { (action:UIAlertAction) -> ()in
                print("取消输入")
            }
            msgAlertCtr.addAction(ok)
            msgAlertCtr.addAction(cancel)
            //设置到当前视图
            self.present(msgAlertCtr, animated: true, completion: nil)
            
        default:
            print("啥?")
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        let inverseSet = NSCharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789").inverted
        
        // At every character in this "inverseSet" contained in the string,
        // split the string up into components which exclude the characters
        // in this inverse set
        let components = string.components(separatedBy: inverseSet)
        
        // Rejoin these components
        let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
        
        // If the original string is equal to the filtered string, i.e. if no
        // inverse characters were present to be eliminated, the input is valid
        // and the statement returns true; else it returns false
        return string == filtered
    }
}
