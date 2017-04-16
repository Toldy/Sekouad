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
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.capturePicture), name: SekouadeNotification.takePicture.rawValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.recordVideo), name: SekouadeNotification.record.rawValue, object: nil)
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
            
            videoFileOutput?.startRecording(toOutputFileURL: filePath, recordingDelegate: self)
        } else if action == "stop" {
            videoFileOutput?.stopRecording()
        }
        
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

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("capture did finish")
        print(captureOutput)
        print(outputFileURL)
        playVideo(outputFileURL)
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputFileURL.path) {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, self, #selector(CameraViewController.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func playVideo(_ url: URL){
        let f = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = f
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        self.view.layer.addSublayer(playerLayer)
        
        DispatchQueue.main.async {
            player.play()
        }
        
    }
    
    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject)
    {
        if let _ = error {
            print("Error,Video failed to save")
        }else{
            print("Successfully,Video was saved")
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
