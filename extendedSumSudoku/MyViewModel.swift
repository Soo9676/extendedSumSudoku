//
//  MyViewModel.swift
//  extendedSumSudoku
//
//  Created by Soo J on 2022/09/05.
//

import Foundation

class MyViewModel {
    
    var numberOfRows: Observable<Int> = Observable(3)
    var numberOfColumns: Observable<Int> = Observable(3)
}

class Observable<T> {
    var value: T {
        didSet {
            //값을 받아서 특정 행동 수행
            self.listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    var listener: ((T) -> Void)?
}
