//
//  CameraViewController.swift
//  Sekouad
//
//  Created by Julien Colin on 16/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var swapButton: UIButton!

    private var captureDevicePosition = AVCaptureDevicePosition.front

    @IBAction func swapAction(_ sender: Any) {
        swapCameraOrientation()
    }
    
    private func swapCameraOrientation() {
        captureDevicePosition = captureDevicePosition == .front ? .back : .front
        setupCameraSession()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraSession()
        
        
        swapButton.addShadow()
        let notificationName = Notification.Name("TakePicture")
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.capturePicture), name: notificationName, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.layer.insertSublayer(previewLayer, below: swapButton.layer)
        
        cameraSession.startRunning()
    }
    
    lazy var cameraSession: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = AVCaptureSessionPresetHigh
        return s
    }()
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview?.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        preview?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        preview?.videoGravity = AVLayerVideoGravityResize
        return preview!
    }()
    
    var dataOutput: AVCapturePhotoOutput?
    
    func setupCameraSession() {
        let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: captureDevicePosition)
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            cameraSession.beginConfiguration()
            
            if let firstInput = cameraSession.inputs.first as? AVCaptureInput {
                cameraSession.removeInput(firstInput)
                if (cameraSession.canAddInput(deviceInput) == true) {
                    cameraSession.addInput(deviceInput)
                }
            }
            else if (cameraSession.canAddInput(deviceInput) == true) {
                cameraSession.addInput(deviceInput)
            }
            
            if dataOutput == nil {
                dataOutput = AVCapturePhotoOutput()
                if (cameraSession.canAddOutput(dataOutput!) == true) {
                    cameraSession.addOutput(dataOutput!)
                }
            }
            
            cameraSession.commitConfiguration()
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    func capturePicture() {
        let captureSettings = AVCapturePhotoSettings()
        if let videoConnection = dataOutput!.connection(withMediaType: AVMediaTypeVideo) {
            dataOutput!.capturePhoto(with: captureSettings, delegate: self)
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if error != nil {
            print("ERROR", error)
            return
        }
        
        if (photoSampleBuffer != nil) {
            let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!,
                                                                        previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: data!)
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
    }
}


extension UIView {
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3
        clipsToBounds = false
    }
}
