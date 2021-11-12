//
//  ControlBarsView.swift
//  xgo
//
//  Created by 袁文麟 on 2021/9/14.
//

import UIKit

class ControlBarsView: UIView {
    
    var tw: CGFloat = 0.0
    var th: CGFloat = 0.0
    
    var bDirection:bDirection!
    
    var updownEnable: Bool = true

    required init?(coder: NSCoder) {
           super.init(coder: coder)
           setUp()
       }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
       
    }
    
    override func layoutSubviews() {
        
    }
    
    func setUp() {
        var image = #imageLiteral(resourceName: "weianxia")
        if !updownEnable {
            image = #imageLiteral(resourceName: "zuoyou")
        }
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        image.draw(in:bounds)
        let nimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        backgroundColor = UIColor(patternImage: nimage!)

//        actionBar = RockerBars.init(frame: CGRect(x: frame.size.width / 2 - frame.size.width / 8,
//                                                  y: frame.size.height / 2 - frame.size.width / 8,
//                                                  width: frame.size.width / 4,
//                                                  height: frame.size.height / 4))
//        actionBar?.layer.cornerRadius = (actionBar?.frame.width)! / 2
//        actionBar?.clipsToBounds = true;
//        addSubview(actionBar!)
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouch(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouch(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onRelease()
    }
    
    
    func onTouch(_ touches: Set<UITouch>) {
        let touch = touches.first
        tw = (self.frame.size.width) / 2
        th = (self.frame.size.height) / 2
        if(touch != nil){
            let lastTouch = touch!.location(in: self.superview)

            let touchPoint = CGPoint(x: lastTouch.x, y: lastTouch.y)
            
            let radius = sqrt(pow(lastTouch.x - self.center.x, 2) + pow(lastTouch.y - self.center.y, 2))
            let frameRadius = self.frame.width / 2
            
            var angle = angleJudge(cpoint: CGPoint(x: touchPoint.x, y: touchPoint.y))
            
            print("触点x :\(Int(touchPoint.x)) 触点y :\(Int(touchPoint.y))  中间点:   \( Int( self.center.x)) \( Int(self.center.y )) 角度: \(Int(angle * 180 / .pi))  半径:\(Int(radius))  界面半径 \(frameRadius)"  )
            
            if radius < frameRadius/3 {
                return
            }
            if radius > frameRadius {
                return
            }
            let xP = touchPoint.x - self.center.x
            let yP = touchPoint.y - self.center.y
            
            var resultR = radius / frameRadius
            resultR = max(0, resultR)
            resultR = min(1, resultR)
            var resultX = xP/frameRadius
            resultX = max(-1, resultX)
            resultX = min(1, resultX)
            var resultY = yP/frameRadius
            resultY = max(-1, resultY)
            resultY = min(1, resultY)
            angle = angle * 180 / .pi
            
            
            if (angle >= -45 && angle <= 45)
            {
                if(Int(touchPoint.x) > Int(self.center.x))
                {
                    if updownEnable {
                        setImage(image: #imageLiteral(resourceName: "y"))
                    }else{
                        setImage(image: #imageLiteral(resourceName: "you"))
                    }
                    bDirection(OperationOrder.ORight,resultX,resultY,resultR)
                }else{
                    if updownEnable {
                        setImage(image: #imageLiteral(resourceName: "z"))
                    }else{
                        setImage(image: #imageLiteral(resourceName: "zuo"))
                    }
                    bDirection(OperationOrder.OLeft,resultX,resultY,resultR)
                }
            }
            
            if updownEnable {
                if ((angle > 45 && angle <= 90) || (angle < -45 && angle >= -90))
                {
                    if(Int(touchPoint.y) > Int(self.center.y))
                    {
                        setImage(image: #imageLiteral(resourceName: "x"))
                        bDirection(OperationOrder.ODown,resultX,resultY,resultR)
                    }else{
                        setImage(image: #imageLiteral(resourceName: "s"))
                        bDirection(OperationOrder.OUp,resultX,resultY,resultR)
                        
                    }
                }
            }
//
//            UIView.animate(withDuration: 0.09999, animations: {
//                self.center = touchPoint
//            })
            self.setNeedsDisplay();
        }
    }
    
    func onRelease() -> Void {
        
            if updownEnable {
                setImage(image: #imageLiteral(resourceName: "weianxia"))
            }else{
                setImage(image: #imageLiteral(resourceName: "zuoyou"))
            }
        bDirection(OperationOrder.OStop,0,0,0)
    }
    
    func setImage(image:UIImage){
            UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
            image.draw(in:bounds)
            let nimage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            backgroundColor = UIColor(patternImage: nimage!)
    }
    
    
    /// 计算夹角
    ///
    /// - Parameter cpoint: 移动的角度
    /// - Returns: 返回计算出的角度结果
    func angleJudge(cpoint: CGPoint) -> CGFloat {
        
        let opoint = CGPoint(x: self.center.x,
                             y: self.center.y)
        let x1 = opoint.x - cpoint.x
        let y1 = opoint.y - cpoint.y
        let angle = atan(y1 / x1)
        return angle
    }
}
