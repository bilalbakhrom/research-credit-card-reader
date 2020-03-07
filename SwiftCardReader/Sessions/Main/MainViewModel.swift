//
//  MainViewModel.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

protocol MainBusinessLogic {
    var number: Dynamic<String> {get}
    var expireDate: Dynamic<String> {get}
}

class MainViewModel: MainBusinessLogic {
    let number: Dynamic<String> = Dynamic("")
    
    let expireDate: Dynamic<String> = Dynamic("")
    
}
