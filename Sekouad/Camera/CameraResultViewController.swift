//
//  CameraResultViewController.swift
//  Sekouad
//
//  Created by Julien Colin on 16/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import UIKit
import AVFoundation

class CameraResultViewController: UIViewController {

    // Mandatory VC setting
    var contentType: ContentType!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultVideoView: UIView!

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        switch contentType! {
        case .photo(let image):
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            view.makeToast(message: "📷  Saved !")
        case .video(let url):
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, self,
                                                    #selector(video(videoPath:didFinishSavingWithError:contextInfo:)),
                                                    nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch contentType! {
        case .photo(let image):
            resultImageView.isHidden = false
            resultVideoView.isHidden = true
            resultImageView.image = image
        case .video(let url):
            resultImageView.isHidden = true
            resultVideoView.isHidden = false
            playVideo(url)
        }
        closeButton.addShadow()
        downloadButton.addShadow()
    }
    
    func playVideo(_ url: URL){
        let f = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = f
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        resultVideoView.layer.addSublayer(playerLayer)
        
        DispatchQueue.main.async {
            player.play()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            player.seek(to: kCMTimeZero)
            player.play()
        }
    }
}

// Video saving

extension CameraResultViewController {
    
    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var infoMessage = ""
        if let e = error {
            infoMessage = "😭  Error: \(e)"
        } else {
            infoMessage = "🎬  Saved !"
        }
        view.makeToast(message: infoMessage)
    }
    
}

extension CameraResultViewController {
    
    enum ContentType {
        case photo(image: UIImage)
        case video(url: URL)
    }
}
