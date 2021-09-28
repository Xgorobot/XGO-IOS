//
//  DeviceScanViewController.swift
//  findx
//
//  Created by lzx on 2018/8/8.
//  Copyright © 2018年 wulianedu. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceScanViewController: UIViewController,CBCentralManagerDelegate,UITableViewDelegate,UITableViewDataSource {
   
    typealias SaveCallback = (_ connectResult:String)->Void //声明一个回调
    var scanCallback:SaveCallback? //回调作为参数

    // MARK: - 控件
//    @IBOutlet weak var myButtonScan: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var scanErrorAlert: UILabel!
    
    let alertConnect = UIAlertController(title: NSLocalizedString("系统提示", comment: "系统提示"),
                                         message: NSLocalizedString("正在连接", comment: "正在连接"), preferredStyle: .alert)
    let alertError = UIAlertController(title: NSLocalizedString("系统提示", comment: "系统提示"),
                                       message: NSLocalizedString("连接失败", comment: "连接失败"), preferredStyle: .alert)
    let alertTIMEOUT = UIAlertController(title: NSLocalizedString("系统提示", comment: "系统提示"),
                                         message: NSLocalizedString("连接超时", comment: "连接超时"), preferredStyle: .alert)
    // MARK: - 属性 
    
    var flagScan : Bool! = false
    var myCentralManager: CBCentralManager!
//    var myPeripheral: CBPeripheral!
    var myCBError : CBError!
    //容器，保存搜索到的蓝牙设备
    var myPeripheralToMainView :CBPeripheral! //初始化外设，用以传递给主页面
    var myPeripherals: NSMutableArray = NSMutableArray() //初始化动态数组 用以储存字典
    //服务和UUID  可用于过滤器限定（限定条件：1.设备UUID 2.服务UUID）
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加Tableview的绑定
        myTableView.delegate = self
        myTableView.dataSource = self
        //创建一个重用的单元格
        myTableView.register(UINib(nibName: "ScanTableCell", bundle: nil), forCellReuseIdentifier: "myCell")

        //添加提示框
        let cancelAction = UIAlertAction(title: NSLocalizedString("取消连接", comment: "取消链接"), style: .default, handler: {
            action in self.myCentralManager.cancelPeripheralConnection(self.myPeripheralToMainView)
        })
        alertConnect.addAction(cancelAction)
        let okAction = UIAlertAction(title: NSLocalizedString("好的", comment: "好的"), style: .cancel, handler: nil)
        alertError.addAction(okAction)
        alertTIMEOUT.addAction(okAction)
        
        //添加CBPeripheral管理器的委托
        self.myCentralManager = CBCentralManager(delegate: self , queue: nil)
        scanErrorAlert.text = NSLocalizedString("如果长时间搜索不到或无法连接,请尝试重启设备或手机蓝牙.", comment: "如果长时间搜索不到或无法连接,请尝试重启设备或手机蓝牙.")
        scanErrorAlert.isHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSLog("停止搜索")
        self.myCentralManager.stopScan()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //返回
    @IBAction func backPress(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - 蓝牙响应函数
    //检查外设管理器状态
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case CBManagerState.poweredOn:  //蓝牙已打开正常
            NSLog("启动成功，开始搜索")
            self.myCentralManager.scanForPeripherals(withServices: nil, options: nil)
            scanErrorAlert.isHidden = false
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {            self.myCentralManager.stopScan() //不限制
//            }
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.5) {            self.myCentralManager.scanForPeripherals(withServices: nil, options: nil) //不限制
//            }

//            myButtonScan.setTitle("停止", for: UIControlState.normal)
            flagScan = true
        case CBManagerState.unauthorized: //无BLE权限
            NSLog("无BLE权限")
        case CBManagerState.poweredOff: //蓝牙未打开
            NSLog("蓝牙未开启")
        default:
            NSLog("状态无变化")
        }
    }
    
    //检查到设备，响应函数
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var nsPeripheral : NSArray
        nsPeripheral = myPeripherals.value(forKey: "peripheral") as! NSArray   //读取全部的外设值
        if(peripheral.name?.isEmpty == false && peripheral.name!.hasPrefix("XGO")){
            if(!nsPeripheral.contains(peripheral)){                                //判断数组内的peripheral与当前读取到的是否相同，若重复则不添加
                //新建字典
                let r : NSMutableDictionary = NSMutableDictionary()
                r.setValue(peripheral, forKey: "peripheral")
                r.setValue(RSSI, forKey: "RSSI")
                r.setValue(advertisementData, forKey: "advertisementData")
                if let name:String = advertisementData["kCBAdvDataLocalName"] as? String {
                    r.setValue(name, forKey: "name")
                    myPeripherals.add(r)
                    NSLog("搜索到设备，Name=\(peripheral.name!) UUID=\(peripheral.identifier) 广播名:\(name)")
                    self.myTableView.reloadData()
                    scanErrorAlert.isHidden = true
                }
            }else{
                //重复搜索
                for (index,value) in myPeripherals.enumerated() {
                    if let dic:NSMutableDictionary = value as? NSMutableDictionary{
                        print(dic["peripheral"])
                        if let name:String = advertisementData["kCBAdvDataLocalName"] as? String {
                            dic.setValue(name, forKey: "name")
                            NSLog("更新设备名\(name)")
                            self.myTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    //链接成功，相应函数
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("已连接\(peripheral.name!)")
        self.myPeripheralToMainView! = peripheral
        CBToast.showToast(message: NSLocalizedString("connect success", comment: "connect success") as NSString, aLocationStr: "bottom", aShowTime: 2)
        self.alertConnect.dismiss(animated: false) {
            self.dismiss(animated: true, completion: nil)
//            self.navigationController?.popViewController(animated: true)
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
    //自定义的连接函数，会弹出提示框
    func connectPeripheral(peripheral:CBPeripheral){
        myCentralManager.connect(peripheral, options: nil)
        var nameToConnect : String!
        if peripheral.name == nil {
            nameToConnect = "无名设备"
        }else{
            nameToConnect = peripheral.name!
        }
        alertConnect.message = NSLocalizedString("正在连接", comment: "正在连接") + ":" + nameToConnect! + "..."
        self.present(alertConnect, animated: true, completion: nil)
    }
    
    //链接失败响应函数
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        print("连接失败，设备名\(peripheral.name!),原因\(String(describing: error))")
        alertConnect.dismiss(animated: false, completion:  nil)
        self.present(alertError, animated: false, completion:  nil)  //弹出失败提示框
    }
    
    // MARK: - TableView代理函数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ScanTableCell = tableView.dequeueReusableCell(withIdentifier: "myCell")
            as! ScanTableCell
        let data:NSDictionary = myPeripherals[indexPath.row] as! NSDictionary
        let peripheral:CBPeripheral = data.value(forKey: "peripheral") as! CBPeripheral
        let name:String = data.value(forKey: "name") as! String
        let advertisementData:NSDictionary = data.value(forKey: "advertisementData") as! NSDictionary
        let rssi:NSNumber  = data.value(forKey: "RSSI") as! NSNumber
        
        //传递数据到控件
        cell.nameLabel.text? = "\(name)  "
        cell.rssiLabel.text? = "\(rssi)dB"
        if rssi.int32Value > -75 {
            cell.rssiImg.image = #imageLiteral(resourceName: "ble_level5")
        }else if rssi.int32Value > -85{
            cell.rssiImg.image = #imageLiteral(resourceName: "ble_level4")
        }else if rssi.int32Value > -95{
            cell.rssiImg.image = #imageLiteral(resourceName: "ble_level3")
        }else if rssi.int32Value > -105{
            cell.rssiImg.image = #imageLiteral(resourceName: "ble_level2")
        }else{
            cell.rssiImg.image = #imageLiteral(resourceName: "ble_level1")
        }
//        cell.uuidLabel.text? = "\(p.identifier)"
        
        NSLog("设备名\(String(describing: name)),状态\(peripheral.state),UUID\(peripheral.identifier),信号\(rssi)")
        NSLog("广播内容\(data.allValues)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("停止搜索")
        self.myCentralManager.stopScan()
//        myButtonScan.setTitle("搜索", for: UIControlState.normal)
        flagScan = false
        //关闭TableView的选择动画
        myTableView.deselectRow(at: indexPath, animated: true)
        //提取设备库中当前所选的设备传递到全局变量
        let myPeriDict:NSDictionary = myPeripherals[indexPath.row] as! NSDictionary
        myPeripheralToMainView = myPeriDict.value(forKey:"peripheral") as? CBPeripheral
        connectPeripheral(peripheral: myPeripheralToMainView)
    }
}
