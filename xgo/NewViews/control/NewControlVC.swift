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
    @IBOutlet weak var leftControlView: ControlBarsView!
    @IBOutlet weak var rightControlView: ControlBarsView!
    
    @IBOutlet weak var leftRockerView: RockerBarsView!
    @IBOutlet weak var rightRockerView: RockerBarsView!
    
    @IBOutlet weak var leftTopCircularSlider: MTCircularSlider!
    @IBOutlet weak var rightTopCircularSlider: MTCircularSlider!
    @IBOutlet weak var rightBottomCircularSlider: MTCircularSlider!
    
    
    @IBOutlet weak var rLeftTopCircularSlider: MTCircularSlider!
    @IBOutlet weak var rRightTopCircularSlider: MTCircularSlider!
    @IBOutlet weak var rLeftBottomCircularSlider: MTCircularSlider!
    
    
//    var actionArray = ["动作轮播","趴下","蹲起"]
    
    var actionArray = ["趴下","蹲起","匍匐前进","转圈","原地踏步","转动ROLL","转动PITCH","转动YAW","三轴联动","撒尿","坐下","招手","伸懒腰","波浪","摇摆","求食","找食物","握手"]
    
    //    let dataItem = ["趴下","站起","匍匐前进","转圈","原地踏步","蹲起","转动ROLL","转动PITCH","转动YAW","三轴联动","撒尿","坐下","招手","伸懒腰","波浪","摇摆","求食","找食物","握手"]
        
            /*运动模式 动作指令表，1-N为各个动作(0-N为十进制)
             0为默认站姿，1趴下，2站起，3匍匐前进，4转圈，5原地踏步，6蹲起，7转动Roll，
             8转动Pitch，9转动Yaw，10三轴转动，11撒尿，12坐下，13招手，14伸懒腰，15波浪，
             16左右摇摆，17求食，18找食物，19握手*/
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x0040F8), UIColor(hex: 0x00EAFF)], endPoint: .init(x: 0, y: 1)), for: .normal)
        controlButton.cornerRadius = 3
        
        self.addChild(armVC)
        self.view.addSubview(armVC.view)
        armVC.view.isHidden = true
        
        menuView = NewActionMenuView()
        menuView.actionArray = actionArray
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
        

        
        leftControlView.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
        }
        
        leftRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
        }
        
        
        rightControlView.updownEnable = false
        rightControlView.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
        }
        
        rightRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("\(dir)  x:\(x) y:\(y) r:\(r)")
        }
        
        leftTopCircularSlider.applyAttributes([
            /* Track */
            Attributes.minTrackTint(UIColor(hex: 0xF6BB00)),
            Attributes.maxTrackTint(UIColor(hex: 0x011B80)),
            Attributes.trackWidth(6),
            Attributes.trackShadowRadius(0),
            Attributes.trackShadowDepth(0),
            Attributes.trackMinAngle(10),
            Attributes.trackMaxAngle(80),
            Attributes.areTrackCapsRound(true),
            /* Thumb */
            Attributes.hasThumb(true),
            Attributes.thumbTint(.white),
            Attributes.thumbRadius(8),
            Attributes.thumbShadowRadius(0),
            Attributes.thumbShadowDepth(0)
        ])
        leftTopCircularSlider.valueMinimum = 0
        leftTopCircularSlider.valueMaximum = 100
        leftTopCircularSlider.value = 50
        leftTopCircularSlider.interactionDirection = .leftTop
        
        rightTopCircularSlider.applyAttributes([
            /* Track */
            Attributes.minTrackTint(UIColor(hex: 0xF6BB00)),
            Attributes.maxTrackTint(UIColor(hex: 0x011B80)),
            Attributes.trackWidth(6),
            Attributes.trackShadowRadius(0),
            Attributes.trackShadowDepth(0),
            Attributes.trackMinAngle(100),
            Attributes.trackMaxAngle(170),
            Attributes.areTrackCapsRound(true),
            /* Thumb */
            Attributes.hasThumb(true),
            Attributes.thumbTint(.white),
            Attributes.thumbRadius(8),
            Attributes.thumbShadowRadius(0),
            Attributes.thumbShadowDepth(0)
        ])
        rightTopCircularSlider.valueMinimum = 0
        rightTopCircularSlider.valueMaximum = 100
        rightTopCircularSlider.value = 50
        rightTopCircularSlider.interactionDirection = .rightTop
        
        rightBottomCircularSlider.applyAttributes([
            /* Track */
            Attributes.minTrackTint(UIColor(hex: 0xF6BB00)),
            Attributes.maxTrackTint(UIColor(hex: 0x011B80)),
            Attributes.trackWidth(6),
            Attributes.trackShadowRadius(0),
            Attributes.trackShadowDepth(0),
            Attributes.trackMinAngle(190),
            Attributes.trackMaxAngle(260),
            Attributes.areTrackCapsRound(true),
            /* Thumb */
            Attributes.hasThumb(true),
            Attributes.thumbTint(.white),
            Attributes.thumbRadius(8),
            Attributes.thumbShadowRadius(0),
            Attributes.thumbShadowDepth(0)
        ])
        
        rightBottomCircularSlider.valueMinimum = 0
        rightBottomCircularSlider.valueMaximum = 100
        rightBottomCircularSlider.value = 50
        rightBottomCircularSlider.interactionDirection = .rightBottom
        
        
        rLeftTopCircularSlider.applyAttributes([
            /* Track */
            Attributes.minTrackTint(UIColor(hex: 0xF6BB00)),
            Attributes.maxTrackTint(UIColor(hex: 0x011B80)),
            Attributes.trackWidth(6),
            Attributes.trackShadowRadius(0),
            Attributes.trackShadowDepth(0),
            Attributes.trackMinAngle(10),
            Attributes.trackMaxAngle(80),
            Attributes.areTrackCapsRound(true),
            /* Thumb */
            Attributes.hasThumb(true),
            Attributes.thumbTint(.white),
            Attributes.thumbRadius(8),
            Attributes.thumbShadowRadius(0),
            Attributes.thumbShadowDepth(0)
        ])
        rLeftTopCircularSlider.valueMinimum = 0
        rLeftTopCircularSlider.valueMaximum = 100
        rLeftTopCircularSlider.value = 50
        rLeftTopCircularSlider.interactionDirection = .leftTop
        
        rRightTopCircularSlider.applyAttributes([
            /* Track */
            Attributes.minTrackTint(UIColor(hex: 0xF6BB00)),
            Attributes.maxTrackTint(UIColor(hex: 0x011B80)),
            Attributes.trackWidth(6),
            Attributes.trackShadowRadius(0),
            Attributes.trackShadowDepth(0),
            Attributes.trackMinAngle(100),
            Attributes.trackMaxAngle(170),
            Attributes.areTrackCapsRound(true),
            /* Thumb */
            Attributes.hasThumb(true),
            Attributes.thumbTint(.white),
            Attributes.thumbRadius(8),
            Attributes.thumbShadowRadius(0),
            Attributes.thumbShadowDepth(0)
        ])
        rRightTopCircularSlider.valueMinimum = 0
        rRightTopCircularSlider.valueMaximum = 100
        rRightTopCircularSlider.value = 50
        rRightTopCircularSlider.interactionDirection = .rightTop
        
        
        rLeftBottomCircularSlider.applyAttributes([
            /* Track */
            Attributes.minTrackTint(UIColor(hex: 0xF6BB00)),
            Attributes.maxTrackTint(UIColor(hex: 0x011B80)),
            Attributes.trackWidth(6),
            Attributes.trackShadowRadius(0),
            Attributes.trackShadowDepth(0),
            Attributes.trackMinAngle(280),
            Attributes.trackMaxAngle(350),
            Attributes.areTrackCapsRound(true),
            /* Thumb */
            Attributes.hasThumb(true),
            Attributes.thumbTint(.white),
            Attributes.thumbRadius(8),
            Attributes.thumbShadowRadius(0),
            Attributes.thumbShadowDepth(0)
        ])
        rLeftBottomCircularSlider.valueMinimum = 0
        rLeftBottomCircularSlider.valueMaximum = 100
        rLeftBottomCircularSlider.value = 50
        rLeftBottomCircularSlider.interactionDirection = .leftBottom
        
        
//        view.bringSubviewToFront(leftControlView)
//        view.bringSubviewToFront(leftRockerView)
//        view.bringSubviewToFront(rightControlView)
//        view.bringSubviewToFront(rightRockerView)
//        view.bringSubviewToFront(setView)
//        view.bringSubviewToFront(menuView)
        
    }
    
    @IBAction func leftTopSliderValue(_ sender: MTCircularSlider) {
        print(sender.value)
    }
    
    @IBAction func rightTopSliderValue(_ sender: MTCircularSlider) {
        print(sender.value)
    }
    
    @IBAction func rightBottomSliderValue(_ sender: MTCircularSlider) {
        print(sender.value)
    }
    
    @IBAction func rLeftTopSliderValue(_ sender: MTCircularSlider) {
        print(sender.value)
    }
    
    @IBAction func rRightTopSliderValue(_ sender: MTCircularSlider) {
        print(sender.value)
    }
    
    @IBAction func rLeftBottomSliderValue(_ sender: MTCircularSlider) {
        print(sender.value)
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
    // 动作轮播
    @IBAction func actionPlay(_ sender: Any) {
    }
    // 趴下
    @IBAction func getDown(_ sender: Any) {
    }
    // 蹲起
    @IBAction func squat(_ sender: Any) {
    }
    
    @IBAction func actionUp() {
        
    }
    
    @IBAction func actionMiddle() {
        
    }
    
    @IBAction func actionDown() {
        
    }
    
    
}