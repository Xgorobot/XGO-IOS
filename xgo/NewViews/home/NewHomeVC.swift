//
//  NewHomeVC.swift
//  xgo
//
//  Created by Arther on 18.6.24.
//

import UIKit
import CoreBluetooth

class NewHomeVC: UIViewController {
    
    @IBOutlet weak var bluetoothImage: UIButton!
    @IBOutlet weak var bluetoothInfoView: UIView!
    @IBOutlet weak var bluetoothInfoLabel: UILabel!
    @IBOutlet weak var controlButton: UIButton!
    var homeSetView: HomeSetView!
    var homeUpSetView: HomeUpSetView!
    @IBOutlet weak var textContainerWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        bluetooth()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    @objc func appMovedToForeground() {
              
        startPulsingAnimation()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func initView() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        bluetoothInfoView.layer.cornerRadius = 35/2
        bluetoothInfoView.layer.borderWidth = 2
        bluetoothInfoView.layer.borderColor = UIColor(hex: 0x09B1FF).cgColor
        bluetoothInfoView.layer.masksToBounds = true
        
        homeSetView = Bundle.main.loadNibNamed("HomeSetView", owner: nil)?.first as? HomeSetView
        self.view.addSubview(homeSetView)
        
        homeSetView.layer.cornerRadius = 5
        homeSetView.layer.masksToBounds = true
        
        homeSetView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).inset(20)
            make.left.equalTo(bluetoothInfoView)
            make.size.equalTo(CGSize(width: 161, height: 98))
        }
        
        // 关于方法调用
        homeSetView.about = {[weak self] in
            self?.navigationController?.pushViewController(NewAboutVC(), animated: true)
        }
        
        homeSetView.set = {[weak self] in
            self?.navigationController?.pushViewController(NewSetVC(), animated: true)
        }
        
        
        homeUpSetView = Bundle.main.loadNibNamed("HomeUpSetView", owner: nil)?.first as? HomeUpSetView
        self.view.addSubview(homeUpSetView)
        
        homeUpSetView.layer.cornerRadius = 5
        homeUpSetView.layer.masksToBounds = true
        homeUpSetView.isHidden = true
        
        homeUpSetView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).inset(20)
            make.left.equalTo(bluetoothInfoView)
            make.size.equalTo(CGSize(width: 161, height: 204))
        }
        
        // 修改页面后 按钮调用方法
        // 关于
        homeUpSetView.about = {[weak self] in
            self?.navigationController?.pushViewController(NewAboutVC(), animated: true)
        }
        // 标定
        homeUpSetView.biaoding = {[weak self] in
            self?.navigationController?.pushViewController(NewTestVC(), animated: true)
        }
        // 固件
        homeUpSetView.gujian = {[weak self] in
            self?.navigationController?.pushViewController(NewUpgradeVC(), animated: true)
        }
        // 设置
        homeUpSetView.shezhi = {[weak self] in
            self?.navigationController?.pushViewController(NewSetVC(), animated: true)
        }
        
        controlButton.isHidden = true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (BLEMANAGER?.isConnect()) == true {
            bluetoothInfoLabel.text = BLEMANAGER?.PeripheralToConncet.name

            bluetoothImage.setImage(UIImage(named: "w-lanya-sel"), for: .normal)
        }else {
            bluetoothInfoLabel.text = "请连接蓝牙"
            bluetoothImage.setImage(UIImage(named: "w-lanya"), for: .normal)

        }
        textContainerWidth.constant = bluetoothInfoLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width + 30
        
        bluetooth()
        // 按钮动画方法
        startPulsingAnimation()
    }
    
    func startPulsingAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1 // 动画持续时间
        pulseAnimation.fromValue = 1.0 // 起始的缩放比例
        pulseAnimation.toValue = 1.2   // 结束的缩放比例
        pulseAnimation.autoreverses = true // 动画结束后自动反转
        pulseAnimation.repeatCount = .greatestFiniteMagnitude // 无限循环
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // 将动画添加到按钮的图层
        controlButton.layer.add(pulseAnimation, forKey: "pulse")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        FindControlUtil.readVersionName { data in
            //这个data是一个String 如果代码无效的话 打印看看data是什么
            if (data.count >= 10){
                if let string = String(bytes: data.dropFirst(2), encoding: .utf8) {
                    switch string.prefix(1) {
                    case "M":
                        BLEMANAGER?.deviceType = 0
                    case "L":
                        BLEMANAGER?.deviceType = 1
                    case "R":
                        BLEMANAGER?.deviceType = 2
                        //TODO @mengwei 修改此处，跳转到双足机器人页面
                    default:
                        BLEMANAGER?.deviceType = -1
                    }
                } else {
                    print("无法将字节数组转换为字符串")
                }
            }
        }
    }
    
    
    // 跳转控制页面
    @IBAction func controlAction(_ sender: Any) {
        
        if ((BLEMANAGER?.isConnect()) == true){
            switch BLEMANAGER?.deviceType{
            case 0:
                self.navigationController?.pushViewController(NewControlVC(), animated: true)
            case 1:
                self.navigationController?.pushViewController(NewControlVC(), animated: true)
            case 2:
                self.navigationController?.pushViewController(NewActionVC(), animated: true)
            case -1:
                FindControlUtil.readVersionName { data in
                    //这个data是一个String 如果代码无效的话 打印看看data是什么
                    if (data.count >= 10){
                        if let string = String(bytes: data.dropFirst(2), encoding: .utf8) {
                            switch string.prefix(1) {
                            case "M":
                                BLEMANAGER?.deviceType = 0
                                self.navigationController?.pushViewController(NewControlVC(), animated: true)
                            case "L":
                                BLEMANAGER?.deviceType = 1
                                self.navigationController?.pushViewController(NewControlVC(), animated: true)
                            case "R":
                                BLEMANAGER?.deviceType = 2
                                self.navigationController?.pushViewController(NewActionVC(), animated: true)
                            default:
                                BLEMANAGER?.deviceType = -1
                            }
                        } else {
                            print("无法将字节数组转换为字符串")
                        }
                    }
                }
            default:
                break
            }
        } else {
            
            CBToast.showToast(message: NSLocalizedString("请先连接蓝牙", comment: "请先连接蓝牙") as NSString, aLocationStr: "bottom", aShowTime: 2)
            
            
//                self.navigationController?.pushViewController(NewActionVC(), animated: true)
            

        }
    }
    
    // 跳转蓝牙页面
    @IBAction func bluetoothAction(_ sender: Any) {
        
        self.navigationController?.pushViewController(NewSearchVC(), animated: true)
        
    }
    
    // 蓝牙连接页面布局切换
    func bluetooth() {
        
        
        if (UserDefaults.standard.bool(forKey: "developMode")) {
            controlButton.isHidden = false
            homeUpSetView.isHidden = false
            homeSetView.isHidden = true
        }else {
            homeUpSetView.isHidden = true
            controlButton.isHidden = true
            homeSetView.isHidden = false
        }
        
        if ((BLEMANAGER?.isConnect()) == true) {
            
            controlButton.isHidden = false
//            homeUpSetView.isHidden = false
//            homeSetView.isHidden = true
            
           
            
        } else {
           
//            homeSetView.isHidden = false
//            homeUpSetView.isHidden = true
            controlButton.isHidden = true
            
        }
        
        
    }
    
    
}

extension MTCircularSlider {
    
//    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//            let hitView = super.hitTest(point, with: event)
//            return hitView == self ? nil : hitView
//        }
    
}


class textView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
    
}
