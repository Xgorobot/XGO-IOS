//
//  NormalService.swift
//  xgo
//
//  Created by 袁文麟 on 2021/9/2.
//

import Foundation

import RxSwift

class NormalService {
    static func selectLanguage() -> Observable<String>{
        return Observable.create { (anyObserver) -> Disposable in
            anyObserver.onNext("测试onNext")
            anyObserver.onCompleted()
            return Disposables.create()
        }
    }
}
