//
//  DebugViewController.swift
//  xgo
//
//  Created by 袁文麟 on 2022/1/8.
//

import UIKit

class DebugViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func onbackclick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func close(_ sender: Any) {
        FindControlUtil.setModeClose()
        CBToast.showToast(message: NSLocalizedString("标定模式结束", comment: "标定模式结束") as NSString, aLocationStr: "bottom", aShowTime: 2)
    }
    
    @IBAction func open(_ sender: UIButton) {
        FindControlUtil.setModeStart()
        CBToast.showToast(message: NSLocalizedString("标定模式", comment: "标定模式") as NSString, aLocationStr: "bottom", aShowTime: 2)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        FindControlUtil.setModeClose()
    }	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
