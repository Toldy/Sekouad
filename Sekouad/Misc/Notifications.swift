//
//  Notifications.swift
//  Sekouad
//
//  Created by Julien Colin on 17/04/2017.
//  Copyright © 2017 toldy. All rights reserved.
//

import Foundation

enum SekouadeNotification {
    case takePicture
    case record
    case goTo
    
    typealias RawValue = Notification.Name
    var rawValue: RawValue {
        switch self {
        case .takePicture:
            return Notification.Name("TakePicture")
        case .record:
            return Notification.Name("Record")
        case .goTo:
            return Notification.Name("HomePanel.GoTo")
        }
    }
}
