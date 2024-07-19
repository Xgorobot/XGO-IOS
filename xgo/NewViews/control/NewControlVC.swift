//
//  NewControlVC.swift
//  xgo
//
//  Created by Arther on 24.6.24.
//

import UIKit


class NewControlVC: UIViewController {
    
    @IBOutlet weak var controlButton: GradientButton!
    var armVC = NewArmVC()
    var menuView: NewActionMenuView!
    var setView: NewControlSetView!
    @IBOutlet weak var leftRockerView: RockerBarsView!
    @IBOutlet weak var rightRockerView: RockerBarsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x0040F8), UIColor(hex: 0x00EAFF)], endPoint: .init(x: 0, y: 1)), for: .normal)
        controlButton.cornerRadius = 3
        
        self.addChild(armVC)
        self.view.addSubview(armVC.view)
        armVC.view.isHidden = true
        
        menuView = NewActionMenuView()
        self.view.addSubview(menuView)
        
        menuView.isHidden = true
        
        menuView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        setView = Bundle.main.loadNibNamed("NewControlSetView", owner: nil)?.first as? NewControlSetView
        self.view.addSubview(setView)
        
        setView.isHidden = true
        setView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        setView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        leftRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
        }
        
        rightRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
        }
        
    }
    
    @IBAction func menuAction(_ sender: Any) {
        menuView.isHidden = false
    }
    
    @IBAction func armAction(_ sender: Any) {
        armVC.view.isHidden = false
    }
    
    @IBAction func setAction(_ sender: Any) {
        setView.isHidden = false
    }
    
    @IBAction func proAction(_ sender: Any) {
        self.navigationController?.pushViewController(NewActionVC(), animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
