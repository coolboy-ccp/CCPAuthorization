//
//  CCPAlertPlugin.swift
//  CCPAuthorization
//
//  Created by clobotics_ccp on 2019/8/26.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

typealias CCPAlertPluginCallback = () -> ()

protocol CCPAlertPlugin {
    func alert(_ target: CCPAuthorization)
    func title(_ target: CCPAuthorization) -> String
    func message(_ target: CCPAuthorization) -> String
    var cancelTitle: String { get }
    var confirmTitle: String { get }
    var cancelCallback: CCPAlertPluginCallback? { get }
    var sureCallback: CCPAlertPluginCallback? { get }
}

extension CCPAlertPlugin {
    
    func title(_ target: CCPAuthorization) -> String {
        switch target {
        case .album:
            return NSLocalizedString("CCPAlertPluginAlbumTitle", tableName: "CCPAuthorization", comment: "")
        case .camera:
            return NSLocalizedString("CCPAlertPluginCameraTitle", tableName: "CCPAuthorization", comment: "")
        case .contact:
            return NSLocalizedString("CCPAlertPluginContactTitle", tableName: "CCPAuthorization", comment: "")
        case .locationAlays, .locationInUse:
            return NSLocalizedString("CCPAlertPluginLocationTitle", tableName: "CCPAuthorization", comment: "")
        case .calendar:
            return NSLocalizedString("CCPAlertPluginCalendarTitle", tableName: "CCPAuthorization", comment: "")
        case .reminder:
            return NSLocalizedString("CCPAlertPluginReminderTitle", tableName: "CCPAuthorization", comment: "")
        case .faceID:
            return NSLocalizedString("CCPAlertPluginFaceIDTitle", tableName: "CCPAuthorization", comment: "")
        default:
            return "unknown"
        }
    }
    
    func message(_ target: CCPAuthorization) -> String {
        switch target {
        case .album:
            return NSLocalizedString("CCPAlertPluginAlbumMessage", tableName: "CCPAuthorization", comment: "")
        case .camera:
            return NSLocalizedString("CCPAlertPluginCameraMessage", tableName: "CCPAuthorization", comment: "")
        case .contact:
            return NSLocalizedString("CCPAlertPluginContactMessage", tableName: "CCPAuthorization", comment: "")
        case .locationAlays, .locationInUse:
            return NSLocalizedString("CCPAlertPluginLocationMessage", tableName: "CCPAuthorization", comment: "")
        case .calendar:
            return NSLocalizedString("CCPAlertPluginCalendarMessage", tableName: "CCPAuthorization", comment: "")
        case .reminder:
            return NSLocalizedString("CCPAlertPluginReminderMessage", tableName: "CCPAuthorization", comment: "")
        case .faceID:
            return NSLocalizedString("CCPAlertPluginFaceIDMessage", tableName: "CCPAuthorization", comment: "")
        default:
            return "unknown"
        }
    }
    
    var cancelTitle: String {
        return NSLocalizedString("CCPAlertPluginCancel", tableName: "CCPAuthorization", comment: "")
    }
    
    var confirmTitle: String {
        return NSLocalizedString("CCPAlertPluginConfirm", tableName: "CCPAuthorization", comment: "")
    }
    
    var cancelCallback: CCPAlertPluginCallback? {
        return nil
    }
    
    var sureCallback: CCPAlertPluginCallback? {
        return nil
    }
    
    func alert(_ target: CCPAuthorization) {
        let alert = UIAlertController.init(title: title(target), message: message(target), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { (_) in
            self.cancelCallback?()
        }
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { (_) in
            self.sureCallback?()
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        currentVC()?.present(alert, animated: true, completion: nil)
    }
    
}

class CCPAlertPluginDefault: CCPAlertPlugin {}

func currentVC() -> UIViewController? {
    guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
        return nil
    }
    
    func current(_ vc: UIViewController?) -> UIViewController? {
        guard let vc = vc else { return nil }
        if let presented = vc.presentedViewController {
            return current(presented)
        }
        if let tabbarVC = vc as? UITabBarController {
            return current(tabbarVC.selectedViewController)
        }
        if let navVC = vc as? UINavigationController {
            return current(navVC.topViewController)
        }
        return vc
    }
    return current(vc)
}
