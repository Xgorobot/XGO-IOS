//
//  NewActionVC.swift
//  xgo
//
//  Created by Arther on 18.7.24.
//

import UIKit
import TactileSlider


class NewActionVC: UIViewController {
    
    @IBOutlet weak var resetButton: GradientButton!
    @IBOutlet weak var redValue: UILabel!
    @IBOutlet weak var greenValue: UILabel!
    @IBOutlet weak var blueValue: UILabel!
    @IBOutlet weak var leftActionView: ActionBarsView!
    @IBOutlet weak var leftRockerView: RockerBarsView!
    @IBOutlet weak var GradientSlider: GradientSlider!
    @IBOutlet weak var rSlider: UISlider!
    @IBOutlet weak var gSlider: UISlider!
    @IBOutlet weak var bSlider: UISlider!
    
    @IBOutlet weak var lunboButton: GradientButton!
    @IBOutlet weak var balanceBtn: GradientButton!
    
    @IBOutlet weak var actionContainer: UIView!
    @IBOutlet weak var sliderContainer: UIView!
    @IBOutlet weak var lightContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x0C00F8), UIColor(hex: 0x00EAFF)]), for: .highlighted)
        lunboButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x0802FF), UIColor(hex: 0xC600FF)], startPoint: CGPoint(x: 1, y: 1), endPoint: CGPoint(x: 1, y: 0)), for: .selected)
        lunboButton.cornerRadius = 2
        lunboButton.layer.masksToBounds = true
        
        
        balanceBtn.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x0802FF), UIColor(hex: 0xC600FF)], startPoint: CGPoint(x: 1, y: 1), endPoint: CGPoint(x: 1, y: 0)), for: .selected)
        balanceBtn.cornerRadius = 2
        balanceBtn.layer.masksToBounds = true
        
        actionContainer.layer.shadowColor = UIColor.black.cgColor
        actionContainer.layer.shadowOffset = CGSize(width: 1, height: 1)
        actionContainer.layer.shadowOpacity = 0.28
        actionContainer.layer.shadowRadius = 5
        actionContainer.layer.cornerRadius = 10.5
        
        sliderContainer.backgroundColor = UIColor(hex: 0x3130B8)
        sliderContainer.layer.shadowColor = UIColor(hex: 0x03B3FD).cgColor
        sliderContainer.layer.shadowOffset = CGSize(width: 1, height: 1)
        sliderContainer.layer.shadowOpacity = 0.28
        sliderContainer.layer.shadowRadius = 5
        sliderContainer.layer.cornerRadius = 5
        
        lightContainer.backgroundColor = UIColor(hex: 0x3130B8)
        lightContainer.layer.shadowColor = UIColor(hex: 0x03B3FD).cgColor
        lightContainer.layer.shadowOffset = CGSize(width: 1, height: 1)
        lightContainer.layer.shadowOpacity = 0.28
        lightContainer.layer.shadowRadius = 5
        lightContainer.layer.cornerRadius = 5
        
        
        rSlider.setThumbImage(UIImage(named: ""), for: .normal)
        
        leftRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
            
            switch dir {
                case .OLeft:
                    FindControlUtil.turnClockwise(speed:0xDA )
                    break
                case .ORight:
                    FindControlUtil.turnClockwise(speed:0x25 )
                    break
                case .OUp:
                    FindControlUtil.moveX(speed: 0xDA)
                   break
                case .ODown:
                     FindControlUtil.moveX(speed: 0x25)
                    break
                case .OStop:
                    FindControlUtil.turnClockwise(speed: 0x80)
                    break
                default:
                    break
            }
        }
        
        leftActionView.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
            
            print("顺时针旋转2dir:\(dir)")
            switch dir {
                case .OLeft:
                    FindControlUtil.turnClockwise(speed:0xDA )
                    break
                case .ORight:
                    FindControlUtil.turnClockwise(speed:0x25 )
                    break
                case .OUp:
                    FindControlUtil.moveX(speed: 0xDA)
                   break
                case .ODown:
                     FindControlUtil.moveX(speed: 0x25)
                    break
                case .OStop:
                    FindControlUtil.stopX()
                    FindControlUtil.turnClockwise(speed: 0x80)
                    break
                default:
                    break
            }
            
        }
        
        GradientSlider.minimumValue = 0
        GradientSlider.maximumValue = 20
        GradientSlider.thumbSize = 50
        GradientSlider.setValue((GradientSlider.maximumValue - GradientSlider.minimumValue) * 0.5)
        
        GradientSlider.addTarget(self, action: #selector(rollChangeEnd), for: .touchUpInside)
        GradientSlider.addTarget(self, action: #selector(rollChangeEnd), for: .touchUpOutside)
        
    }
    
    @IBOutlet weak var hightSlider: TactileSlider!
    
    @IBAction func resetAction(_ sender: Any) {
        hightSlider.setValue(50, animated: false)
       
        
        BLEMANAGER?.checkRepeat {
            FindControlUtil.heightSet(height:0x80)
        }
        
    }
    
    @IBAction func redChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        redValue.text = Int(sender.value).description
        BLEMANAGER?.checkRepeat {
            FindControlUtil.setLED(red: UInt8(rSlider.value), green: UInt8(gSlider.value), blue: UInt8(bSlider.value))
        }
    }
    
    @IBAction func greenChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        greenValue.text = Int(sender.value).description
        BLEMANAGER?.checkRepeat {
            FindControlUtil.setLED(red: UInt8(rSlider.value), green: UInt8(gSlider.value), blue: UInt8(bSlider.value))
        }
    }
    
    @IBAction func blueChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        blueValue.text = Int(sender.value).description
        BLEMANAGER?.checkRepeat {
            FindControlUtil.setLED(red: UInt8(rSlider.value), green: UInt8(gSlider.value), blue: UInt8(bSlider.value))
        }
        
//        FindControlUtil.setLED(red: UInt8(rSlider.value), green: UInt8(gSlider.value), blue: UInt8(bSlider.value))
    }
    
    // roll 那个slider
    @IBAction func rollChange(_ sender: GradientSlider) {
        
        print("rollChange \(sender.value)")
        BLEMANAGER?.checkRepeat {
            let clampedValue = max(0, min(20, sender.value))
            let mappedValue = (clampedValue / 20.0) * 160.0 + 47.5
            FindControlUtil.trunByX(angle: UInt8(mappedValue))
        }
    }
    
    
    @objc func rollChangeEnd(_ sender: GradientSlider) {
        print("rollChangeEnd \(sender.value)")

        GradientSlider.setValue((GradientSlider.maximumValue - GradientSlider.minimumValue) * 0.5)
        FindControlUtil.trunByX(angle: 0x80)
       
    }
    
    @IBAction func heightSet(_ sender: TactileSlider) {
        BLEMANAGER?.checkRepeat {
            let clampedValue = max(0, min(100, sender.value))
            let mappedValue = (clampedValue / 100) * 255.0
            FindControlUtil.heightSet(height: UInt8(mappedValue))
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionPlay(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print("sender.isSelected\(sender.isSelected)")
        FindControlUtil.showMode(needRepeat: sender.isSelected)
    }
    
    @IBAction func actionOne(_ sender: Any) {
        FindControlUtil.actionType(type: 0x01)
    }
    
    @IBAction func actionTwo(_ sender: Any) {
        FindControlUtil.actionType(type: 0x03)
    }
    @IBAction func balanceSet(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        FindControlUtil.enableIMU(enable: sender.isSelected)
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
