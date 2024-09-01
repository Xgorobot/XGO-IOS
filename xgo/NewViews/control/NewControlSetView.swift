//
//  NewControlSetView.swift
//  xgo
//
//  Created by Arther on 3.7.24.
//

import UIKit

class NewControlSetView: UIView {
    
    @IBOutlet weak var gyroSwitch: UISwitch!
    @IBOutlet weak var walkLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var speedSegmented: UISegmentedControl!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var walkSlider: UISlider!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func heightSliderChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        heightLabel.text = Int(sender.value).description
        
        let value = Int((sender.value*255).rounded())
        FindControlUtil.heightSet(height: value.hw_toByte())
        
    }
    
    @IBAction func walkSliderChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        walkLabel.text = Int(sender.value).description
    }
    
    @IBAction func heightReset(_ sender: Any) {
        
        
       
        
        FindControlUtil.heightSet(height:0x80)
        
    }
    
    @IBAction func walkReset(_ sender: Any) {
        
        // todo yuanwenlin 不太确定是调用哪个函数 
        
    }
    
    @IBAction func setButton(_ sender: Any) {
        self.isHidden = true
    }
    
    @IBAction func gyroAction(_ sender: Any) {
        
        if gyroSwitch.isOn {
            FindControlUtil.enableIMU(enable: true)
        }else{
            FindControlUtil.enableIMU(enable: false)
        }
    }
    
    @IBAction func speedAction(_ sender: UISegmentedControl) {

        if speedSegmented.selectedSegmentIndex == 0 {
            FindControlUtil.servoSpeedSet(speed: 0x01)
            FindControlUtil.heightSet(height:0x40)
            
//            _normalVC.slider?.value = 0.25
//            _seniorVC.slider?.value = 0.25
//            _xyzVC.slider?.value = 0.25
//            _pryVC.slider?.value = 0.25


        }else if speedSegmented.selectedSegmentIndex == 1 {
            
            // todo yuanwenlin 不太确定是调用哪个函数 
            FindControlUtil.servoSpeedSet(speed: 0x00)
            
            FindControlUtil.setSpeed(type: 0x01)

            
            
            FindControlUtil.heightSet(height:0x80)
//            
//            _normalVC.slider?.value = 0.5
//            _seniorVC.slider?.value = 0.5
//            _xyzVC.slider?.value = 0.5
//            _pryVC.slider?.value = 0.5


        }else {
            FindControlUtil.servoSpeedSet(speed: 0x02)
            FindControlUtil.heightSet(height:0xB0)
            
//            _normalVC.slider?.value = 0.75
//            _seniorVC.slider?.value = 0.75
//            _xyzVC.slider?.value = 0.75
//            _pryVC.slider?.value = 0.75


        }
        
        
    }
    
    
}
