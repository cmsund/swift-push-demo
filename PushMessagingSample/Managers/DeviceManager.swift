//
//  DeviceManager.swift
//  DigitalVelocity
//
//  Created by Jason Koo on 5/22/18.
//  Copyright © 2018 Jason Koo. All rights reserved.
//

import UIKit

class DeviceManager {
    
    static var shouldAlwaysConservePower : Bool = false
    
    class func shouldConservePower() -> Bool {
        if shouldAlwaysConservePower == true {
            return true
        }
        if isCharging() == true {
            return false
        }
        UIDevice.current.isBatteryMonitoringEnabled = true
        if isBatteryLevelAbove20Percent() == true {
            return false
        }
        return true
    }
    
    class func isBatteryLevelAbove20Percent() -> Bool {
        return UIDevice.current.batteryLevel > 0.2
    }
    
    class func isCharging() -> Bool {
        return UIDevice.current.batteryState == .charging
    }
}
