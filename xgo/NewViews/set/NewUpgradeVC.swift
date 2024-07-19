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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.gradientColors = [UIColor(hex: 0x2205FF).cgColor, UIColor(hex: 0x12C4FF).cgColor]
        progressBar.setProgress(0.5, animated: true)
        
        downloadButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x2205FF), UIColor(hex: 0x12C4FF)]), for: .normal)
        downloadButton.cornerRadius = 3
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func download(_ sender: Any) {
    }
    
    @IBAction func update(_ sender: Any) {
    }
    
}
