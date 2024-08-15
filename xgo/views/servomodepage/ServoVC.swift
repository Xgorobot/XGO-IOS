//
//  ServoVC.swift
//  xgo
//
//  Created by 袁文麟 on 2021/7/21.
//

import UIKit
import SnapKit

class ServoVC: UIViewController,UITabBarDelegate {

    @IBOutlet weak var XLabel: UILabel!
    @IBOutlet weak var XLabel2: UILabel!
    @IBOutlet weak var YLabel: UILabel!
    @IBOutlet weak var YLabel2: UILabel!
    @IBOutlet weak var ZLabel: UILabel!
    @IBOutlet weak var ZLabel2: UILabel!
    
    @IBOutlet weak var XSlider: UISlider!
    @IBOutlet weak var YSlider: UISlider!
    @IBOutlet weak var ZSlider: UISlider!
    
    @IBOutlet weak var positionTabbar: UITabBar!
    
    var selectPosition:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        XSlider.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        YSlider.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        ZSlider.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        positionTabbar.selectedItem = positionTabbar.items![0];
        positionTabbar.delegate = self
        
    }

    //这个应该是舵机对应的指令方法
    @IBAction func onXValueChanged(_ sender: UISlider, forEvent event: UIEvent) {//[-31°,+31°]
        let showValue = Int(sender.value.rounded())
        let value = Int(((sender.value+31)/62*255).rounded())
        XLabel2.text = "\(showValue)  °"
        XLabel.text = "X:\(showValue) °"
        FindControlUtil.setServo(servo: selectPosition.hw_toByte(), xyz: "x", speed: value.hw_toByte())
        
    }
    @IBAction func onYValueChanged(_ sender: UISlider) {//[-66°, +93°]
        let showValue = Int(sender.value.rounded())
        let value = Int(((sender.value+66)/159*255).rounded())
        YLabel2.text = "\(showValue)  °"
        YLabel.text = "Y:\(showValue) °"
        FindControlUtil.setServo(servo: selectPosition.hw_toByte(), xyz: "y", speed: value.hw_toByte())
    }
    
    @IBAction func onZValueChanged(_ sender: UISlider) {//[-65°,+73°]
        let showValue = Int(sender.value.rounded())
        let value = Int(((sender.value+65)/138*255).rounded())
        ZLabel2.text = "\(showValue)  °"
        ZLabel.text = "Z:\(showValue) °"
        FindControlUtil.setServo(servo: selectPosition.hw_toByte(), xyz: "z", speed: value.hw_toByte())
    }
    
    @IBAction func onBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onResetClick(_ sender: Any) {
        XSlider.value = 0
        YSlider.value = 43
        ZSlider.value = 20
        XLabel2.text = "0 °"
        XLabel.text = "X:0 °"
        YLabel2.text = "43 °"
        YLabel.text = "43 °"
        ZLabel2.text = "20 °"
        ZLabel.text = "Z:20 °"
        FindControlUtil.actionType(type: 0xFF)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.selectPosition = item.tag
    }

}
