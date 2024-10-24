//
//  NewArmVC.swift
//  xgo
//
//  Created by Arther on 28.6.24.
//

import UIKit


class NewArmVC: NewsBaseViewController {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var armButton: GradientButton!
    @IBOutlet weak var armRockerView: ArmRockerView!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var actionTitleLable: UIButton!
    @IBOutlet weak var gripperLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        armButton.setTitle("机械臂控制".localized, for: .normal)
        actionTitleLable.setTitle("动作控制".localized, for: .normal)
        segmented.setTitle("参照地面".localized, forSegmentAt: 0)
        segmented.setTitle("参照底座".localized, forSegmentAt: 1)
        gripperLabel.text = "夹爪".localized
        
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 100
        
        armButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x0040F8), UIColor(hex: 0x00EAFF)], endPoint: .init(x: 0, y: 1)), for: .normal)
        armButton.cornerRadius = 3
        
        segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        
        armRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("机械臂控制摇杆：\(dir)  x:\(x) y:\(y) r:\(r)")
            var xValue = (1-x)/2*255
            var yValue = (1+x)/2*255
            FindControlUtil.setArmX(target: UInt8(xValue))
            FindControlUtil.setArmZ(target: UInt8(yValue))
        }
    }
    
    @IBAction func actionUp() {
        FindControlUtil.actionType(type: 0x80)
    }
    
    @IBAction func actionMiddle() {
        FindControlUtil.actionType(type: 0x81)
    }
    
    @IBAction func actionDown() {
        FindControlUtil.actionType(type: 0x82)
        
    }
    
    
    // 切换
    @IBAction func referAction(_ sender: Any) {
        //机械臂控制 参照地面0x01 参照底座0x00
        if self.segmented.selectedSegmentIndex == 0 {
            FindControlUtil.setArmRef(target: 0x01)
        }else {
            FindControlUtil.setArmRef(target: 0x00)
        }
    }
    
    @IBAction func controlAction(_ sender: Any) {
        self.view.isHidden = true
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        progressLabel.text = Int(sender.value).description
        

        
        BLEMANAGER?.checkRepeat {
            let value = Int((sender.value * 255 / 100).rounded())
               // 夹爪
            FindControlUtil.setArmJaw(target: UInt8(value))
        }
        
        

        
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
