//
//  NewAboutVC.swift
//  xgo
//
//  Created by Arther on 5.7.24.
//

import UIKit


class NewAboutVC: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
