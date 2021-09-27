//
//  ControlBarsView.swift
//  xgo
//
//  Created by 袁文麟 on 2021/9/14.
//

import UIKit

class ControlLRBarsView: ControlBarsView {
    
    //    var tw: CGFloat = 0.0
    //    var th: CGFloat = 0.0
    //
    //    var bDirection:bDirection!
    //
    //    var updownEnable: Bool = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updownEnable = false
        setImage(image: #imageLiteral(resourceName: "zuoyou"))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updownEnable = false
        setImage(image: #imageLiteral(resourceName: "zuoyou"))
    }
    
}
