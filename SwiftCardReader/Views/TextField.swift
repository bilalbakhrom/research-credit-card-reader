//
//  TextField.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

import UIKit

protocol TextFieldDelegate: class {
    func textFieldDidBeginEditing(_ textField: UITextField)
    func textFieldDidEndEditing(_ textField: UITextField)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

extension TextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) { }
    func textFieldDidEndEditing(_ textField: UITextField) {}
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { return true }
}


final class TextField: UITextField, TextFieldViewInstaller {
    
    var topLine: UIView!
    var bottomLine: UIView!
    var captionLabel: UILabel!
    var captionTopAnchor: NSLayoutConstraint!
    var captionCenterYAnchor: NSLayoutConstraint!
    weak var textFieldDelegate: TextFieldDelegate?
    
    var mainView: UIView { self }
    var shouldHideHeader: Bool {
        !(isFirstResponder || !(text?.isEmpty ?? true))
    }
    
    private var padding: UIEdgeInsets
    private var storedPlaceholder: Placeholder = ""
    private var placeholderFont: UIFont = .systemFont(ofSize: 15, weight: .medium)
    private var placeholderColor: UIColor = .secondaryColor
    private var receiver: Dynamic<String>!
    
    var caption: Caption {
        get {
            captionLabel.text ?? Caption()
        } set(newCaption) {
            captionLabel.text = newCaption
        }
    }
    
    override var text: String? {
        didSet {
            super.text = self.text
            guard let strongText = text, !strongText.isEmpty else { return }
            updateHeader()
            moveHeaderToTop { (_) in }
        }
    }
    
    override init(frame: CGRect) {
        let textPadding = Ratio.compute(percentage: 16/375, accordingTo: .width)
        padding = UIEdgeInsets(top: 0, left: textPadding, bottom: 0, right: textPadding)
        super.init(frame: .zero)
        setupNeeds()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Ratio.compute(percentage: 64/812, accordingTo: .height))
    }
    
    func setupNeeds() {
        setupSubviews()
        delegate = self
        textColor = .primaryTextColor
        font = .systemFont(ofSize: 15, weight: .medium)
        addTarget(self, action: #selector(onTextInput(_:)), for: .editingChanged)
    }
    
    func set(placeholder: Placeholder, font: UIFont = .systemFont(ofSize: 15, weight: .medium), textColor: UIColor = .secondaryColor) {
        storedPlaceholder = placeholder
        placeholderFont = font
        placeholderColor = textColor
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: textColor]
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
    
    func updateHeader() {
        padding.top = (shouldHideHeader) ? 0 : Ratio.compute(percentage: 22/812, accordingTo: .height)
        layoutIfNeeded()
        
        captionLabel.isHidden = shouldHideHeader
        if shouldHideHeader {
            set(placeholder: storedPlaceholder, font: placeholderFont, textColor: placeholderColor)
        } else {
            placeholder = nil
        }
    }
    
    func hideTopLine() {
        topLine.isHidden = true
    }
    
    func bind(_ receiver: Dynamic<String>) {
        self.receiver = receiver
    }
    
    @objc private func onTextInput(_ sender: UITextField) {
        guard let text = sender.text else { return }
        receiver?.value = text
    }
    
}


extension TextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidBeginEditing(textField)
        bottomLine.backgroundColor = .darkDividerColor
        captionLabel.isHidden = shouldHideHeader
        updateHeader()
        moveHeaderToTop { (_) in }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidEndEditing(textField)
        bottomLine.backgroundColor = .ligthDividerColor
        guard shouldHideHeader else { return }
        moveHeaderToCenter { (_) in
            self.updateHeader()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let result = textFieldDelegate?.textField(textField, shouldChangeCharactersIn: range, replacementString: string) else {
            return true
        }
        return result
    }
}


// MARK: - Basic animations

extension TextField {
    
    private func moveHeaderToTop(completion: @escaping ((Bool) -> Void)) {
        captionCenterYAnchor.isActive = false
        captionTopAnchor.isActive = true
        captionLabel.font = .systemFont(ofSize: 12, weight: .medium)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
    private func moveHeaderToCenter(completion: @escaping ((Bool) -> Void)) {
        captionTopAnchor.isActive = false
        captionCenterYAnchor.isActive = true
        captionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
}
