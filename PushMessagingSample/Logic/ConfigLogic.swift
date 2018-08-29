//
//  ConfigLogic.swift
//  PushMessagingSample
//
//  Created by Christina on 7/22/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import Foundation

func config() {

    let launchArgs = ProcessInfo.processInfo.arguments

    // Logging
    if launchArgs.contains("DISABLE_LOGGING") == false {
        Log.logLevel = .verbose
    } else {
        Log.logLevel = .none
    }
    Log.debug("Log level set to \(Log.logLevel.toString())")

    // Powersave
    if launchArgs.contains("CONSERVE_POWER") == true {
        Log.debug("Conserve power mode enabled.")
        DeviceManager.shouldAlwaysConservePower = true
    }

    // Background
    if launchArgs.contains("DISABLE_BACKGROUND") == false {
        Log.debug("Background Enabled")
        BackgroundManager.add()
    } else if (launchArgs.contains("DISABLE_BACKGROUND") == true /*|| DeviceManager.shouldConservePower() == true*/) {
        BackgroundManager.useVideo = false
    }

    // Firebase
    if launchArgs.contains("DISABLE_FIREBASE") == false {
        FirebaseManager.shared.start {
            Log.debug("Firebase enabled.")
        }
    }

    // Tealium Shared Start
    if launchArgs.contains("DISABLE_TEALIUM") == false {
        Log.debug("Tealium enabled.")
        TealiumHelper.isEnabled = true
        TealiumHelper.shared.start()
    }

}


