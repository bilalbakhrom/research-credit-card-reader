//
//  String.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

import UIKit

extension UIView {
    
    func dropShadow(_ x: CGFloat, _ y: CGFloat, _ blur: CGFloat, _ color: UIColor?, _ alpha: Float, spread: CGFloat = 0) {
        layer.shadowColor = color?.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur/2
        let rect = bounds.insetBy(dx: -spread, dy: -spread)
        layer.shadowPath = (spread > 0) ? UIBezierPath(rect: rect).cgPath : nil
    }
    
    func dropShadow(_ x: CGFloat, _ y: CGFloat, _ blur: CGFloat, _ color: UIColor?, _ alpha: Float, spread: CGFloat = 0, cornerRadius: CGFloat, fillColor: UIColor = .white) {
        let shadowLayer = CAShapeLayer()
        let rect = bounds.insetBy(dx: -spread, dy: -spread)
        shadowLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = color?.cgColor
        shadowLayer.shadowOpacity = alpha
        shadowLayer.shadowOffset = CGSize(width: x, height: y)
        shadowLayer.shadowRadius = blur/2
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func showShadow(_ alpha: Float = 0.3) {
        layer.shadowOpacity = alpha
    }
    
    func hideShadow() {
        layer.shadowOpacity = 0.0
    }
    
}


extension String {
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    var makeReadableCardNumber: String {
        var formattedCardNumber = String()
        for (index, character) in self.enumerated() {
            formattedCardNumber += String(character)
            formattedCardNumber += ([3, 7, 11].contains(index)) ? " " : ""
        }
        return formattedCardNumber
    }
    
    var makeReadableExpireDateForCard: String {
        var formattedExpireDate = String()
        for (index, character) in self.enumerated() {
            formattedExpireDate += String(character)
            formattedExpireDate += ([1].contains(index)) ? " / " : ""
        }
        return formattedExpireDate
    }
}
