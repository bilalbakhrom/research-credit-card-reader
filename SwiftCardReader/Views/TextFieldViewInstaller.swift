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

    var captionLabel: UILabel! {get set}
    
    var captionTopAnchor: NSLayoutConstraint! {get set}
    var captionCenterYAnchor: NSLayoutConstraint! {get set}
}

extension TextFieldViewInstaller  {
    
    func initSubviews() {
        
        mainView.layer.borderWidth = 2.0
        mainView.layer.cornerRadius = 52/2
        mainView.layer.borderColor = UIColor.buttonBackgroundColor.withAlphaComponent(0.5).cgColor
        
        
        captionLabel = UILabel()
        captionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        captionLabel.textColor = .secondaryColor
        captionLabel.isHidden = true
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func embedSubviews() {
        mainView.addSubview(captionLabel)
    }
    
    func addSubviewsConstraints() {
        
        captionCenterYAnchor = captionLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor)
        captionCenterYAnchor.isActive = true
        
        captionTopAnchor = captionLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: DIM.Header.top)
        
        NSLayoutConstraint.activate([
            captionLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: DIM.Header.leading),
            captionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
        ])
    }
    
}

fileprivate enum DIM {
    struct Header {
        static let leading: CGFloat = 20.0
        static let top: CGFloat = 8.0
    }
}
