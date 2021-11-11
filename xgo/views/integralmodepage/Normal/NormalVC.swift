//
//  NormalVC.swift
//  xgo
//
//  Created by 袁文麟 on 2021/8/5.
//

import UIKit

class NormalVC: UIViewController {
    
    @IBOutlet weak var leftUpBtn: UIButton!
    @IBOutlet weak var leftDownBtn: UIButton!
    @IBOutlet weak var leftLeftBtn: UIButton!
    @IBOutlet weak var leftRightBtn: UIButton!
    @IBOutlet weak var rightLeftBtn: UIButton!
    @IBOutlet weak var rightRightBtn: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var leftRockerView: RockerBarsView!
    @IBOutlet weak var rightRockerView: RockerBarsView!
    
    @IBOutlet weak var leftCtlBar: ControlBarsView!
    @IBOutlet weak var rightCtlBar: ControlBarsView!
    
    var speedX = 0.0
    var speedY = 0.0
    var speedYar = 0.0
    var speedShow = 0.0
    
    
    var _vm: NormalVM!
    override func viewDidLoad() {
        super.viewDidLoad()
//        _vm = NormalVM.init(input: NormalVM.Input(
//                                setHeight: slider.rx.value.asObservable()))
        initCtrl()
    }
    
    func initXYZ(){
        leftCtlBar.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
            let xValue = Int(((x+1)/2*255).rounded())
            FindControlUtil.trunkMoveX(position: xValue.hw_toByte())
            let yValue = Int(((y+1)/2*255).rounded())
            FindControlUtil.trunkMoveY(position: yValue.hw_toByte())
        }
    }
    
    func initCtrl(){
        leftCtlBar.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in

            switch dir {
            case .OUp:
                FindControlUtil.moveX(speed: 0xFF)
            case .ODown:
                FindControlUtil.moveX(speed: 0x25)
            case .OLeft:
                FindControlUtil.moveY(speed: 0x25)
            case .ORight:
                FindControlUtil.moveY(speed: 0xDA)
            case .OStop:
                FindControlUtil.moveX(speed: 0x80)
                FindControlUtil.moveY(speed: 0x80)
            default:
                break
            }
        }
        rightCtlBar.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
            let xValue = Int(((x+1)/2*255).rounded())
            FindControlUtil.turnClockwise(speed: xValue.hw_toByte())
        }
    }
    
    func initRPY(){
        
    }
    override func viewDidLayoutSubviews() {
        rightCtlBar.setNeedsDisplay()
    }
    

    func updateSpeed() -> Void {
        speedShow = sqrt(speedX*speedX+speedY*speedY+speedYar*speedYar)
    }
    
    @IBAction func setheight(_ sender: UISlider) {
        let value = Int((sender.value*255).rounded())
        FindControlUtil.heightSet(height: value.hw_toByte())
//            FindControlUtil.setServo(servo: selectPosition.hw_toByte(), xyz: "z", speed: value.hw_toByte())
    }
    @IBAction func reset(_ sender: UIButton) {
        slider.value = 0.5
        FindControlUtil.heightSet(height:0x80)
    }
    
}
