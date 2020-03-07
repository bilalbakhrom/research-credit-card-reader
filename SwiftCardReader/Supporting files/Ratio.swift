//
//  Ratio.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

import UIKit

class Ratio {
    
    /// Block init
    private init() {}
     
    // MARK: - METHODS
    
    @nonobjc class func font(ofSize size: CGFloat) -> CGFloat {
        return compute(size, accordingTo: .width)
    }
    
    @nonobjc class func compute(_ size: CGFloat, accordingTo side: RatioSide) -> CGFloat {
        switch side {
        case .height:
            return round(size * Estimate.heightRatio)
            
        case .width:
            return round(size * Estimate.widthRatio)
        }
    }
    
    @nonobjc class func compute(percentage: CGFloat, accordingTo side: RatioSide) -> CGFloat {
        let actualSize: CGSize = UIScreen.main.bounds.size
        switch side {
        case .height:
            return actualSize.height * percentage
            
        case .width:
            return actualSize.width * percentage
        }
    }
    
    @nonobjc class func compute(_ size: CGFloat, accordingTo side: RatioSide) -> CGSize {
        var length: CGFloat
        
        switch side {
        case .height:
            length = round(size * Estimate.heightRatio)
            
        case .width:
            length = round(size * Estimate.widthRatio)
        }
        
        return CGSize(width: length, height: length)
    }
    
    /**
        Recalculates width and height
     
        Recalculates width according to device width and height according to device height
    */
    @nonobjc class func compute(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        let scaledWidth: CGFloat = compute(width, accordingTo: .width)
        let scaledHeight: CGFloat = compute(height, accordingTo: .height)
        return CGSize(width: scaledWidth, height: scaledHeight)
    }
    
}


// MARK: - RatioSide

extension Ratio {
    
    enum RatioSide {
        case width
        case height
    }
}


fileprivate struct Estimate {
    private static let designedSize = CGSize(width: 375, height: 812)
    private static let actualSize = UIScreen.main.bounds.size
    
    static var heightRatio: CGFloat { actualSize.height/designedSize.height }
    static var widthRatio: CGFloat { actualSize.width/designedSize.width }
}
