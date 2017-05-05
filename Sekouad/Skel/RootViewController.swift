//
//  RootViewController.swift
//  Sekouad
//
//  Created by Julien Colin on 16/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingImageView: UIImageView!
    
    private var homePageViewController: HomePageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        recordButton.addShadow()
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(RootViewController.mainButtonTouchAction))
        let longGesture = UILongPressGestureRecognizer(target: self,
                                                       action: #selector(RootViewController.mainButtonLongPressAction(_:)))
        tapGesture.numberOfTapsRequired = 1
        recordButton.addGestureRecognizer(tapGesture)
        recordButton.addGestureRecognizer(longGesture)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        homePageViewController = segue.destination as? HomePageViewController
    }
    
    @IBAction func mainButtonTouchAction() {
        // If current view is camera: Take picture
        if homePageViewController?.page == 0 {
            NotificationCenter.default.post(name: SekouadeNotification.takePicture.rawValue,
                                            object: nil)
        } else {
            // Else slide to camera view
            NotificationCenter.default.post(name: SekouadeNotification.goTo.rawValue,
                                            object: nil, userInfo: ["page": 0])
        }
    }
    
    @IBAction func mainButtonLongPressAction(_ sender: UILongPressGestureRecognizer) {

        if sender.state == .began {
            NotificationCenter.default.post(name: SekouadeNotification.record.rawValue,
                                            object: nil, userInfo: ["action": "start"])
            
            // Simple record animation start
            UIView.animate(withDuration: 1, animations: {
                self.recordButton.alpha = 0
                self.recordingImageView.alpha = 1
            })
            let anim = CABasicAnimation(keyPath: "transform.scale")
            anim.fromValue = 1
            anim.toValue = 2
            anim.duration = 1
            anim.autoreverses = true
            anim.repeatCount = Float.greatestFiniteMagnitude
            recordingImageView.layer.add(anim, forKey: nil)
        }
        else if sender.state == .ended {
            NotificationCenter.default.post(name: SekouadeNotification.record.rawValue,
                                            object: nil, userInfo: ["action": "stop"])
            // Simple record animation stop
            UIView.animate(withDuration: 0.4, animations: {
                self.recordButton.alpha = 1
                self.recordingImageView.alpha = 0
            })
        }
    }
}
