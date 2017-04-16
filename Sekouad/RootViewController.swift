//
//  RootViewController.swift
//  Sekouad
//
//  Created by Julien Colin on 16/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import UIKit

enum SekouadeNotification {
    case takePicture
    case goTo
    
    typealias RawValue = Notification.Name
    var rawValue: RawValue {
        switch self {
        case .takePicture:
            return Notification.Name("TakePicture")
        case .goTo:
            return Notification.Name("HomePanel.GoTo")
        }
    }
}

class RootViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    
    private var homePageViewController: HomePageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        recordButton.addShadow()
    }
    
    @IBAction func recordAction(_ sender: Any) {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        homePageViewController = segue.destination as? HomePageViewController
    }
}
