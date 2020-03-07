//
//  CameraViewController.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase


protocol CameraViewControllerDelegate: class {
    func didTouchDismissButton()
    func didRecognizeCard(number: String, expireDate: String)
}

extension CameraViewControllerDelegate {
    func didTouchDismissButton() { }
}


class CameraViewController: UIViewController, CameraViewInstaller {

    var capturePreviewView: UIView!
    var dismissButton: UIButton!
    var cameraManager = CameraManager()
    weak var delegate: CameraViewControllerDelegate?
    
    var mainView: UIView  { view }
    
    var viewModel: CameraBusinessLogic! {
        didSet {
            load()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func load() {
        setupSubviews()
        setupTargets()
        bind()
        localizeText()
        configureCameraController {
            self.startCreditCardScan()
        }
    }
    
    func setupTargets() {
        dismissButton.addTarget(self, action: #selector(closeCamera), for: .touchUpInside)
    }
    
    func bind() {
        viewModel.didSetupCardAttribute.bindAndFire { (isValid) in
            guard isValid else { return }
            self.delegate?.didRecognizeCard(number: self.viewModel.cardNumber, expireDate: self.viewModel.expireDate)
            self.cameraManager.stopSession()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureCameraController(completion: @escaping () -> Void) {
        cameraManager.prepareCamera {(error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "Something went wrong")
                return self.dismiss(animated: true, completion: nil)
            }
            
            try? self.cameraManager.displayPreview(on: self.capturePreviewView)
            completion()
        }
    }
    
    func startCreditCardScan() {
        cameraManager.startScan {(image, error) in
            guard let image = image else { print(error ?? "Image capture error"); return }
            self.readText(from: image)
        }
    }
    
    func readText(from image: UIImage) {
        Vision.vision().onDeviceTextRecognizer().process(visionImage(image)) { (visionText, error) in
            guard error == nil, let visionText = visionText else {
                return
            }
            self.inspectText(from: visionText)
        }
    }
    
    func inspectText(from result: VisionText) {
        let words = result.text.components(separatedBy: "\n")
        for word in words {
            let text = word.replacingOccurrences(of: " ", with: "")
            if text.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil, text.isNumeric, text.count == 16 {
                viewModel.set(cardNumber: text)
            } else if text.contains("/"), text.count == 5 {
                let expireDate = text.replacingOccurrences(of: "/", with: "")
                guard expireDate.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil, expireDate.isNumeric else { return }
                viewModel.set(expireDate: expireDate)
            }
        }
    }
    
    @objc private func closeCamera() {
        dismissButton.pulseAnimate {
            self.delegate?.didTouchDismissButton()
            self.cameraManager.stopSession()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Helper methods
    
    private func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return results.map { String(text[Range($0.range, in: text)!]) }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    private func visionImage(_ image: UIImage) -> VisionImage {
        let visionImage = VisionImage(image: image)
        let metadata = VisionImageMetadata()
        metadata.orientation = cameraManager.imageOrientation(.portrait, cameraPosition: .back)
        visionImage.metadata = metadata
        return visionImage
    }
}

