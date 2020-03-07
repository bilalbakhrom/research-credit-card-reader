//
//  Dynamic.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

import UIKit

class Dynamic<T> {
    
    typealias Listener = (T) -> Void
    
    /// Listener storage object
    private var listener: Listener?
    
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.value)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    /// Added listener will be called, whenever the value changes
    func bind(_ listener: @escaping Listener) {
        self.listener = listener
    }
    
    /// Added listener will be called, whenever the value changes and immediately after closure set
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
