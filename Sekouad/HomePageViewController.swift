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
        
        view.subviews
            .flatMap { $0 as? UIScrollView }
            .first?.delegate = self
        
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
            DispatchQueue.main.async {
                self.currentIndex = 0
                self.setViewControllers([self.orderedViewControllers.first!], direction: .reverse, animated: false, completion: nil)
            }
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

extension HomePageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == orderedViewControllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else {
            
            if currentIndex == 0 {
                let camera = orderedViewControllers.first! as! CameraViewController
                var frame = camera.view.frame
                frame.origin.x = scrollView.contentOffset.x - scrollView.bounds.size.width
                camera.view.frame = frame
                
                                var percentage = frame.origin.x / scrollView.bounds.size.width
//                                camera.blurredBackgroundView.alpha = percentage
                //                print(percentage)
            } else {
                var frame = orderedViewControllers.first!.view.frame
                frame.origin.x = scrollView.contentOffset.x
                orderedViewControllers.first!.view.frame = frame
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == orderedViewControllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
    
}
