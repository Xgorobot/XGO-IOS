//
//  Utils.swift
//  RxDemo
//
//  Created by jerry on 2017/11/8.
//  Copyright © 2017年 jerry. All rights reserved.
//

import Foundation
import RxSwift
let ExampleError = NSError.init(domain: "RxExampleError", code: 0, userInfo: ["msg":"这是一个示例错误"])
var GlobalDisposeBag = DisposeBag()
func clearGlobalDisposeBag(){
    GlobalDisposeBag = DisposeBag()
}

func delay(_ delayTime: TimeInterval, _ action: @escaping () -> Void){
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: action)
}
func curDateString(_ format: String) -> String{
    return { (format: String) -> DateFormatter in
        let df = DateFormatter.init()
        df.dateFormat = format
        return df
        }(format).string(from: Date())
}
