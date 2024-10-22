//
//  NewUpgradeVC.swift
//  xgo
//
//  Created by Arther on 10.7.24.
//

import UIKit


class NewUpgradeVC: NewsBaseViewController {
    
    @IBOutlet weak var downloadButton: GradientButton!
    @IBOutlet weak var progressBar: GradientProgressBar!
    
    @IBOutlet weak var versionName: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "固件版本".localized
    
        //todo mengwei 升级下载等文字都隐藏不要了，这里改一下其他label位置居中
        FindControlUtil.readVersionName { data in
            if (data.count >= 10){
                if let string = String(bytes: data, encoding: .utf8) {
                    self.versionName.text = "固件版本".localized + "：" + string
                } else {
                    print("无法将字节数组转换为字符串")
                }
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func download(_ sender: Any) {
    }
    
    @IBAction func update(_ sender: Any) {
    }
    
}
