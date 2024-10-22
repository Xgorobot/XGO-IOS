//
//  NewTestVC.swift
//  xgo
//
//  Created by Arther on 19.7.24.
//

import UIKit


class NewTestVC: NewsBaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var biaodingButton: GradientButton!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "标定初始位置".localized
        biaodingButton.setTitle("进入标定模式".localized, for: .normal)
        finishButton.setTitle("完成标定".localized, for: .normal)
        
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
