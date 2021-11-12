//
//  XGOSlider.swift
//  xgo
//
//  Created by 袁文麟 on 2021/11/11.
//

import Foundation
import UIKit

//带有刻度的自定义滑块
class XGOSlider: UISlider {
    //刻度位置集合
    var markPositions:[CGFloat] = []
    //刻度颜色
    var markColor: UIColor?
    //刻度宽度
    var markWidth: CGFloat?
    //左侧轨道的颜色
    var leftBarColor: UIColor?
    //右侧轨道的颜色
    var rightBarColor:UIColor?
    //轨道高度
    var barHeight: CGFloat?
     
    //初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
         
        //设置样式的默认值
        self.markColor = UIColor(red: 248/255.0, green: 211/255.0, blue: 72/255.0,
                                 alpha: 0.7)
        self.markPositions = [10,20,30,40,50,60,70,80,90]
        self.markWidth = 1.0
        self.leftBarColor = UIColor(red: 116/255.0, green: 250/255.0, blue: 249/255.0,
                                    alpha: 0.8)
        self.rightBarColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0,
                                     alpha: 0.0)
        self.barHeight = 12
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       //设置样式的默认值
       self.markColor = UIColor(red: 248/255.0, green: 211/255.0, blue: 72/255.0,
                                alpha: 0.7)
       self.markPositions = [10,20,30,40,50,60,70,80,90]
       self.markWidth = 1.0
       self.leftBarColor = UIColor(red: 116/255.0, green: 250/255.0, blue: 249/255.0,
                                   alpha: 0.8)
        self.rightBarColor = UIColor.white
       self.barHeight = 12
    }
     
     
    override func draw(_ rect: CGRect) {
        super.draw(rect)
 
        //得到左侧带有刻度的轨道图片（注意：图片不拉伸）
        let leftTrackImage = createTrackImage(rect: rect, barColor: self.leftBarColor!)
            .resizableImage(withCapInsets: .zero)
         
        //得到右侧带有刻度的轨道图片
        let rightTrackImage = createTrackImage(rect: rect, barColor: self.rightBarColor!)
         
        //将前面生产的左侧、右侧轨道图片设置到UISlider上
        self.setMinimumTrackImage(leftTrackImage, for: .normal)
        self.setMaximumTrackImage(rightTrackImage, for: .normal)
    }
     
    //生成轨道图片
    func createTrackImage(rect: CGRect, barColor:UIColor) -> UIImage {
        //开始图片处理上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
         
        //绘制轨道背景
        context.setLineCap(.round)
        context.setLineWidth(self.barHeight!)
        context.move(to: CGPoint(x:self.barHeight!/2, y:rect.height/2))
        context.addLine(to: CGPoint(x:rect.width-self.barHeight!/2, y:rect.height/2))
        context.setStrokeColor(barColor.cgColor)
        context.strokePath()
         
//        //绘制轨道上的刻度
//        for i in 0..<self.markPositions.count {
//            context.setLineWidth(self.markWidth!)
//            let position: CGFloat = self.markPositions[i]*rect.width/100.0
//            context.move(to: CGPoint(x:position, y: rect.height/2-self.barHeight!/2+1))
//            context.addLine(to: CGPoint(x:position, y:rect.height/2+self.barHeight!/2-1))
//            context.setStrokeColor(self.markColor!.cgColor)
//            context.strokePath()
//        }
         
        //得到带有刻度的轨道图片
        let trackImage = UIGraphicsGetImageFromCurrentImageContext()!
        //结束上下文
        UIGraphicsEndImageContext()
        return trackImage
    }
}
