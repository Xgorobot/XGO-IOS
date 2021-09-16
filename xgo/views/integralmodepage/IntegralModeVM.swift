//
//  HomepageVM.swift
//  xgo
//
//  Created by 袁文麟 on 2021/7/17.
//

import Foundation
import RxSwift

class IntegralModeVM {
    
    struct Input {
        let show: Observable<Void>
    }
    struct Output {
        var showResult: Observable<String>!
    }
    
    var output: Output
    
    init(input: Input) {
        output = Output()
        output.showResult = input.show
            .flatMapLatest {(void) -> Observable<String> in
                return IntegralModeService.selectLanguage()
            }
    }
    
    
}
