//
//  TextFieldViewInstaller.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

import UIKit

protocol TextFieldViewInstaller: ViewInstaller {
    var topLine: UIView! {get set}
    var bottomLine: UIView! {get set}
    var descriptionLabel: UILabel! {get set}
    
    var descriptionLabelTopAnchor: NSLayoutConstraint! {get set}
    var descriptionLabelCenterYAnchor: NSLayoutConstraint! {get set}
}

extension TextFieldViewInstaller  {
    
    func initSubviews() {
        topLine = UIView()
        topLine.backgroundColor = .ligthDividerColor
        topLine.translatesAutoresizingMaskIntoConstraints = false
        
        bottomLine = UIView()
        bottomLine.backgroundColor = .ligthDividerColor
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        descriptionLabel.textColor = .secondaryColor
        descriptionLabel.isHidden = true
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func embedSubviews() {
        mainView.addSubview(topLine)
        mainView.addSubview(bottomLine)
        mainView.addSubview(descriptionLabel)
    }
    
    func addSubviewsConstraints() {
        
        descriptionLabelCenterYAnchor = descriptionLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor)
        descriptionLabelCenterYAnchor.isActive = true
        
        descriptionLabelTopAnchor = descriptionLabel.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: DIM.Header.top)
        
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: mainView.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: DIM.Line.leading),
            topLine.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: DIM.Line.height),
            
            bottomLine.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            bottomLine.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: DIM.Line.leading),
            bottomLine.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: DIM.Line.height),

            descriptionLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: DIM.Header.leading),
            descriptionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: mainView.trailingAnchor, constant: -DIM.Header.trailing),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
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
