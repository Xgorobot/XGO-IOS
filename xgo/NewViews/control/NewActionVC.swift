//
//  NewActionVC.swift
//  xgo
//
//  Created by Arther on 18.7.24.
//

import UIKit


class NewActionVC: UIViewController {
    
    @IBOutlet weak var resetButton: GradientButton!
    @IBOutlet weak var redValue: UILabel!
    @IBOutlet weak var greenValue: UILabel!
    @IBOutlet weak var blueValue: UILabel!
    @IBOutlet weak var leftActionView: ActionBarsView!
    @IBOutlet weak var leftRockerView: RockerBarsView!
    @IBOutlet weak var GradientSlider: GradientSlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x0C00F8), UIColor(hex: 0x00EAFF)]), for: .normal)
        
        leftRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
        }
        
        leftActionView.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
        }
        
        GradientSlider.minimumValue = 0
        GradientSlider.maximumValue = 20
        GradientSlider.thumbSize = 50
        GradientSlider.setValue((GradientSlider.maximumValue - GradientSlider.minimumValue) * 0.5)
        
        GradientSlider.addTarget(self, action: #selector(rollChangeEnd), for: .touchUpInside)
        GradientSlider.addTarget(self, action: #selector(rollChangeEnd), for: .touchUpOutside)
        
    }
    
    @IBAction func resetAction(_ sender: Any) {
        
    }
    
    @IBAction func redChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        redValue.text = Int(sender.value).description
        // todo yuanwenlin 不太确定怎么传
//        FindControlUtil.setLED(red: <#T##UInt8#>, green: <#T##UInt8#>, blue: <#T##UInt8#>)
    }
    
    @IBAction func greenChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        greenValue.text = Int(sender.value).description
    }
    
    @IBAction func blueChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        blueValue.text = Int(sender.value).description
    }
    
    // roll 那个slider
    @IBAction func rollChange(_ sender: GradientSlider) {
        print(sender.value)
        // todo yuanwenlin 不太确定调用函数
    }
    
    
    @objc func rollChangeEnd(_ sender: GradientSlider) {
        GradientSlider.setValue((GradientSlider.maximumValue - GradientSlider.minimumValue) * 0.5)
    }
    
    // 亮度设置
    @IBAction func brightnessChange(_ sender: Any) {
        
        // todo yuanwenlin 不太确定调用函数
        
        

    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionPlay(_ sender: Any) {
        
    }
    
    @IBAction func actionOne(_ sender: Any) {
        
        // todo yuanwenlin  下面几个不太确定是否正确
        
        FindControlUtil.actionType(type: 0x01)
    }
    
    @IBAction func actionTwo(_ sender: Any) {
        FindControlUtil.actionType(type: 0x03)
    }
    
    @IBAction func actionThree(_ sender: Any) {
        FindControlUtil.actionType(type: 0x02)
    }
    
    @IBAction func actionFour(_ sender: Any) {
        FindControlUtil.actionType(type: 0x04)
    }
    
    @IBAction func actionFive(_ sender: Any) {
        FindControlUtil.actionType(type: 0x05)
    }
    
    @IBAction func actionSix(_ sender: Any) {
        
        FindControlUtil.actionType(type: 0x06)
    }
    
}
