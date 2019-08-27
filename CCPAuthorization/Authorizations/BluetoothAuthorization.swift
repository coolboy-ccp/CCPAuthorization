//
//  BluetoothAuthorization.swift
//  CCPAuthorization
//
//  Created by clobotics_ccp on 2019/8/26.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

import CoreBluetooth

/*
 * 目前api中没有权限限制，到ios13.0后更新
 
 */
//在info.plist中添加NSBluetoothPeripheralUsageDescription
class BluetoothAuthorization: NSObject {
    
    private static let instance = BluetoothAuthorization()
    
    static func bluetooth(_ callback: CCPAuthorizationCallback?) {
        instance.bluetooth(callback)
    }
    
    private var callback: CCPAuthorizationCallback?
    
    /*
     * queue 是delegate的回调队列，if nil，则为主队列
     * opetions 包含CBCentralManagerOptionShowPowerAlertKey, CBCentralManagerOptionRestoreIdentifierKey
     * CBCentralManagerOptionShowPowerAlertKey value 是一个bool值, 表示当系统的蓝牙未开启时是否弹出提示, default is false
     * CBCentralManagerOptionRestoreIdentifierKey value 是一个UID, 用于创建一个特定的manager，在后续运行过程中，要保证这个UID不变，以还原manager
     
     */
    private lazy var manager: CBCentralManager = {
        let mg = CBCentralManager.init(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey : true])
        return mg
    }()
    
   

    func bluetooth(_ callback: CCPAuthorizationCallback?) {
        self.manager.state

        self.callback = callback
    }
}

extension BluetoothAuthorization: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.manager.scanForPeripherals(withServices: nil, options: nil)
        print(central.state.rawValue)
    }
    
    
}
