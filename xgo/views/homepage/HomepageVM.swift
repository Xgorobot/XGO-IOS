//
//  HomepageVM.swift
//  xgo
//
//  Created by 袁文麟 on 2021/7/17.
//

import Foundation
import RxSwift

class HomepageVM {
    
    struct Input {
        let show: Observable<Void>
//        let selectSubitem: Observable<Void>
    }
    struct Output {
        var showResult: Observable<String>!
//        var selectResult: Observable<Void>!
    }
    
    var output: Output
    
    init(input: Input) {
        output = Output()
        output.showResult = input.show
            .flatMapLatest {(void) -> Observable<String> in
                return HomepageService.selectLanguage()
            }
    }
    
    
}
