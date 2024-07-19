//
//  NewAboutVC.swift
//  xgo
//
//  Created by Arther on 5.7.24.
//

import UIKit


class NewAboutVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
