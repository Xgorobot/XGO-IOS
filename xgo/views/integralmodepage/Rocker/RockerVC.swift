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
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func initCtrl(){
        leftRockerView.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("遥控:CTRL + L:\(dir)  x:\(x) y:\(y) r:\(r)")
            let xValue = Int(((y+1)/2*255).rounded())
            FindControlUtil.moveX(speed: xValue.hw_toByte())
            let yValue = Int(((x+1)/2*255).rounded())
            FindControlUtil.moveY(speed: yValue.hw_toByte())
            self.speedImg.image = getSpeedImage(speed: max(Int(abs(x) * 100), Int(abs(y) * 100)))
        }
        rightRockerView.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("遥控:CTRL + R:\(dir)  x:\(x) y:\(y) r:\(r)")
            let xValue = Int(((x+1)/2*255).rounded())
            FindControlUtil.turnClockwise(speed: xValue.hw_toByte())
            self.speedImg.image = getSpeedImage(speed: Int(abs(x) * 100))
        }
    }
    
    func initXYZ(){
        rightRockerView.isHidden = true
        leftRockerView.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("遥控:XYZ:\(dir)  x:\(x) y:\(y) r:\(r)")
            let yValue = Int(((y+1)/2*255).rounded())
            FindControlUtil.trunkMoveX(position: yValue.hw_toByte())
            let xValue = Int(((x+1)/2*255).rounded())
            FindControlUtil.trunkMoveY(position: xValue.hw_toByte())
            self.speedImg.image = getSpeedImage(speed: max(Int(abs(x) * 100), Int(abs(y) * 100)))

        }
    }
    
    func initRPY(){
        leftRockerView.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            let xValue = Int(((-x+1)/2*255).rounded())
            FindControlUtil.trunByX(angle: xValue.hw_toByte())
            
            
            let yValue = Int(((y+1)/2*255).rounded())
            FindControlUtil.trunByY(angle: yValue.hw_toByte())
            print("遥控:PRY + L:\(dir)  x:\(x) y:\(y)   输出X:\(yValue)  输出Y:\(xValue)")

        }
        rightRockerView.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("遥控:PRY + R:\(dir)  x:\(x) y:\(y) r:\(r)")
            let xValue = Int(((x+1)/2*255).rounded())
            FindControlUtil.trunByZ(angle: xValue.hw_toByte())
        }
    }
    
    @IBAction func setheight(_ sender: UISlider) {
        let value = Int((sender.value*255).rounded())
        FindControlUtil.heightSet(height: value.hw_toByte())
    }
    
    @IBAction func reset(_ sender: UIButton) {
        slider.value = 0.5
        FindControlUtil.heightSet(height:0x80)
    }
    override func viewDidDisappear(_ animated: Bool) {
        startCheckPower()
    }
    override func viewWillDisappear(_ animated: Bool) {
        stopCheckPower()
    }
    
    @IBOutlet weak var powerImg: UIImageView!
    @IBOutlet weak var speedImg: UIImageView!
    var timer: Timer?
    func startCheckPower()  {
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                FindControlUtil.readPower { power in
                    if (power.count >= 3){
                        self.powerImg.image = getPowerImage(power: NSString(format: "%d", power[2]).integerValue)
                    }
                }
            })
    }
    func stopCheckPower() {
        timer?.invalidate()
        timer = nil
    }
}
