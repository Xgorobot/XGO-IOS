//
//  RockerVC.swift
//  xgo
//
//  Created by 袁文麟 on 2021/8/5.
//

import UIKit

class RockerVC: UIViewController {

    
    @IBOutlet weak var leftRockerView: RockerBarsView!
    @IBOutlet weak var rightRockerView: RockerBarsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func initCtrl(){
        leftRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
            let xValue = Int(((y+1)/2*255).rounded())
            FindControlUtil.moveX(speed: xValue.hw_toByte())
            let yValue = Int(((x+1)/2*255).rounded())
            FindControlUtil.moveY(speed: yValue.hw_toByte())
        }
        rightRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
            let xValue = Int(((x+1)/2*255).rounded())
            FindControlUtil.turnClockwise(speed: xValue.hw_toByte())
        }
    }
    
    func initXYZ(){
        rightRockerView.isHidden = true
        leftRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
            let yValue = Int(((y+1)/2*255).rounded())
            FindControlUtil.trunkMoveX(position: yValue.hw_toByte())
            let xValue = Int(((x+1)/2*255).rounded())
            FindControlUtil.trunkMoveY(position: xValue.hw_toByte())
        }
    }
    
    func initRPY(){
        leftRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            let xValue = Int(((-x+1)/2*255).rounded())
            FindControlUtil.trunByX(angle: xValue.hw_toByte())
            
            
            let yValue = Int(((y+1)/2*255).rounded())
            FindControlUtil.trunByY(angle: yValue.hw_toByte())
            print("pry  x:\(x) y:\(y)   输出X:\(yValue)  输出Y:\(xValue)")

        }
        rightRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
            let xValue = Int(((x+1)/2*255).rounded())
            FindControlUtil.trunByZ(angle: xValue.hw_toByte())
        }
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
