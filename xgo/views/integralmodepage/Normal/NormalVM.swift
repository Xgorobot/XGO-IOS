//
//  NormalVM.swift
//  xgo
//
//  Created by 袁文麟 on 2021/9/2.
//

import Foundation
import RxSwift

class NormalVM {
    
    struct Input {
        let setHeight: Observable<Float>
    }
    
    struct Output {
    
    }
    
    var output: Output
    
    init(input: Input) {
        output = Output()
    }
    
    
}
