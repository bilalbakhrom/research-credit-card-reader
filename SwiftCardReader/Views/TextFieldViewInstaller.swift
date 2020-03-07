//
//  TextFieldViewInstaller.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

import UIKit

protocol TextFieldViewInstaller: ViewInstaller {
    typealias Attributes = [NSAttributedString.Key: Any]
    typealias Placeholder = String
    typealias Caption = String
    
    var topLine: UIView! {get set}
    var bottomLine: UIView! {get set}
    var captionLabel: UILabel! {get set}
    
    var captionTopAnchor: NSLayoutConstraint! {get set}
    var captionCenterYAnchor: NSLayoutConstraint! {get set}
}

extension TextFieldViewInstaller  {
    
    func initSubviews() {
        topLine = UIView()
        topLine.backgroundColor = .ligthDividerColor
        topLine.translatesAutoresizingMaskIntoConstraints = false
        
        bottomLine = UIView()
        bottomLine.backgroundColor = .ligthDividerColor
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        captionLabel = UILabel()
        captionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        captionLabel.textColor = .secondaryColor
        captionLabel.isHidden = true
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func embedSubviews() {
        mainView.addSubview(topLine)
        mainView.addSubview(bottomLine)
        mainView.addSubview(captionLabel)
    }
    
    func addSubviewsConstraints() {
        
        captionCenterYAnchor = captionLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor)
        captionCenterYAnchor.isActive = true
        
        captionTopAnchor = captionLabel.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: DIM.Header.top)
        
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: mainView.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: DIM.Line.leading),
            topLine.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: DIM.Line.height),
            
            bottomLine.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            bottomLine.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: DIM.Line.leading),
            bottomLine.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: DIM.Line.height),

            captionLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: DIM.Header.leading),
            captionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: mainView.trailingAnchor, constant: -DIM.Header.trailing),
            captionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
        ])
    }
    
}


// MARK: - Layout sizes

fileprivate struct DIM {
    
    struct Line {
        static let leading: CGFloat = Ratio.compute(percentage: 0.04, accordingTo: .width)
        static let height: CGFloat = 1.0
    }
    
    struct Header {
        static let leading: CGFloat = Ratio.compute(percentage: 0.04, accordingTo: .width)
        static let trailing: CGFloat = Ratio.compute(percentage: 0.04, accordingTo: .width)
        static let top: CGFloat = Ratio.compute(percentage: 10/812, accordingTo: .height)
    }
    
    struct Eye {
        static let width: CGFloat = Ratio.compute(percentage: 0.064, accordingTo: .width)
        static let height: CGFloat = Ratio.compute(percentage: 0.064, accordingTo: .width)
    }
}
