//
//  HomepageService.swift
//  xgo
//
//  Created by 袁文麟 on 2021/7/17.
//

import Foundation
import RxSwift

class ShowModeService {
//    let dataItem = ["趴下","站起","匍匐前进","转圈","原地踏步","蹲起","转动ROLL","转动PITCH","转动YAW","三轴联动","撒尿","坐下","招手","伸懒腰","波浪","摇摆","求食","找食物","握手"]
    
        /*运动模式 动作指令表，1-N为各个动作(0-N为十进制)
         0为默认站姿，1趴下，2站起，3匍匐前进，4转圈，5原地踏步，6蹲起，7转动Roll，
         8转动Pitch，9转动Yaw，10三轴转动，11撒尿，12坐下，13招手，14伸懒腰，15波浪，
         16左右摇摆，17求食，18找食物，19握手*/
    
    static func onBackClick() -> Observable<String>{
        return Observable.create { (anyObserver) -> Disposable in
            anyObserver.onNext("处理返回事件")
            anyObserver.onCompleted()
            return Disposables.create()
        }
    }
    static func setType(position:IndexPath) -> Observable<IndexPath>{
        let bytes = (position.row+1).hw_toByte()
        //TODO mengwei 表演模式的按钮事件
        FindControlUtil.actionType(type: bytes)
        return Observable.create { (anyObserver) -> Disposable in
            anyObserver.onNext(position)
            anyObserver.onCompleted()
            return Disposables.create()
        }
    }
}
