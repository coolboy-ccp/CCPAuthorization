//
//  NotificationAuthorization.swift
//  CCPAuthorization
//
//  Created by clobotics_ccp on 2019/8/26.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import UserNotifications

extension CCPAuthorization {
    func notification(_ options: UNAuthorizationOptions, _ callback: CCPAuthorizationCallback?) {
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            self.granted(granted, callback)
        }
    }
    
    /*
     * 苹果的脑洞机制，获取通知的权限状态竟然是异步的。用DispatchSemaphore强制同步，如果在0.3秒内无法获取，则表示获取失败，这时CCPAuthorizationStatus状态不代表当前app的通知权限状态
     *
     */
    func notificationStatus() -> CCPAuthorizationStatus? {
        var status = UNAuthorizationStatus.notDetermined
        let semap = DispatchSemaphore(value: 0)
        UNUserNotificationCenter.current().getNotificationSettings { (setting) in
            status = setting.authorizationStatus
            semap.signal()
        }
        let result = semap.wait(timeout: .now() + 0.3)
        switch result {
        case .success:
            return status.toCCPStatus()
        case .timedOut:
            print("在限定时间内未能获取到最新的通知权限的状态，请尝试重新获取，或自行调用getNotificationSettings")
            return nil
        }
        
    }
}

extension UNAuthorizationStatus {
    func toCCPStatus() -> CCPAuthorizationStatus {
        switch self {
        case .authorized:
            return .authorized
        case .notDetermined:
            return .notDetermind
        default:
            return .denied
        }
    }
}

