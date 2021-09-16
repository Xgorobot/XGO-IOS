//
//  ScanTableCell.swift
//  findx
//
//  Created by lzx on 2018/8/8.
//  Copyright © 2018年 wulianedu. All rights reserved.
//

import UIKit

class ScanTableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var rssiImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
