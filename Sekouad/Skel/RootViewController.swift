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
        if homePageViewController?.currentIndex == 0 {
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
        }
        else if sender.state == .ended {
            NotificationCenter.default.post(name: SekouadeNotification.record.rawValue,
                                            object: nil, userInfo: ["action": "stop"])
        }
    }
}
