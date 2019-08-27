//
//  CalendarAuthorization.swift
//  CCPAuthorization
//
//  Created by clobotics_ccp on 2019/8/26.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import EventKit


//在info.plist 中添加 NSCalendarsUsageDescription

extension CCPAuthorization {
    
    /*
     * 此方法可以多次调用，如果用户未选择权限，则会弹出提示框，且在用户响应提示框后走回调；
     * 如果已经选择权限，不会弹出提示框，只会走回调。
     * ps: 回调的线程由调用的线程决定
     */
    func calendar(_ callback: CCPAuthorizationCallback?) {
        EKEventStore().requestAccess(to: .event) { (granted, _) in
            self.granted(granted, callback)
        }
    }
    
    var calendarStatus: CCPAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event).toCCPStatus()
    }    
}

extension EKAuthorizationStatus {
    func toCCPStatus() -> CCPAuthorizationStatus {
        switch self {
        case .notDetermined:
            return .notDetermind
        case .authorized:
            return .authorized
        default:
            return .denied
        }
    }
}
