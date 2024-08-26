//
//  NewTestVC.swift
//  xgo
//
//  Created by Arther on 19.7.24.
//

import UIKit


class NewTestVC: UIViewController {
    
    @IBOutlet weak var biaodingButton: GradientButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        biaodingButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x2205FF), UIColor(hex: 0x12C4FF)]), for: .normal)
        biaodingButton.cornerRadius = 3
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startAction(_ sender: Any) {
        FindControlUtil.setModeStart()
        CBToast.showToast(message: NSLocalizedString("标定模式", comment: "标定模式") as NSString, aLocationStr: "bottom", aShowTime: 2)
        
    }
    
    @IBAction func finishAction(_ sender: Any) {
        
        FindControlUtil.setModeClose()
        CBToast.showToast(message: NSLocalizedString("标定模式结束", comment: "标定模式结束") as NSString, aLocationStr: "bottom", aShowTime: 2)
    }
    
}
