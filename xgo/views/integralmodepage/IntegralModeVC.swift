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
    
    var _vm: IntegralModeVM!
    
    let _normalVC = NormalVC()
    let _seniorVC = RockerVC()
    let _xyzVC = RockerVC()
    let _pryVC = RockerVC()
    
    @IBOutlet weak var _childView: UIView!
    @IBOutlet weak var _topBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _topBar.delegate = self
    
        add(_normalVC, frame: _childView.frame)
        _normalVC.didMove(toParent: self)
    }

    @IBAction func onClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        removeAll()
        switch item.title {
        case "基础":
            add(_normalVC, frame: _childView.frame)
            _normalVC.didMove(toParent: self)
        case "高级":
            add(_seniorVC, frame: _childView.frame)
            _seniorVC.didMove(toParent: self)
        case "XYZ":
            add(_xyzVC, frame: _childView.frame)
            _xyzVC.didMove(toParent: self)
        case "PRY":
            add(_pryVC, frame: _childView.frame)
            _pryVC.didMove(toParent: self)
        
        default:
            break
        }
    }
    
    func removeAll() -> Void {
        _normalVC.remove()
        _seniorVC.remove()
        _xyzVC.remove()
        _pryVC.remove()
    }
}
