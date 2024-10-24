//
//  NewControlVC.swift
//  xgo
//
//  Created by Arther on 24.6.24.
//

import UIKit


class NewControlVC: NewsBaseViewController {
    
    @IBOutlet weak var controlButton: GradientButton!
    @IBOutlet weak var armButton: UIButton!
    
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
    
    
    var isHiddenViewArr: [UIView] = []
    @IBOutlet weak var proButton: UIButton!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var paxiaButton: UIButton!
    @IBOutlet weak var dunqiLabel: UIButton!
    
    let actionArray = ["动作轮播".localized,"趴下".localized,"站起".localized,"匍匐前进".localized,"转圈".localized,"蹲起".localized,"转动 ROLL".localized,"转动 PITCH".localized,"转动 YAW".localized,"三轴联动".localized,"撒尿".localized,"坐下".localized,"招手".localized,"伸懒腰".localized,"波浪".localized,"摇摆".localized,"求食".localized,"找食物".localized,"握手".localized]
    
    
    
    let initTime = Date().timeIntervalSince1970
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlButton.setTitle("动作控制".localized, for: .normal)
        armButton.setTitle("机械臂控制".localized, for: .normal)
        actionButton.setTitle("动作轮播".localized, for: .normal)
        paxiaButton.setTitle("趴下".localized, for: .normal)
        dunqiLabel.setTitle("蹲起".localized, for: .normal)
        
        // todo yuanwenlin
        proButton.setImage(UIImage(named: "btn_pro"), for: .normal)
        proButton.setImage(UIImage(named: "btn_pro_pressed"), for: .selected)
        BLEMANAGER?.stepSpeed = 70
        controlButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x0040F8), UIColor(hex: 0x00EAFF)], endPoint: .init(x: 0, y: 1)), for: .normal)
        controlButton.cornerRadius = 3
        
        self.addChild(armVC)
        self.view.addSubview(armVC.view)
        armVC.view.isHidden = true
        
        menuView = NewActionMenuView()
        menuView.actionArray = actionArray
        self.view.addSubview(menuView)
        
        menuView.closeAction = { [weak self] in
            self?.menuView.isHidden = true
        }
        
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
        
        setView.tuoLuoYiLabel.text = "陀螺仪".localized
        setView.speedLabel.text = "整机速度".localized
        setView.heightTitleLabel.text = "整机高度".localized
        setView.walkTitleLabel.text = "步      幅".localized
        setView.speedSegmented.setTitle("低速".localized, forSegmentAt: 0)
        setView.speedSegmented.setTitle("普通".localized, forSegmentAt: 1)
        setView.speedSegmented.setTitle("高速".localized, forSegmentAt: 2)
        
        
        // 设置指定状态下的文本属性
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setView.speedSegmented.setTitleTextAttributes(attributes, for: .selected)
        setView.speedSegmented.setTitleTextAttributes(attributes, for: .normal)

        
        leftControlView.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            
           
           
            print("test1 dir \(dir)  x:\(x) y:\(y) r:\(r)")
            
            
            switch dir {
                case .OUp:
                    FindControlUtil.moveX(speed: UInt8(0x80 + (BLEMANAGER?.stepSpeed ?? 70)))
                case .ODown:
                    FindControlUtil.moveX(speed: UInt8(0x80 - (BLEMANAGER?.stepSpeed ?? 70)))
                case .OLeft:
                    FindControlUtil.moveY(speed: UInt8(0x80 + (BLEMANAGER?.stepSpeed ?? 70)))
                case .ORight:
                    FindControlUtil.moveY(speed: UInt8(0x80 - (BLEMANAGER?.stepSpeed ?? 70)))
                case .OStop:
                    FindControlUtil.moveX(speed: 0x80)
                    FindControlUtil.moveY(speed: 0x80)
            }
        }
        
        leftRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            
            print("test2 \(dir)  x:\(x) y:\(y) r:\(r)")
            
            switch dir {
                case .OUp:
                    FindControlUtil.moveX(speed: UInt8(0x80 + (BLEMANAGER?.stepSpeed ?? 70)))
                case .ODown:
                    FindControlUtil.moveX(speed: UInt8(0x80 - (BLEMANAGER?.stepSpeed ?? 70)))
                case .OLeft:
                    FindControlUtil.moveY(speed: UInt8(0x80 + (BLEMANAGER?.stepSpeed ?? 70)))
                case .ORight:
                    FindControlUtil.moveY(speed: UInt8(0x80 - (BLEMANAGER?.stepSpeed ?? 70)))
                case .OStop:
                    FindControlUtil.moveX(speed: 0x80)
                    FindControlUtil.moveY(speed: 0x80)
            }
        }
        
        
        rightControlView.updownEnable = false
        rightControlView.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            
            print("顺时针旋转2dir:\(dir)")
            switch dir {
                case .OLeft:
                    FindControlUtil.turnClockwise(speed:UInt8(0x80 + (BLEMANAGER?.stepSpeed ?? 70)) )
                    break
                case .ORight:
                    FindControlUtil.turnClockwise(speed:UInt8(0x80 - (BLEMANAGER?.stepSpeed ?? 70)) )
                    break
                case .OStop:
                    FindControlUtil.turnClockwise(speed: 0x80)
                    break
                default:
                    break
            }
           

        }
        
        rightRockerView.actionBar?.bDirection = {(dir:OperationOrder , x:CGFloat , y:CGFloat , r:CGFloat) in
            print("右侧摇杆 \(dir)  x:\(x) y:\(y) r:\(r)")
            
            switch dir {
                case .OLeft:
                    FindControlUtil.turnClockwise(speed:0xDA )
                    break
                case .ORight:
                    FindControlUtil.turnClockwise(speed:0x25 )
                    break
                case .OStop:
                    FindControlUtil.turnClockwise(speed: 0x80)
                    break
                default:
                    break
            }
            

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
        
        isHiddenViewArr.append(contentsOf: [leftTopCircularSlider,rightTopCircularSlider,rightBottomCircularSlider,rLeftTopCircularSlider,rRightTopCircularSlider,rLeftBottomCircularSlider])
        isHiddenViewArr.forEach { item in
            item.isHidden = true
        }
    }
    
    @IBAction func leftTopSliderValue(_ sender: MTCircularSlider) {
        if Date().timeIntervalSince1970 - initTime < 1 {
            return
        }
        print("leftTopSliderValue")
        BLEMANAGER?.checkRepeat {
            let value = Int((sender.value*255/100).rounded())
            // 夹爪
            FindControlUtil.trunkMoveX(position: UInt8(value))
        }
    }
    
    @IBAction func rightTopSliderValue(_ sender: MTCircularSlider) {
        if Date().timeIntervalSince1970 - initTime < 1 {
            return
        }
        print("rightTopSliderValue")
        BLEMANAGER?.checkRepeat {
            let value = Int((sender.value*255/100).rounded())
            // 夹爪
            FindControlUtil.trunkMoveY(position: UInt8(value))
        }
    }
    
    @IBAction func rightBottomSliderValue(_ sender: MTCircularSlider) {
        if Date().timeIntervalSince1970 - initTime < 1 {
            return
        }
        print("rightBottomSliderValue")
        BLEMANAGER?.checkRepeat {
            let value = Int((sender.value*255/100).rounded())
            // 夹爪
            FindControlUtil.heightSet(height: UInt8(value))
        }
    }
    
    @IBAction func rLeftTopSliderValue(_ sender: MTCircularSlider) {
        if Date().timeIntervalSince1970 - initTime < 1 {
            return
        }
        print("rLeftTopSliderValue")
        BLEMANAGER?.checkRepeat {
            let value = Int((sender.value*255/100).rounded())
            // 夹爪
            FindControlUtil.trunByY(angle: UInt8(value))
        }
    }
    
    @IBAction func rRightTopSliderValue(_ sender: MTCircularSlider) {
        if Date().timeIntervalSince1970 - initTime < 1 {
            return
        }
        print("rRightTopSliderValue")
        BLEMANAGER?.checkRepeat {
            let value = Int((sender.value*255/100).rounded())
            // 夹爪
            FindControlUtil.trunByX(angle: UInt8(value))
        }
    }
    
    @IBAction func rLeftBottomSliderValue(_ sender: MTCircularSlider) {
        if Date().timeIntervalSince1970 - initTime < 1 {
            return
        }
        print("rLeftBottomSliderValue")
        BLEMANAGER?.checkRepeat {
            let value = Int((sender.value*255/100).rounded())
            // 夹爪
            FindControlUtil.trunByZ(angle: UInt8(value))
        }
    }
    
    @IBAction func menuAction(_ sender: Any) {
//        armVC.view.isHidden = false
        menuView.isHidden = false
    }
    
    @IBAction func armAction(_ sender: Any) {
        armVC.view.isHidden = false
    }
    
    @IBAction func setAction(_ sender: Any) {
        setView.isHidden = false
    }
    
    @IBAction func proAction(_ sender: Any) {
        
        proButton.isSelected = !proButton.isSelected
        
        if proButton.isSelected {
            isHiddenViewArr.forEach { item in
                item.isHidden = false
            }
        } else {
            isHiddenViewArr.forEach { item in
                item.isHidden = true
            }
        }
        
//
//        self.navigationController?.pushViewController(NewActionVC(), animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // 动作轮播
    @IBAction func actionPlay(_ sender: Any) {
        menuView.isHidden = false
    }
    // 趴下
    @IBAction func getDown(_ sender: Any) {
        menuView.isHidden = false
    }
    // 蹲起
    @IBAction func squat(_ sender: Any) {
        menuView.isHidden = false
    }
    
    @IBAction func actionUp() {
        
        FindControlUtil.actionType(type: 0x80)
    }
    
    @IBAction func actionMiddle() {
        FindControlUtil.actionType(type: 0x81)
    }
    
    @IBAction func actionDown() {
        FindControlUtil.actionType(type: 0x82)
        
    }
    
    @IBAction func Press(_ sender: Any) {
        FindControlUtil.setFire(enable: true)
    }
    @IBAction func upInside(_ sender: Any) {
        FindControlUtil.setFire(enable: false)
    }
    @IBAction func upOutside(_ sender: Any) {
        FindControlUtil.setFire(enable: false)
    }
    @IBAction func touchCancel(_ sender: Any) {
        FindControlUtil.setFire(enable: false)
    }
}
