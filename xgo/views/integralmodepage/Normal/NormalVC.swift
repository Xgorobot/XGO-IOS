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
    @IBOutlet weak var rightCtlBar: ControlLRBarsView!
    
    var speedX = 0.0
    var speedY = 0.0
    var speedYar = 0.0
    var speedShow = 0.0
    
    
    @IBOutlet weak var powerImg: UIImageView!
    @IBOutlet weak var speedImg: UIImageView!
    var timer: Timer?
    var _vm: NormalVM!
    override func viewDidLoad() {
        super.viewDidLoad()
//        _vm = NormalVM.init(input: NormalVM.Input(
//                                setHeight: slider.rx.value.asObservable()))
        initCtrl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startCheckPower()
    }
    override func viewDidDisappear(_ animated: Bool) {
        stopCheckPower()
    }
    func initXYZ(){
        leftCtlBar.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
            let xValue = Int(((x+1)/2*255).rounded())
            FindControlUtil.trunkMoveX(position: xValue.hw_toByte())
            let yValue = Int(((y+1)/2*255).rounded())
            FindControlUtil.trunkMoveY(position: yValue.hw_toByte())
            self.speedImg.image = getSpeedImage(speed: max(Int(abs(x) * 100), Int(abs(y) * 100)))
        }
    }
    
    func initCtrl(){
        leftCtlBar.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in

            print("左侧点击:\(dir)")
            switch dir {
            case .OUp:
                FindControlUtil.moveX(speed: 0xDA)
                self.speedImg.image = getSpeedImage(speed: 60)
            case .ODown:
                FindControlUtil.moveX(speed: 0x25)
                self.speedImg.image = getSpeedImage(speed: 60)
            case .OLeft:
                FindControlUtil.moveY(speed: 0xDA)
            case .ORight:
                FindControlUtil.moveY(speed: 0x25)
                self.speedImg.image = getSpeedImage(speed: 60)
            case .OStop:
                self.speedImg.image = getSpeedImage(speed: 0)
                FindControlUtil.moveX(speed: 0x80)
                FindControlUtil.moveY(speed: 0x80)
            }
        }
        rightCtlBar.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            switch dir {
            case .OLeft:
                FindControlUtil.turnClockwise(speed: 0xDA)
                break
            case .ORight:
                FindControlUtil.turnClockwise(speed: 0x25)
                break
            case .OStop:
                FindControlUtil.turnClockwise(speed: 0x80)
                break
            default:
                break
            }
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
            let xValue = Int(((x+1)/2*255).rounded())
            self.speedImg.image = getSpeedImage(speed: Int(abs(x) * 100))
            FindControlUtil.turnClockwise(speed: xValue.hw_toByte())
            
            switch dir {
            case .OLeft:
                FindControlUtil.turnClockwise(speed: 0x25)
                self.speedImg.image = getSpeedImage(speed: 60)
            case .ORight:
                FindControlUtil.turnClockwise(speed: 0xDA)
                self.speedImg.image = getSpeedImage(speed: 60)
            case .OStop:
                self.speedImg.image = getSpeedImage(speed: 0)
                FindControlUtil.turnClockwise(speed: 0x80)
            default:
                break
            }
        }
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
    
    func startCheckPower()  {

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in

            FindControlUtil.readPower { power in
                self.powerImg.image = getPowerImage(power: power[0].integerValue())
                
                print("结果1：\(0*14/255)")
                print("结果2：\(100*14/255)")
                print("结果3：\(255*14/255)")
            }
        })
    }
    func stopCheckPower() {
        timer?.invalidate()
        timer = nil
    }
}
