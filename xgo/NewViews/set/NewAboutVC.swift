//
//  NewAboutVC.swift
//  xgo
//
//  Created by Arther on 5.7.24.
//

import UIKit


class NewAboutVC: NewsBaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var yinsiButton: UIButton!
    @IBOutlet weak var companyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "关于".localized
        yinsiButton.setTitle("《" + "隐私协议".localized + "》", for: .normal)
        companyLabel.text = "陆吾智能 版权所有 All Rights Reserved.".localized
        
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion :AnyObject? = infoDictionary! ["CFBundleShortVersionString"] as AnyObject
        versionLabel.text = "version " + (majorVersion as! String)
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func zhengce(_ sender: Any) {
        self.navigationController?.pushViewController(NewXieyiVC(), animated: true)
    }
    
    
}
