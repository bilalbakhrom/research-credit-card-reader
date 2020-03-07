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


extension UIColor {
    
    @nonobjc class var primaryTextColor: UIColor {
        UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
    }
    
    @nonobjc class var primaryFillColor: UIColor {
        UIColor.white
    }
    
    @nonobjc class var secondaryColor: UIColor {
        UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
    }
    
    @nonobjc class var tertiaryColor: UIColor {
        UIColor(red: 174/255, green: 174/255, blue: 178/255, alpha: 1)
    }
    
    @nonobjc class var buttonBackgroundColor: UIColor {
        UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
    }

    @nonobjc class var deactiveTextColor: UIColor {
        UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
    }
    
    @nonobjc class var ligthDividerColor: UIColor {
        UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
    }
    
    @nonobjc class var darkDividerColor: UIColor {
        UIColor(red: 99/255, green: 99/255, blue: 102/255, alpha: 1)
    }
}
