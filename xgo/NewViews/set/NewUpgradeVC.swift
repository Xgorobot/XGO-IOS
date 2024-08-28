//
//  NewUpgradeVC.swift
//  xgo
//
//  Created by Arther on 10.7.24.
//

import UIKit


class NewUpgradeVC: UIViewController {
    
    @IBOutlet weak var downloadButton: GradientButton!
    @IBOutlet weak var progressBar: GradientProgressBar!
    
    @IBOutlet weak var versionName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.gradientColors = [UIColor(hex: 0x2205FF).cgColor, UIColor(hex: 0x12C4FF).cgColor]
        progressBar.setProgress(0.5, animated: true)
        
        downloadButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x2205FF), UIColor(hex: 0x12C4FF)]), for: .normal)
        downloadButton.cornerRadius = 3
    
        //todo mengwei 升级下载等文字都隐藏不要了，这里改一下其他label位置居中
        FindControlUtil.readVersionName { data in
            if (data.count >= 10){
                if let string = String(bytes: data, encoding: .utf8) {
                    self.versionName.text = "固件版本："+string
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
