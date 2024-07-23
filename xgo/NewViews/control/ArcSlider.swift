//
//  ArcSlider.swift
//  xgo
//
//  Created by Arther on 23.7.24.
//

import UIKit

class ArcSlider: UISlider {
    // 圆形轨道的半径
        private let trackRadius: CGFloat = 100.0
        
        // 滑块的半径
        private let thumbRadius: CGFloat = 15.0
        
        // 圆形轨道的中心位置
        private var trackCenter: CGPoint {
            return CGPoint(x: bounds.midX, y: bounds.midY)
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
            // 设置 Slider 的轨道图片为空，使用自定义绘制的圆形轨道
            self.setThumbImage(UIImage(), for: .normal)
            
            // 更新 Slider 的样式
            updateSliderStyle()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            // 更新 Slider 的样式
            updateSliderStyle()
        }
        
        private func updateSliderStyle() {
            // 绘制圆形轨道的 CAShapeLayer
            let trackLayer = CAShapeLayer()
            trackLayer.path = UIBezierPath(arcCenter: trackCenter, radius: trackRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true).cgPath
            trackLayer.strokeColor = tintColor.cgColor // 设置轨道的颜色
            trackLayer.fillColor = UIColor.clear.cgColor // 设置填充色为空，只显示边框
            trackLayer.lineWidth = 10.0 // 设置轨道的线宽
            layer.addSublayer(trackLayer)
            
            // 计算滑块的位置
            updateThumbPosition()
        }
        
        private func updateThumbPosition() {
            // 计算当前值对应的角度
            let angle = CGFloat(value / maximumValue) * CGFloat(2 * Double.pi)
            
            // 计算滑块的位置
            let thumbX = trackCenter.x + trackRadius * cos(angle)
            let thumbY = trackCenter.y + trackRadius * sin(angle)
            
            // 设置滑块的位置
            let thumbCenter = CGPoint(x: thumbX, y: thumbY)
//            setThumbCenter(thumbCenter, animated: true)
        }
        
        override func setValue(_ value: Float, animated: Bool) {
            super.setValue(value, animated: animated)
            
            // 更新滑块的位置
            updateThumbPosition()
        }
        
        override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
            // 计算触摸点在轨道上的位置
            let touchPoint = touch.location(in: self)
            
            // 计算触摸点相对于圆心的角度
            let deltaX = touchPoint.x - trackCenter.x
            let deltaY = touchPoint.y - trackCenter.y
            var angle = atan2(deltaY, deltaX)
            
            // 调整角度范围为 0 到 2π
            if angle < 0 {
                angle += CGFloat(2 * Double.pi)
            }
            
            // 计算当前值
            let progress = angle / CGFloat(2 * Double.pi)
            let newValue = Float(progress) * maximumValue
            
            // 更新 Slider 的值
            setValue(newValue, animated: true)
            
            return true
        }
        
        override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
            // 更新滑块的位置
            let touchPoint = touch.location(in: self)
            let deltaX = touchPoint.x - trackCenter.x
            let deltaY = touchPoint.y - trackCenter.y
            var angle = atan2(deltaY, deltaX)
            
            // 调整角度范围为 0 到 2π
            if angle < 0 {
                angle += CGFloat(2 * Double.pi)
            }
            
            // 计算当前值
            let progress = angle / CGFloat(2 * Double.pi)
            let newValue = Float(progress) * maximumValue
            
            // 更新 Slider 的值
            setValue(newValue, animated: true)
            
            return true
        }
}

