//
//  SystemUrlScheme.swift
//  CCPCS
//
//  Created by clobotics_ccp on 2019/8/15.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UIKit

public enum SystemSkip: String {
    case wifi = "WIFI"
    case bluetooth = "Bluetooth"
    case celluar = "MOBILE_DATA_SETTINGS_ID"
    case hot = "INTERNET_TETHERING"
    case carrier = "Carrier"
    case notification = "NOTIFICATIONS_ID"
    case general = "General"
    case reset = "Reset"
    case siri = "SIRI"
    case privacy = "Privacy"
    case location = "LOCATION_SERVICES"
    case safari = "SAFARI"
    case music = "MUSIC"
    case photos = "Photos"
    case faceTime = "FACETIME"
    case wallPaper = "Wallpaper"
    case setting
    
    /*----GeneralURLSchemhe--*/
    case about = "About"
    case accessibility = "ACCESSIBILITY"
    case keyboard = "Keyboard"
    case international = "INTERNATIONAL"
}

extension SystemSkip {
    public var url: URL? {
        switch self {
        case .about, .accessibility, .keyboard, .international:
            return URL(string: "App-Prefs:root=General&path=\(self.rawValue)")
        case .setting:
            return URL(string: UIApplication.openSettingsURLString)
        default:
            return URL(string: "App-Prefs:root=\(self.rawValue)")
        }
    }
    
    @discardableResult
    public func skip(options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler:((Bool) -> ())? = nil) -> Bool {
        guard let url = url else {
            return false
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: options, completionHandler: completionHandler)
            
            return true
        }
        return false
    }
}
