//
//  MicroPhoneAutnorization.swift
//  CCPAuthorization
//
//  Created by clobotics_ccp on 2019/8/23.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import AVFoundation

//在info.plist中配置 NSMicrophoneUsageDescription
extension CCPAuthorization {
    
    /*
     * 此方法可以多次调用，如果用户未选择权限，则会弹出提示框，且在用户响应提示框后走回调；
     * 如果已经选择权限，不会弹出提示框，只会走回调。
     * ps: 回调的线程由调用的线程决定
     */
    func microphone(_ callback: CCPAuthorizationCallback?) {
        AVCaptureDevice.requestAccess(for: .audio) { 
            self.granted($0, callback)
        }
    }
    
    var microphoneStatus: CCPAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .audio).toCCPStatus()
    }
}

