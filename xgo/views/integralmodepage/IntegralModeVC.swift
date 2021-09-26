//
//  IntegralModeVC.swift
//  xgo
//
//  Created by 袁文麟 on 2021/7/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class IntegralModeVC: UIViewController,UITabBarDelegate {
    
    let _bag: DisposeBag = DisposeBag()
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    var _vm: IntegralModeVM!
    
    let _normalVC = NormalVC()
    let _seniorVC = RockerVC()
    let _xyzVC = RockerVC()
    let _pryVC = RockerVC()
    
    @IBOutlet weak var _childView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        add(_normalVC, frame: _childView.frame)
        _normalVC.didMove(toParent: self)
        btn0.setBackgroundImage(#imageLiteral(resourceName: "yaokongTitleBg"), for: .selected)
        btn0.isSelected = true
        btn1.setBackgroundImage(#imageLiteral(resourceName: "yaokongTitleBg"), for: .selected)
        btn2.setBackgroundImage(#imageLiteral(resourceName: "yaokongTitleBg"), for: .selected)
        btn3.setBackgroundImage(#imageLiteral(resourceName: "yaokongTitleBg"), for: .selected)
    }
    
    @IBAction func onClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onItemSelect(_ sender: UIButton) {
        removeAll()
        sender.isSelected = true
        switch sender.tag {
        case 0:
            add(_normalVC, frame: _childView.frame)
            _normalVC.didMove(toParent: self)
            break
        case 1:
            add(_seniorVC, frame: _childView.frame)
            _seniorVC.initCtrl()
            _seniorVC.didMove(toParent: self)
            break
        case 2:
            add(_xyzVC, frame: _childView.frame)
            _xyzVC.initXYZ()
            _xyzVC.didMove(toParent: self)
            break
        case 3:
            add(_pryVC, frame: _childView.frame)
            _pryVC.initRPY()
            _pryVC.didMove(toParent: self)
            break
        default:
            break
        }
    }
    
    
    func removeAll() -> Void {
        _normalVC.remove()
        _seniorVC.remove()
        _xyzVC.remove()
        _pryVC.remove()
        btn0.isSelected = false
        btn1.isSelected = false
        btn2.isSelected = false
        btn3.isSelected = false
    }
}
