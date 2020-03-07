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
    
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
}


extension String {
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    var withoutWhiteSpace: String {
        return self.replacingOccurrences(of: " ", with: "")
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


extension UIButton {
    
    enum Position: Int {
        case top, bottom, left, right
    }
    /// This method sets an image and title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    func set(image: UIImage?, title: String, titlePosition: Position, additionalSpacing: CGFloat, state: UIControl.State) {
        imageView?.contentMode = .center
        setImage(image, for: state)
        setTitle(title, for: state)
        titleLabel?.contentMode = .center
        adjust(title: title as NSString, at: titlePosition, with: additionalSpacing)
    }
    /// This method sets an image and an attributed title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button attributed title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    func set(image: UIImage?, attributedTitle title: NSAttributedString, at position: Position, width spacing: CGFloat, state: UIControl.State) {
        imageView?.contentMode = .center
        setImage(image, for: state)
        adjust(attributedTitle: title, at: position, with: spacing)
        titleLabel?.contentMode = .center
        setAttributedTitle(title, for: state)
    }
    
    // MARK: Private Methods
    private func adjust(title: NSString, at position: Position, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        
        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func adjust(attributedTitle: NSAttributedString, at position: Position, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        let titleSize = attributedTitle.size()
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func arrange(titleSize: CGSize, imageRect:CGRect, atPosition position: Position, withSpacing spacing: CGFloat) {
        switch (position) {
        case .top:
            titleEdgeInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            contentEdgeInsets = UIEdgeInsets(top: spacing / 2 + titleSize.height, left: -imageRect.width/2, bottom: 0, right: -imageRect.width/2)
        case .bottom:
            titleEdgeInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: -imageRect.width/2, bottom: spacing / 2 + titleSize.height, right: -imageRect.width/2)
        case .left:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageRect.width * 2), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
            contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
            
        case .right:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing / 2)
        }
    }
    
    func pulseAnimate(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.05, animations: {
            self.animationZoom(scaleX: 0.95, y: 0.95)
        }) { (_) in
            UIView.animate(withDuration: 0.05, animations: {
                self.transform = .identity
            }) { (_) in
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
}
