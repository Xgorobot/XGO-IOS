//
//  ControlImageUtil.swift
//  xgo
//
//  Created by 袁文麟 on 2021/11/12.
//

import Foundation
import UIKit

func getPowerImage(power: Int) -> UIImage{
    let position = power*14/255
    return UIImage(named: "dianliang\(position)")!
}
func getSpeedImage(speed: Int) -> UIImage{
    let position = speed*14/100
    return UIImage(named: "sudu\(position)")!
}
