//
//  SingleLegVC.swift
//  xgo
//
//  Created by 袁文麟 on 2021/7/21.
//

import UIKit
import RxSwift

class SingleLegVC: UIViewController,UITabBarDelegate {

    @IBOutlet weak var XLabel: UILabel!
    @IBOutlet weak var XLabel2: UILabel!
    @IBOutlet weak var YLabel: UILabel!
    @IBOutlet weak var YLabel2: UILabel!
    @IBOutlet weak var ZLabel: UILabel!
    @IBOutlet weak var ZLabel2: UILabel!
    
    @IBOutlet weak var XSlider: UISlider!
    @IBOutlet weak var YSlider: UISlider!
    @IBOutlet weak var ZSlider: UISlider!
    
    @IBOutlet weak var positionTabbar: UITabBar!
    
    var selectPosition:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        XSlider.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        YSlider.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        ZSlider.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        positionTabbar.selectedItem = positionTabbar.items![0];
        positionTabbar.delegate = self
        
    }

    @IBAction func onXValueChanged(_ sender: UISlider, forEvent event: UIEvent) {//[-35mm,+35mm]
        let showValue = Int(sender.value.rounded())
        let value = Int(((sender.value+35)/70*255).rounded())
        XLabel2.text = "\(showValue) mm"
        XLabel.text = "X:\(showValue)mm"
        FindControlUtil.setLeg(leg: selectPosition.hw_toByte(), xyz: "x", speed: value.hw_toByte())
    }
    
    @IBAction func onYValueChanged(_ sender: UISlider) {//[-18mm,+18mm]
        let showValue = Int(sender.value.rounded())
        let value = Int(((sender.value+18)/36*255).rounded())
        YLabel2.text = "\(showValue) mm"
        YLabel.text = "Y:\(showValue)mm"
        FindControlUtil.setLeg(leg: selectPosition.hw_toByte(), xyz: "y", speed: value.hw_toByte())
    }
    
    @IBAction func onZValueChanged(_ sender: UISlider) {//[75mm,115mm]
        let showValue = Int(sender.value.rounded())
        let value = Int(((sender.value-75)/40*255).rounded())
        ZLabel2.text = "\(showValue) mm"
        ZLabel.text = "Z:\(showValue)mm"
        FindControlUtil.setLeg(leg: selectPosition.hw_toByte(), xyz: "z", speed: value.hw_toByte())
    }
    
    @IBAction func onBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onResetClick(_ sender: Any) {
        XSlider.value = 0
        YSlider.value = 0
        ZSlider.value = 105
        XLabel2.text = "0 mm"
        XLabel.text = "X:0mm"
        YLabel2.text = "0 mm"
        YLabel.text = "0 nmm"
        ZLabel2.text = "105 mm"
        ZLabel.text = "Z:105 mm"
        FindControlUtil.actionType(type: 0xFF)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.selectPosition = item.tag
    }


}
