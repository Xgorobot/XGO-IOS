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
        
        GradientSlider.thumbSize = 50
        GradientSlider.setValue(50)
        
        GradientSlider.addTarget(self, action: #selector(rollChangeEnd), for: .touchUpInside)
        GradientSlider.addTarget(self, action: #selector(rollChangeEnd), for: .touchUpOutside)
        
    }
    
    @IBAction func resetAction(_ sender: Any) {
        
    }
    
    @IBAction func redChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        redValue.text = Int(sender.value).description
    }
    
    @IBAction func greenChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        greenValue.text = Int(sender.value).description
    }
    
    @IBAction func blueChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        blueValue.text = Int(sender.value).description
    }
    
    @IBAction func rollChange(_ sender: GradientSlider) {
        print(sender.value)
    }
    
    
    @objc func rollChangeEnd(_ sender: GradientSlider) {
        GradientSlider.setValue(50)
    }
    
    // 亮度设置
    @IBAction func brightnessChange(_ sender: Any) {
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionPlay(_ sender: Any) {}
    
    @IBAction func actionOne(_ sender: Any) {}
    
    @IBAction func actionTwo(_ sender: Any) {}
    
    @IBAction func actionThree(_ sender: Any) {}
    
    @IBAction func actionFour(_ sender: Any) {}
    
    @IBAction func actionFive(_ sender: Any) {}
    
    
}
