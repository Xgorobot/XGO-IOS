//
//  NewHomeVC.swift
//  xgo
//
//  Created by Arther on 18.6.24.
//

import UIKit

class NewHomeVC: UIViewController {
    
    @IBOutlet weak var bluetoothInfoView: UIView!
    @IBOutlet weak var bluetoothInfoLabel: UILabel!
    @IBOutlet weak var controlButton: UIButton!
    var homeSetView: HomeSetView!
    var homeUpSetView: HomeUpSetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        bluetooth()
    }
    
    private func initView() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        bluetoothInfoView.layer.cornerRadius = 35/2
        bluetoothInfoView.layer.borderWidth = 2
        bluetoothInfoView.layer.borderColor = UIColor(hex: 0x09B1FF).cgColor
        bluetoothInfoView.layer.masksToBounds = true
        
        homeSetView = Bundle.main.loadNibNamed("HomeSetView", owner: nil)?.first as? HomeSetView
        self.view.addSubview(homeSetView)
        
        homeSetView.layer.cornerRadius = 5
        homeSetView.layer.masksToBounds = true
        
        homeSetView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).inset(20)
            make.left.equalTo(bluetoothInfoView)
            make.size.equalTo(CGSize(width: 86, height: 98))
        }
        
        // 关于方法调用
        homeSetView.about = {[weak self] in
            self?.navigationController?.pushViewController(NewAboutVC(), animated: true)
        }
        
        
        homeUpSetView = Bundle.main.loadNibNamed("HomeUpSetView", owner: nil)?.first as? HomeUpSetView
        self.view.addSubview(homeUpSetView)
        
        homeUpSetView.layer.cornerRadius = 5
        homeUpSetView.layer.masksToBounds = true
        homeUpSetView.isHidden = true
        
        homeUpSetView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).inset(20)
            make.left.equalTo(bluetoothInfoView)
            make.size.equalTo(CGSize(width: 161, height: 204))
        }
        
        // 修改页面后 按钮调用方法
        // 关于
        homeUpSetView.about = {[weak self] in
            self?.navigationController?.pushViewController(NewAboutVC(), animated: true)
        }
        // 标定
        homeUpSetView.biaoding = {[weak self] in
            self?.navigationController?.pushViewController(NewTestVC(), animated: true)
        }
        // 固件
        homeUpSetView.gujian = {[weak self] in
            self?.navigationController?.pushViewController(NewUpgradeVC(), animated: true)
        }
        // 设置
        homeUpSetView.shezhi = {[weak self] in
            self?.navigationController?.pushViewController(NewSetVC(), animated: true)
        }
        
        controlButton.isHidden = true
        
        
    }
    
    // 跳转控制页面
    @IBAction func controlAction(_ sender: Any) {
        
        self.navigationController?.pushViewController(NewControlVC(), animated: true)
        
    }
    
    // 跳转蓝牙页面
    @IBAction func bluetoothAction(_ sender: Any) {
        
        self.navigationController?.pushViewController(NewSearchVC(), animated: true)
        
    }
    
    // 蓝牙连接页面布局切换
    func bluetooth() {
        
        if homeSetView.isHidden {
            homeUpSetView.isHidden = true
            controlButton.isHidden = true
            homeSetView.isHidden = false
        } else {
            controlButton.isHidden = false
            homeUpSetView.isHidden = false
            homeSetView.isHidden = true
        }
        
        
    }
    
    
}

extension MTCircularSlider {
    
//    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//            let hitView = super.hitTest(point, with: event)
//            return hitView == self ? nil : hitView
//        }
    
}


class textView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
    
}
