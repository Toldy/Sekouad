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
    @IBOutlet weak var blurredEffectView: UIVisualEffectView!
    @IBOutlet weak var cameraView: UIView!
    
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
        
        blurredEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurredEffectView.alpha = 0
        swapButton.addShadow()

        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.capturePicture),
                                               name: SekouadeNotification.takePicture.rawValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.recordVideo),
                                               name: SekouadeNotification.record.rawValue, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cameraView.layer.addSublayer(previewLayer)
        
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
    var videoFileOutput: AVCaptureMovieFileOutput?
    
    
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
            
            if videoFileOutput == nil {
                videoFileOutput = AVCaptureMovieFileOutput()
                if cameraSession.canAddOutput(videoFileOutput!) {
                    cameraSession.addOutput(videoFileOutput!)
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
    
    func recordVideo(_ notification: NSNotification) {
        guard let action = notification.userInfo!["action"] as? String else { return }
        
        if action == "start" {
            let fileName = "mysavefile.mp4";
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = documentsURL.appendingPathComponent(fileName)
            
            let movieFileOutputConnection = videoFileOutput?.connection(withMediaType: AVMediaTypeVideo)
            //flip video output if front facing camera is selected
            if self.captureDevicePosition == .front {
                movieFileOutputConnection?.isVideoMirrored = true
            }
            
            videoFileOutput?.startRecording(toOutputFileURL: filePath, recordingDelegate: self)
        } else if action == "stop" {
            videoFileOutput?.stopRecording()
        }
    }
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultImageView: UIImageView!

    fileprivate func viewController(withName name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    func displayResult(_ contentType:  CameraResultViewController.ContentType) {
        let resultVC: CameraResultViewController = UIViewController.instantiate(withIdentifier: "CameraResultViewControllerId")
        resultVC.modalTransitionStyle = .crossDissolve
        resultVC.contentType = contentType
        self.present(resultVC, animated: true, completion: nil)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        if error != nil {
            print("ERROR", error)
            return
        }
        
        if (photoSampleBuffer != nil) {
            let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!,
                                                                        previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: data!)
            let flippedImage = UIImage(cgImage: image!.cgImage!, scale: image!.scale, orientation: .leftMirrored)
            displayResult(.photo(image: flippedImage))
        }
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func capture(_ captureOutput: AVCaptureFileOutput!,
                 didFinishRecordingToOutputFileAt outputFileURL: URL!,
                 fromConnections connections: [Any]!,
                 error: Error!) {
        displayResult(.video(url: outputFileURL))
    }
}
