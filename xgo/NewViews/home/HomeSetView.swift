//
//  HomeSetView.swift
//  xgo
//
//  Created by Arther on 18.7.24.
//

import UIKit

class HomeSetView: UIView {
    
    var about: (() -> ())?
    var set: (() -> ())?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func aboutAction(_ sender: Any) {
        self.about?()
    }
    
    @IBAction func setAction(serder: Any) {
        self.set?()
    }
}
