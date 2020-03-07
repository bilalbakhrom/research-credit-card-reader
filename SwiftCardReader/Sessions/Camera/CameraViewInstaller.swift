//
//  CameraViewInstaller.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

import UIKit

protocol CameraViewInstaller: ViewInstaller {
    var capturePreviewView: UIView! {get set}
    var dismissButton: UIButton! {get set}
}

extension CameraViewInstaller {
    
    func initSubviews() {
        capturePreviewView = UIView()
        capturePreviewView.backgroundColor = .black
        capturePreviewView.translatesAutoresizingMaskIntoConstraints = false
        
        dismissButton = UIButton()
        dismissButton.backgroundColor = .white
        dismissButton.layer.cornerRadius = DIM.Button.height/2
        dismissButton.dropShadow(0, 7, 15, .black, 0.2)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func embedSubviews() {
        mainView.addSubview(capturePreviewView)
        mainView.addSubview(dismissButton)
    }
    
    func addSubviewsConstraints() {
        NSLayoutConstraint.activate([
            capturePreviewView.topAnchor.constraint(equalTo: mainView.topAnchor),
            capturePreviewView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            capturePreviewView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            capturePreviewView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            
            dismissButton.heightAnchor.constraint(equalToConstant: DIM.Button.height),
            dismissButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -DIM.Button.horizontal),
            dismissButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: DIM.Button.horizontal),
            dismissButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -DIM.Button.bottom)
        ])
    }
    
    func localizeText() {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17, weight: .medium), .foregroundColor: UIColor.buttonBackgroundColor]
        let attributedTitle = NSAttributedString(string: "Cancel", attributes: attributes)
        dismissButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
}


fileprivate enum DIM {
    struct Button {
        static let horizontal = Ratio.compute(percentage: 16/375, accordingTo: .width)
        static let bottom = Ratio.compute(percentage: 40/812, accordingTo: .height)
        static let height: CGFloat = 48.0
    }
}
