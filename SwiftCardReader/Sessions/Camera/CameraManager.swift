//
//  CameraManager.swift
//  SwiftCardReader
//
//  Created by Bilal Bakhrom on 07/03/2020.
//  Copyright © 2020 Bilal Bakhrom. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class CameraManager: NSObject {
    var captureSession: AVCaptureSession?
    var rearCamera: AVCaptureDevice?
    var videoOutput: AVCaptureVideoDataOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    var isCaptureSessionRunning: Bool {
        guard let captureSession = captureSession else { return false }
        return captureSession.isRunning
    }
    
    override init() {
        super.init()
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(videoPreviewLayer!, at: 0)
        videoPreviewLayer?.frame = view.frame
    }
    
    func startScan(completion: @escaping (UIImage?, Error?) -> Void) {
        guard isCaptureSessionRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
        videoOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        photoCaptureCompletionBlock = completion
    }
    
    func imageOrientation(_ deviceOrientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position) -> VisionDetectorImageOrientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return cameraPosition == .front ? .topRight : .bottomRight
        default:
            return .leftTop
        }
    }
    
    func stopSession() {
        captureSession?.stopRunning()
        videoOutput = nil
        videoPreviewLayer = nil
        captureSession = nil
    }
    
    // MARK: - Configuration
    
    func prepareCamera(completionHandler: @escaping (Error?) -> Void) {
        DispatchQueue(label: "prepareCamera").async {
            do {
                self.createCaptureSession()
                try self.configureCaptureDevices()
                try self.configureDeviceInputs()
                try self.configureVideoOutput()
            } catch {
                DispatchQueue.main.async { completionHandler(error) }
                return
            }
            DispatchQueue.main.async { completionHandler(nil) }
        }
    }
    
    private func createCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    private func configureCaptureDevices() throws {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        let cameras = (session.devices.compactMap { $0 })
        guard !cameras.isEmpty else { throw CameraControllerError.noCamerasAvailable }
        
        for camera in cameras where camera.position == .back {
            rearCamera = camera
            try camera.lockForConfiguration()
            camera.focusMode = .continuousAutoFocus
            camera.unlockForConfiguration()
        }
    }
    
    private func configureDeviceInputs() throws {
        guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        
        if let rearCamera = self.rearCamera {
            let cameraInput = try AVCaptureDeviceInput(device: rearCamera)
            guard captureSession.canAddInput(cameraInput) else { return }
            captureSession.addInput(cameraInput)
        } else {
            throw CameraControllerError.noCamerasAvailable
        }
    }
    
    private func configureVideoOutput() throws {
        guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput?.alwaysDiscardsLateVideoFrames = true
        videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        if captureSession.canAddOutput(videoOutput!) {
            captureSession.addOutput(videoOutput!)
        }
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
}


extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let image: UIImage = convert(ciImage: ciImage)
        let newImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .right)
        photoCaptureCompletionBlock?(newImage, nil)
    }
    
    private func convert(ciImage: CIImage) -> UIImage {
        let cgImage = CIContext.init(options: nil).createCGImage(ciImage, from: ciImage.extent)!
        let image = UIImage.init(cgImage: cgImage)
        guard let jpegData = image.jpegData(compressionQuality: 0.5), let jpegImage = UIImage(data: jpegData) else { return image }
        return jpegImage
    }
    
}


extension CameraManager {
    
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
}
