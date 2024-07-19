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
    }
    
    @IBAction func walkSliderChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        walkLabel.text = Int(sender.value).description
    }
    
    @IBAction func heightReset(_ sender: Any) {
    }
    
    @IBAction func walkReset(_ sender: Any) {
    }
    
    @IBAction func setButton(_ sender: Any) {
        self.isHidden = true
    }
    
}
