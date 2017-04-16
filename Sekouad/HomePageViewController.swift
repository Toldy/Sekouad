//
//  HomePageViewController.swift
//  Sekouad
//
//  Created by Julien Colin on 16/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import UIKit

class HomePageViewController: UIPageViewController {

    private (set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.viewController(withName: "CameraViewControllerId"),
                self.viewController(withName: "TimelineViewControllerId")]
    }()
    
    fileprivate func viewController(withName name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }

    fileprivate var nextIndex = 0
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        // Listen for page change notification
        NotificationCenter.default.addObserver(self, selector: #selector(HomePageViewController.goToPageNotificationHandler(_:)),
                                               name: SekouadeNotification.goTo.rawValue, object: nil)

        // Set initial page(viewcontroller)
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func goToPageNotificationHandler(_ notification: NSNotification) {
        guard let targetPage = notification.userInfo!["page"] as? Int else { return }
        
        if targetPage == 0 {
            setViewControllers([orderedViewControllers.first!], direction: .reverse, animated: true, completion: nil)
            currentIndex = 0
        }
    }

}



extension HomePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextIndex = currentIndex + 1
        
        guard orderedViewControllers.count != nextIndex else {
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
}

extension HomePageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let firstViewController = pendingViewControllers.first {
            nextIndex = orderedViewControllers.index(of: firstViewController) ?? 0
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = nextIndex
        }
        nextIndex = 0
    }
}
