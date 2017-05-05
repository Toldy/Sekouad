//
//  HomePageViewController.swift
//  Sekouad
//
//  Created by Julien Colin on 16/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var page: Int {
        return Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        // Listen for page change notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(goToPageNotificationHandler(_:)),
                                               name: SekouadeNotification.goTo.rawValue, object: nil)
        
    }
    
    var camera: CameraViewController!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cameraSegue" {
            camera = segue.destination as! CameraViewController
        }
    }
    
    func goToPageNotificationHandler(_ notification: NSNotification) {
        guard let targetPage = notification.userInfo!["page"] as? Int else { return }
        
        if targetPage == 0 {
            DispatchQueue.main.async {
                self.scrollView.scrollRectToVisible(self.camera.view.bounds, animated: true)
            }
        }
    }
}

extension HomePageViewController: UIScrollViewDelegate {
    
    // Photo view: Fade in/out effet
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var frame = camera.view.frame
        
        frame.origin.x = scrollView.contentOffset.x
        
        camera.view.frame = frame
        camera.blurredEffectView.alpha = frame.origin.x / scrollView.bounds.size.width
    }
}
