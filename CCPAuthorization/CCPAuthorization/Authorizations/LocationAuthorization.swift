//
//  LocationAuthorization.swift
//  CCPAuthorization
//
//  Created by clobotics_ccp on 2019/8/23.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import CoreLocation


enum LocationUsePeriod {
    case always
    case whenInUse
}


//在info.plist中添加NSLocationAlwaysAndWhenInUseUsageDescription, NSLocationWhenInUseUsageDescription
//使用单例的原因是确保delegate可以执行

class LocationAuthorization: NSObject {
    
    private static let instance = LocationAuthorization()
    
    private lazy var manager: CLLocationManager = {
        let m = CLLocationManager()
        m.delegate = self
        return m
    }()
    
    private var callback: CCPAuthorizationCallback?
    
    private func location(_ callback: CCPAuthorizationCallback?, period: LocationUsePeriod) {
        status = CLLocationManager.authorizationStatus()
        switch status.toCCPStatus() {
        case .authorized:
            callback?(.authorized)
        case .denied:
            callback?(.denied)
        case .notDetermind:
            if period == .always {
                manager.requestAlwaysAuthorization()
            }
            else {
                manager.requestWhenInUseAuthorization()
            }
            self.callback = callback
        }        
    }
    
    private var status: CLAuthorizationStatus = .notDetermined
    
    static func location(_ callback: CCPAuthorizationCallback?, period: LocationUsePeriod = .always) {
        instance.location(callback, period: period)
    }
    
    static var status: CCPAuthorizationStatus {
        return instance.status.toCCPStatus()
    }
    
}

extension LocationAuthorization: CLLocationManagerDelegate {
    
    //这个方法在发出请求后就会响应，在用户响应弹出窗后，会再次响应
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        callback?(status.toCCPStatus())
    }
}

extension CLAuthorizationStatus {
    func toCCPStatus() -> CCPAuthorizationStatus {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        case .notDetermined:
            return .notDetermind
        default:
            return .denied
        }
    }
}
