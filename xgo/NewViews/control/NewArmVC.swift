//
//  NewArmVC.swift
//  xgo
//
//  Created by Arther on 28.6.24.
//

import UIKit


class NewArmVC: UIViewController {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var armButton: GradientButton!
    @IBOutlet weak var armRockerView: RockerBarsView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 100
        
        armButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x0040F8), UIColor(hex: 0x00EAFF)], endPoint: .init(x: 0, y: 1)), for: .normal)
        armButton.cornerRadius = 3
        
        segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        
        armRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
        }
        
    }
    
    
    @IBAction func referAction(_ sender: Any) {
    }
    
    @IBAction func controlAction(_ sender: Any) {
        self.view.isHidden = true
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(), animated: true)
        progressLabel.text = Int(sender.value).description
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
