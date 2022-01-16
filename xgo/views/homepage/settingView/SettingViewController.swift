//
//  SettingViewController.swift
//  xgo
//
//  Created by 袁文麟 on 2022/1/16.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var devOpenSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        devOpenSwitch.isOn = DevOpen
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onSwitch(_ sender: UISwitch) {
        DevOpen = sender.isOn
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
}
