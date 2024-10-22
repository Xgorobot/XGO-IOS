//
//  HomeUpSetView.swift
//  xgo
//
//  Created by Arther on 18.7.24.
//

import UIKit

class HomeUpSetView: UIView {
    
    @IBOutlet weak var gujianLabel: UILabel!
    @IBOutlet weak var biaodingLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
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
