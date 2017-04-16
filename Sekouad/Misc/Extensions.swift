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

// Easy instantiation
extension UIViewController {
    
    static func instantiate<T>(withIdentifier identifier: String) -> T {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
}
