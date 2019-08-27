//
//  FaceIDAuthorization.swift
//  CCPAuthorization
//
//  Created by clobotics_ccp on 2019/8/26.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import LocalAuthentication

////在info.plist中添加NSFaceIDUsageDescription
class FaceIDAuthorization: NSObject {
    static func faceID(_ callback: CCPAuthorizationCallback?) {
        var error: NSError?
        let ctx = LAContext()
        let a = ctx.isCredentialSet(.applicationPassword)
        print(a)
        //判断faceID是否可用
        if ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            //唤起faceID, 如果是第一次，则会弹出提示框
            ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "test") { (granted, error) in
                if granted {
                    callback?(.authorized)
                    return
                }
                if let errorString = error?.localizedDescription, errorString.contains("cancel") {
                    return
                }
                callback?(.denied)
            }
        }
        else {
            callback?(.denied)
        }
    }
    
    
    static var faceIDStatus: CCPAuthorizationStatus {
        var error: NSError?
        let granted = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return granted ? .authorized : .denied
    }
   
}

