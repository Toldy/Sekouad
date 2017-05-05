//
//  Extensions.swift
//  Sekouad
//
//  Created by Julien Colin on 17/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import UIKit

// Deep copy
extension UIView {
    
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
}

// Simple shadow
extension UIView {
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3
        clipsToBounds = false
    }
}

// Quick toast without libs to display messages
extension UIView {
    
    func makeToast(message: String) {
        let labelFrame = CGRect(x: self.bounds.width / 2 - 75, y: self.bounds.height - 100,
                                width: 150, height: 35)
        let label = UILabel(frame: labelFrame)
        label.text = message

        // Fast design and transition
        label.backgroundColor = UIColor(white: 0, alpha: 0.5)
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.clipsToBounds = true
        self.addSubview(label)
        UIView.animate(withDuration: 0.4, delay: 2, animations: {
            label.alpha = 0
        }) { _ in
            label.removeFromSuperview()
        }
    }
}

// Easy instantiation
extension UIViewController {
    
    static func instantiate<T>(withIdentifier identifier: String) -> T {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
}
