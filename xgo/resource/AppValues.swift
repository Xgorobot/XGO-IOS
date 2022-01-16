//
//  AppValues.swift
//  findx
//
//  Created by lzx on 2018/8/8.
//  Copyright © 2018年 wulianedu. All rights reserved.
//

import Foundation
import UIKit

/*********颜色***********/
//RGB转换
func RGB(r:CGFloat,g:CGFloat,b:CGFloat) ->UIColor{
    //
    return UIColor(red: r/225.0, green: g/225.0, blue: b/225.0, alpha: 1.0)
}

//主题色
public let THEME_COLOR=UIColor(red: 20/255.0, green: 19/255.0, blue: 23/255.0, alpha: 1.0)
//背景色
public let BG_COLOR=UIColor(red: 23/225.0, green: 23/225.0, blue: 27/225.0, alpha: 1.0)
//分割线颜色
public let LINE_COLOR=UIColor(valueRGB: 0x3e4551)
//分割线颜色
public let TEXT_COLOR=UIColor(valueRGB: 0x92a1b6)
//分割线颜色
public let TEXT_HIGHTLIGHT=UIColor(valueRGB: 0x00dffa)

/****尺寸*****/

//设备屏幕尺寸
public let SCREEN_WIDTH=UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT=UIScreen.main.bounds.size.height

//获取视图尺寸
public func VIEW_WIDTH(view:UIView)->CGFloat{
    return view.frame.size.width
}
public func VIEW_HEIGHT(view:UIView)->CGFloat{
    return view.frame.size.height
}

var BLEMANAGER:FindBleManager?


 var DevOpen = false

