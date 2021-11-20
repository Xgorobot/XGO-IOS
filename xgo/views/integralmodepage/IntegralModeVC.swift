//
//  IntegralModeVC.swift
//  xgo
//
//  Created by 袁文麟 on 2021/7/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import CoreMotion

class IntegralModeVC: UIViewController,UITabBarDelegate {
    
    let _bag: DisposeBag = DisposeBag()
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    @IBOutlet weak var lowSpeed: UIButton!
    @IBOutlet weak var mediumSpeed: UIButton!
    @IBOutlet weak var highSpeed: UIButton!
    
    var _vm: IntegralModeVM!
    
    let _normalVC = NormalVC()
    let _seniorVC = RockerVC()
    let _xyzVC = RockerVC()
    let _pryVC = RockerVC()
    
    @IBOutlet weak var _childView: UIView!
    
    @IBOutlet weak var settBgView: UIView!
    //陀螺仪
    let motionManager = CMMotionManager()
    let timeInterval: TimeInterval = 0.2
    
    var showSettingView = true

    //设置选项
    @IBOutlet weak var settingView: UIView!
     override func viewDidLoad() {
        super.viewDidLoad()
        add(_normalVC, frame: _childView.frame)
        _normalVC.didMove(toParent: self)
        btn0.setBackgroundImage(#imageLiteral(resourceName: "yaokongTitleBg"), for: .selected)
        btn0.isSelected = true
        btn1.setBackgroundImage(#imageLiteral(resourceName: "yaokongTitleBg"), for: .selected)
        btn2.setBackgroundImage(#imageLiteral(resourceName: "yaokongTitleBg"), for: .selected)
        btn3.setBackgroundImage(#imageLiteral(resourceName: "yaokongTitleBg"), for: .selected)
        self.view.bringSubviewToFront(settBgView)
        self.view.bringSubviewToFront(settingView)
        
        
        lowSpeed.layer.borderColor = blueColor.cgColor
        mediumSpeed.layer.borderColor = blueColor.cgColor
        highSpeed.layer.borderColor = blueColor.cgColor
        lowSpeed.layer.borderWidth = 1.0;
        mediumSpeed.layer.borderWidth = 1.0;
        highSpeed.layer.borderWidth = 1.0;
        lowSpeed.backgroundColor = UIColor.black;
        mediumSpeed.backgroundColor = blueColor;
        highSpeed.backgroundColor = UIColor.black;
        
        self.settBgView.isHidden = true
        self.settingView.isHidden = true
        let tapBackground = UITapGestureRecognizer()
        settBgView.addGestureRecognizer(tapBackground)
        tapBackground.rx.event.subscribe(onNext: { [weak self] _ in
            self!.showSettingView = !self!.showSettingView
            self!.settBgView.isHidden = self!.showSettingView
            self!.settingView.isHidden = self!.showSettingView

        }).disposed(by: _bag)
    }
    
    @IBAction func onClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onItemSelect(_ sender: UIButton) {
        removeAll()
        sender.isSelected = true
        switch sender.tag {
        case 0:
            add(_normalVC, frame: _childView.frame)
            _normalVC.didMove(toParent: self)
            break
        case 1:
            add(_seniorVC, frame: _childView.frame)
            _seniorVC.initCtrl()
            _seniorVC.didMove(toParent: self)
            break
        case 2:
            add(_xyzVC, frame: _childView.frame)
            _xyzVC.initXYZ()
            _xyzVC.didMove(toParent: self)
            break
        case 3:
            add(_pryVC, frame: _childView.frame)
            _pryVC.initRPY()
            _pryVC.didMove(toParent: self)
            break
        default:
            break
        }
        self.view.bringSubviewToFront(settBgView)
        self.view.bringSubviewToFront(settingView)
    }
    
    
    func removeAll() -> Void {
        _normalVC.remove()
        _seniorVC.remove()
        _xyzVC.remove()
        _pryVC.remove()
        btn0.isSelected = false
        btn1.isSelected = false
        btn2.isSelected = false
        btn3.isSelected = false
    }
    
    // 开始获取陀螺仪数据
        func startGyroUpdates() {
            //判断设备支持情况
            guard motionManager.isGyroAvailable else {
//                self.textView.text = "\n当前设备不支持陀螺仪\n"
                return
            }
             
            //设置刷新时间间隔
            self.motionManager.gyroUpdateInterval = self.timeInterval
             
            //开始实时获取数据
            let queue = OperationQueue.current
            self.motionManager.startGyroUpdates(to: queue!, withHandler: { (gyroData, error) in
                guard error == nil else {
                    print(error!)
                    return
                }
                // 有更新
                if self.motionManager.isGyroActive {
                    if let rotationRate = gyroData?.rotationRate {
                        var text = "---当前陀螺仪数据---\n"
                        text += "x: \(rotationRate.x)\n"
                        text += "y: \(rotationRate.y)\n"
                        text += "z: \(rotationRate.z)\n"
//                        self.textView.text = text
                        print(text)
                    }
                }
            })
        }
    
    func stopGyroUpdates() {
        self.motionManager.stopGyroUpdates()
    }
    let blueColor = UIColor.init(red: 110/255, green: 230/255, blue: 228/255, alpha: 1)
    
    @IBAction func onSpeedSelect(_ sender: UIButton) {
        print(sender.tag)
        switch sender.tag {
        case 0:
            lowSpeed.backgroundColor = blueColor;
            mediumSpeed.backgroundColor = UIColor.black;
            highSpeed.backgroundColor = UIColor.black;

        case 1:
            lowSpeed.backgroundColor = UIColor.black;
            mediumSpeed.backgroundColor = blueColor;
            highSpeed.backgroundColor = UIColor.black;
            
        case 2:
            lowSpeed.backgroundColor = UIColor.black;
            mediumSpeed.backgroundColor = UIColor.black;
            highSpeed.backgroundColor = blueColor;
            
            
        default:
            print("other select")
        }
    }
    
    @IBAction func onSettingClick(_ sender: Any) {
        showSettingView = !showSettingView
        self.view.bringSubviewToFront(settBgView)
        self.view.bringSubviewToFront(settingView)
        settBgView.isHidden = showSettingView
        settingView.isHidden = showSettingView
    }
    

}
