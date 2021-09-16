//
//  HomePageCollectionViewCell.swift
//  xgo
//
//  Created by 袁文麟 on 2021/7/28.
//

import UIKit

class HomePageCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var bg_item_homepage: UIView!
    @IBOutlet weak var icon_item_homepage: UIImageView!
    @IBOutlet weak var title_homepage_title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        bg_item_homepage.backgroundColor = UIColor.lightGray
    }

}
