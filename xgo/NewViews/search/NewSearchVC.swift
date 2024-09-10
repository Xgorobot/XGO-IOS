//
//  NewSearchVC.swift
//  xgo
//
//  Created by Arther on 20.6.24.
//

import UIKit
import CoreBluetooth


class NewSearchVC: UIViewController,CBCentralManagerDelegate,UITextFieldDelegate{
    
    typealias SaveCallback = (_ connectResult:String)->Void //声明一个回调
    var scanCallback:SaveCallback? //回调作为参数
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
    
    @IBOutlet weak var renameButton: UIButton!
    @IBOutlet weak var disconnectButton: GradientButton!
    var searchView: NewSearchListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView = NewSearchListView()
        self.view.addSubview(searchView)
        
        
        searchView.objectChangedClosure = { object in
            print("从子控制器传递的对象：\(object)")
            self.searchView.isHidden = true
            self.myCentralManager.stopScan()
            self.flagScan = false
            
            self.myPeripheralToMainView = object.value(forKey:"peripheral") as? CBPeripheral
            self.connectPeripheral(peripheral: self.myPeripheralToMainView)
            
            
        }
        
        searchView.isHidden = true
        
        searchView.hiddenAction = { [weak self] in
            self?.searchView.isHidden = !(self?.searchView.isHidden ?? false)
        }
        
        searchView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        disconnectButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x2205FF), UIColor(hex: 0x12C4FF)]), for: .normal)
        disconnectButton.cornerRadius = 3
        
        
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
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (BLEMANAGER?.isConnect()) == true {
            self.disconnectButton.isHidden = false
            self.renameButton.isHidden = false
//            self.searchView.isHidden = true
        }else {
            self.disconnectButton.isHidden = true
            self.renameButton.isHidden = true
//            self.searchView.isHidden = false
        }
   
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSLog("停止搜索")
        self.myCentralManager.stopScan()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func search(_ sender: Any) {
        
        searchView.isHidden = !searchView.isHidden
        
    }
    
    @IBAction func disconnect(_ sender: Any) {
        
        print("断开连接")
        if BLEMANAGER != nil {
            BLEMANAGER?.close()
        }
        CBToast.showToast(message: NSLocalizedString("disconnect", comment: "断开连接") as NSString, aLocationStr: "bottom", aShowTime: 2)
        self.navigationController?.popViewController(animated: true)
      
    }
    
    @IBAction func renameAction(_ sender: Any) {
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
            
            
            }
        }
        
        let cancel = UIAlertAction.init(title: NSLocalizedString("取消", comment: "取消"), style:.cancel) { (action:UIAlertAction) -> ()in
            print("取消输入")
        }
        msgAlertCtr.addAction(ok)
        msgAlertCtr.addAction(cancel)
        //设置到当前视图
        self.present(msgAlertCtr, animated: true, completion: nil)
    }
    
    
    // MARK: - 蓝牙响应函数
    //检查外设管理器状态
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case CBManagerState.poweredOn:  //蓝牙已打开正常
            NSLog("启动成功，开始搜索")
            self.myCentralManager.scanForPeripherals(withServices: nil, options: nil)
//            scanErrorAlert.isHidden = false
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
                    searchView.myPeripherals = myPeripherals;
                    // MARK -- mengwei 刷新设备列表
                    searchView.tableView.reloadData()

                }
            }else{
                //重复搜索
                for (index,value) in myPeripherals.enumerated() {
                    if let dic:NSMutableDictionary = value as? NSMutableDictionary{
                        if let name:String = advertisementData["kCBAdvDataLocalName"] as? String {
                            dic.setValue(name, forKey: "name")
                            NSLog("更新设备名\(name)")
                            
                            searchView.myPeripherals = myPeripherals;
                            // MARK -- mengwei 刷新设备列表
                            searchView.tableView.reloadData()
                            
                        }
                    }
                }
            }
        }
        
        searchView.myPeripherals = myPeripherals
    }
    
    //链接成功，相应函数
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("已连接\(peripheral.name!)")
        self.myPeripheralToMainView! = peripheral
        CBToast.showToast(message: NSLocalizedString("connect success", comment: "connect success") as NSString, aLocationStr: "bottom", aShowTime: 2)
        self.alertConnect.dismiss(animated: false) {
            self.dismiss(animated: true, completion: nil)
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
    
    // MARK -- mengwei 设备列表点击
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
    
}
