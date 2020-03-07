//
//  MainViewController.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MainViewInstaller {
    
    var cardNumberField: TextField!
    var cardExpireDate: TextField!
    var stackView: UIStackView!
    var scanButton: UIButton!
    var mainView: UIView { view }
    
    var viewModel: MainBusinessLogic! {
        didSet {
            load()
        }
    }
    
    func load() {
        setupSubviews()
        setupTargets()
        localizeText()
        title = "Card details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupTargets() {
        cardNumberField.addTarget(self, action: #selector(didChangeCardNumber(_:)), for: .editingChanged)
        cardNumberField.textFieldDelegate = self
        
        cardExpireDate.addTarget(self, action: #selector(didChangeCardExpireDate(_:)), for: .editingChanged)
        cardExpireDate.textFieldDelegate = self
        
        scanButton.addTarget(self, action: #selector(shouldDisplayCamera), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forceEndEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func forceEndEditing() {
        view.endEditing(true)
    }
    
    @objc private func didChangeCardNumber(_ textField: UITextField) {
        guard let card = textField.text?.withoutWhiteSpace else { return }
        guard card.count <= 16 else { textField.deleteBackward(); return }
        
        textField.text = card.makeReadableCardNumber
        viewModel.number.value = card
    }
    
    @objc private func didChangeCardExpireDate(_ textField: UITextField) {
        guard let expireDate = textField.text?.withoutWhiteSpace.replacingOccurrences(of: "/", with: "") else { return }
        guard expireDate.count <= 4 else {
            textField.deleteBackward()
            return
        }
        
        textField.text = expireDate.makeReadableExpireDateForCard
        viewModel.expireDate.value = expireDate
    }
    
    @objc private func shouldDisplayCamera() {
        scanButton.pulseAnimate {
            let controller = CameraViewController()
            controller.delegate = self
            controller.viewModel = CameraViewModel()
            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
    }
}


extension MainViewController: CameraViewControllerDelegate {
    
    func didRecognizeCard(number: String, expireDate: String) {
        viewModel.number.value = number
        viewModel.expireDate.value = expireDate
        cardNumberField.text = number.makeReadableCardNumber
        cardExpireDate.text = expireDate.makeReadableExpireDateForCard
    }
    
}


extension MainViewController: TextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardNumberField {
            let newPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            [4, 9, 14].forEach { if range.contains($0) { textField.text?.removeLast() } }
        } else if textField == cardExpireDate {
            let newPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            [4].forEach {
                if range.contains($0) {
                    textField.text?.removeLast()
                    textField.text?.removeLast()
                    textField.text?.removeLast()
                }
            }
        }
        return true
    }
    
}
