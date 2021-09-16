//
//  ActionBars.swift
//  摇杆view
//
//  Created by user on 2018/5/18.
//  Copyright © 2018年 iwall. All rights reserved.
//

import UIKit

enum OperationOrder {
    case OUp
    case ODown
    case OLeft
    case ORight
    case OStop
}

typealias bDirection = (_ dir:OperationOrder , _ x:CGFloat ,_ y:CGFloat ,_ r:CGFloat) -> ()

class RockerBars: UIView {
    
    var tw: CGFloat = 0.0
    var th: CGFloat = 0.0
    
    var bDirection:bDirection!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let image = #imageLiteral(resourceName: "yuan")
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        image.draw(in:bounds)
        let nimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        backgroundColor = UIColor(patternImage: nimage!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 计算夹角
    ///
    /// - Parameter cpoint: 移动的角度
    /// - Returns: 返回计算出的角度结果
    func angleJudge(cpoint: CGPoint) -> CGFloat {
        
        let opoint = CGPoint(x: (self.superview?.frame.size.width)! / 2,
                             y: (self.superview?.frame.size.height)! / 2)
        let x1 = opoint.x - cpoint.x
        let y1 = opoint.y - cpoint.y
        
        let angle = atan(y1 / x1)
        
        return angle
    }
    
    func onMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        tw = (self.superview?.frame.size.width)! / 2
        th = (self.superview?.frame.size.height)! / 2
        if(touch != nil){
            let lastTouch = touch!.location(in: self.superview)

            var touchPoint = CGPoint(x: lastTouch.x, y: lastTouch.y)
            
            var angle = angleJudge(cpoint: CGPoint(x: touchPoint.x, y: touchPoint.y))
            
            let opoint = CGPoint(x: (self.superview?.frame.size.width)! / 2,
                                 y: (self.superview?.frame.size.height)! / 2)
            let xP = opoint.x - touchPoint.x
            let yP = opoint.y - touchPoint.y
            
            let radius = sqrt(pow(xP, 2) + pow(yP, 2))
            let frameRadius = (self.superview?.frame.width)! / 2
            var resultR = radius / frameRadius
            resultR = max(0, resultR)
            resultR = min(1, resultR)
            var resultX = xP/frameRadius
            resultX = max(-1, resultX)
            resultX = min(1, resultX)
            var resultY = yP/frameRadius
            resultY = max(-1, resultY)
            resultY = min(1, resultY)
            
            touchPoint.y = max(tw - tw * abs(sin(abs(angle))), touchPoint.y);
            touchPoint.y = min(tw + tw * abs(sin(abs(angle))), touchPoint.y);
            touchPoint.x = max(tw - tw * abs(cos(abs(angle))), touchPoint.x);
            touchPoint.x = min(tw + tw * abs(cos(abs(angle))), touchPoint.x);
            
            angle = angle * 180 / .pi

            if (angle >= -45 && angle <= 45)
            {
                if(Int(touchPoint.x) > Int((self.superview?.frame.size.width)! / 2))
                {
                    bDirection(OperationOrder.ORight,resultX,resultY,resultR)
                }else{
                    bDirection(OperationOrder.OLeft,resultX,resultY,resultR)
                }
            }
            
            if ((angle > 45 && angle <= 90) || (angle < -45 && angle >= -90))
            {
                if(Int(touchPoint.y) > Int((self.superview?.frame.size.height)! / 2))
                {
                    bDirection(OperationOrder.ODown,resultX,resultY,resultR)
                }else{
                    bDirection(OperationOrder.OUp,resultX,resultY,resultR)
                }
            }
            
            UIView.animate(withDuration: 0.09999, animations: {
                self.center = touchPoint
            })
            self.setNeedsDisplay();
        }
    }
    
    func onRelease(_ touches: Set<UITouch>, with event: UIEvent?) {
        center = CGPoint(x: (self.superview?.frame.size.width)! / 2,
                         y: (self.superview?.frame.size.height)! / 2)
        bDirection(OperationOrder.OStop,0,0,0)
   }
    
}
