//
//  HomeUpSetView.swift
//  xgo
//
//  Created by Arther on 18.7.24.
//

import UIKit

class HomeUpSetView: UIView {
    
    var gujian: (() -> ())?
    var biaoding: (() -> ())?
    var shezhi: (() -> ())?
    var about: (() -> ())?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func gujianAction(_ sender: Any) {
        self.gujian?()
    }
    
    @IBAction func biaodingAction(_ sender: Any) {
        self.biaoding?()
    }
    
    @IBAction func shezhiAction(_ sender: Any) {
        self.shezhi?()
    }
    
    @IBAction func aboutAction(_ sender: Any) {
        self.about?()
    }
    
    
}
