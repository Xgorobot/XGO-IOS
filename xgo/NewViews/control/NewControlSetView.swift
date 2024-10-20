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
        
        BLEMANAGER?.checkRepeat {
            let value = Int((sender.value*255).rounded())
            FindControlUtil.heightSet(height: value.hw_toByte())
        }
    }
    
    @IBAction func walkSliderChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        walkLabel.text = Int(sender.value).description
        BLEMANAGER?.stepSpeed = Int(sender.value.rounded())
        print("step set :\(Int(sender.value.rounded()))")
    }
    
    @IBAction func heightReset(_ sender: Any) {
        heightLabel.text = "60"
        heightSlider.value = 60
        FindControlUtil.actionType(type: 0x02)
        FindControlUtil.heightSet(height:0x80)
    }
    
    @IBAction func walkReset(_ sender: Any) {
        walkSlider.value = 60
        walkLabel.text = "70"
        BLEMANAGER?.stepSpeed = Int(walkSlider.value.rounded())
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
            FindControlUtil.setSpeed(type: 0x01)
        }else if speedSegmented.selectedSegmentIndex == 1 {
            FindControlUtil.setSpeed(type: 0x00)
        }else {
            FindControlUtil.setSpeed(type: 0x02)
        }
    }
    
    
}
