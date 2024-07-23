//
//  ActionBarsView.swift
//  摇杆View
//
//  Created by user on 2018/5/18.
//  Copyright © 2018年 iwall. All rights reserved.
//

import UIKit

class RockerBarsView: UIView {

    var actionBar:RockerBars?
    var bDirection:bDirection?

    var backgroundImage:UIImageView?
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func layoutSubviews() {
        
    }
    
    func setUp() {
        
        backgroundImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
//        let image = #imageLiteral(resourceName: "quan")
        backgroundImage?.image = UIImage(named: "")
        self.addSubview(backgroundImage!)
//        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
//        image.draw(in:bounds)
//        let nimage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        backgroundColor = UIColor(patternImage: nimage!)

        actionBar = RockerBars.init(frame: CGRect(x: frame.size.width / 2 - frame.size.width / 8,
                                                  y: frame.size.height / 2 - frame.size.width / 8,
                                                  width: frame.size.width / 4,
                                                  height: frame.size.height / 4))
        actionBar?.layer.cornerRadius = (actionBar?.frame.width)! / 2
        actionBar?.clipsToBounds = true;
        actionBar?.bDirection = bDirection
        addSubview(actionBar!)
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        actionBar?.onMoved(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        actionBar?.onMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        actionBar?.onRelease(touches, with: event)
    }
}
