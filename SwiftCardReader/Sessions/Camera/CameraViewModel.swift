//
//  CameraViewModel.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

protocol CameraBusinessLogic {
    var didSetupCardAttribute: Dynamic<Bool> { get }
    
    var cardNumber: String { get }
    
    var expireDate: String { get }
    
    var isValid: Bool { get }
    
    func set(cardNumber: String)
    
    func set(expireDate: String)
}

class CameraViewModel: CameraBusinessLogic {
    
    let didSetupCardAttribute: Dynamic<Bool> = Dynamic(false)
    
    private(set) var cardNumber: String = ""
    private(set) var expireDate: String = ""
    
    private let CARD_NUMBER_MAX_COUNT = 16
    private let CARD_EXPIRE_DATE_MAX_COUNT = 4
    
    var isValid: Bool {
        cardNumber.count == CARD_NUMBER_MAX_COUNT && expireDate.count == CARD_EXPIRE_DATE_MAX_COUNT
    }
    
    func set(cardNumber: String) {
        self.cardNumber = cardNumber
        didSetupCardAttribute.value = isValid
    }
    
    func set(expireDate: String) {
        self.expireDate = expireDate
        didSetupCardAttribute.value = isValid
    }
    
}
