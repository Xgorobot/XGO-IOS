//
//  HomepageVM.swift
//  xgo
//
//  Created by 袁文麟 on 2021/7/17.
//

import Foundation
import RxSwift

class ShowModeVM {
    
    struct Input {
        let backClick: Observable<Void>
        let itemSelect: Observable<IndexPath>
    }
    struct Output {
        var back: Observable<String>!
        var itemSelectResult: Observable<String>!
    }
    
    var output: Output
    
    init(input: Input) {
        output = Output()
        output.back = input.backClick
            .flatMapLatest {(void) -> Observable<String> in
                return ShowModeService.onBackClick()
            }
        
//        let _ = input.itemSelect.subscribe { (position) in
//            ShowModeService.setType(position: position)
//        }
        output.itemSelectResult = input.itemSelect
            .flatMapLatest({ (indexPath) -> Observable<String> in
                return ShowModeService.setType(position: indexPath.row)
            })
       
    }
    
    
}
