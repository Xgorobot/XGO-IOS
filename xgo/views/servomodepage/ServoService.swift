//
//  ServoService.swift
//  xgo
//
//  Created by 袁文麟 on 2021/7/17.
//

import Foundation
import RxSwift

class ServoService {
    static func selectLanguage() -> Observable<String>{
        return Observable.create { (anyObserver) -> Disposable in
            anyObserver.onNext("测试onNext")
            anyObserver.onCompleted()
            return Disposables.create()
        }
    }
}
