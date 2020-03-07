//
//  MainViewInstaller.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

import UIKit

protocol MainViewInstaller: ViewInstaller {
    var cardNumberField: TextField! {get set}
    var cardExpireDate: TextField! {get set}
    var stackView: UIStackView! {get set}
    var scanButton: UIButton! {get set}
}


extension MainViewInstaller {
    
    func initSubviews() {
        mainView.backgroundColor = .white
        
        cardNumberField = TextField()
        cardNumberField.keyboardType = .numberPad
        cardNumberField.translatesAutoresizingMaskIntoConstraints = false
        
        cardExpireDate = TextField()
        cardExpireDate.keyboardType = .numberPad
        cardExpireDate.hideTopLine()
        cardExpireDate.translatesAutoresizingMaskIntoConstraints = false
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scanButton = UIButton(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width-DIM.Button.horizontal*2,
                                                                      height: DIM.Button.height)))
        scanButton.backgroundColor = .buttonBackgroundColor
        scanButton.imageView?.contentMode = .scaleAspectFit
        scanButton.layer.cornerRadius = DIM.Button.height/2
        scanButton.dropShadow(0, 7, 15, .buttonBackgroundColor, 0.16)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func embedSubviews() {
        mainView.addSubview(stackView)
        mainView.addSubview(scanButton)
        stackView.addArrangedSubview(cardNumberField)
        stackView.addArrangedSubview(cardExpireDate)
    }
    
    func addSubviewsConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            
            scanButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: DIM.Button.top),
            scanButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -DIM.Button.horizontal),
            scanButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: DIM.Button.horizontal),
            scanButton.heightAnchor.constraint(equalToConstant: DIM.Button.height),
        ])
    }
    
    func localizeText() {
        cardNumberField.set(placeholder: "Enter card number")
        cardNumberField.caption = "Enter card number"
        
        cardExpireDate.set(placeholder: "Enter expire date")
        cardExpireDate.caption = "Enter expire date"
        
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17, weight: .medium), .foregroundColor: UIColor.white]
        let attributedTitle = NSAttributedString(string: "Scan card", attributes: attributes)
        scanButton.set(image: UIImage(named: "scan"), attributedTitle: attributedTitle, at: .right, width: 25, state: .normal)
    }
    
}


fileprivate struct DIM {
    
    struct Button {
        static let horizontal = Ratio.compute(percentage: 16/375, accordingTo: .width)
        static let top = Ratio.compute(percentage: 40/812, accordingTo: .height)
        static let height: CGFloat = 52.0
    }
    
}
