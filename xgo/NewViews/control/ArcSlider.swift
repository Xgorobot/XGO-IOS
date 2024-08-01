//
//  ArcSlider.swift
//  xgo
//
//  Created by Arther on 23.7.24.
//

import UIKit

class ArcSlider: UIControl {
    private let trackLayer = CAShapeLayer()
    private let thumbLayer = CAShapeLayer()
    
    private var startAngle: CGFloat = 0.0
    private var endAngle: CGFloat = 0.0
    
    private var thumbRadius: CGFloat = 15.0
    private var thumbTintColor: UIColor = .blue
    
    private var thumbPosition: CGFloat = 0.0 {
        didSet {
            updateThumbPosition()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSlider()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSlider()
    }
    
    private func setupSlider() {
        backgroundColor = .clear
        
        startAngle = 0
        endAngle = CGFloat.pi / 4
        
        trackLayer.lineWidth = 10.0
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)
        
        thumbLayer.fillColor = thumbTintColor.cgColor
        layer.addSublayer(thumbLayer)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateTrackLayerPath()
        updateThumbPosition()
    }
    
    private func updateTrackLayerPath() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - thumbRadius
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        trackLayer.path = path.cgPath
    }
    
    private func updateThumbPosition() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - thumbRadius
        
        let angle = startAngle + (endAngle - startAngle) * thumbPosition
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        
        thumbLayer.path = UIBezierPath(arcCenter: CGPoint(x: x, y: y), radius: thumbRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - thumbRadius
        
        let translation = gesture.translation(in: self)
        let angle = atan2(translation.y, translation.x) + CGFloat.pi / 2
        
        var thumbPosition = (angle - startAngle) / (endAngle - startAngle)
        thumbPosition = max(0.0, min(thumbPosition, 1.0))
        
        self.thumbPosition = thumbPosition
        
        sendActions(for: .valueChanged)
    }
}
