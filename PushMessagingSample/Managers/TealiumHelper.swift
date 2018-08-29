//
//  TealiumHelper.swift
//
//  Created by Jason Koo on 11/22/16.
//  Modified by Craig Rouse 22/11/17
//  Copyright © 2017 Tealium. All rights reserved.
//

import Foundation
import tealium_swift


extension String: Error { }

/// Example of a shared helper to handle all 3rd party tracking services. This
/// paradigm is recommended to reduce burden of future code updates for external services
/// in general.
class TealiumHelper {

    static var isEnabled = false
    var tealium: Tealium?
    var enableHelperLogs = true
    static var shared = TealiumHelper()

    func start() {
        if TealiumHelper.isEnabled == false {
            return
        }
        // REQUIRED Config object for lib
        let config = TealiumConfig(account: Keys.tealiumAccount,
                                   profile: Keys.tealiumProfile,
                                   environment: Keys.tealiumEnvironment,
                                   datasource: Keys.tealiumDatasource,
                                   optionalData: nil)

        // OPTIONALLY set log level
        config.setLogLevel(logLevel: .verbose)

        // OPTIONALLY add an external delegate
        config.addDelegate(self)

        // OPTIONALLY disable a particular module by name
        let list = TealiumModulesList(isWhitelist: false,
                                      moduleNames: ["autotracking"])
        config.setModulesList(list)

        // REQUIRED Initialization
        tealium = Tealium(config: config,
                          completion: { (responses) in
                              // Set default consent to always consented for demo purposes
                              self.tealium?.consentManager()?.setUserConsentStatus(.consented)

                              // Optional processing post init.
                              // OPTIONALLY implement Dynamic Triggers/Remote Commands.
                              #if os(iOS)
                                  let remoteCommand = TealiumRemoteCommand(commandId: "logger",
                                                                           description: "test") { (response) in

                                      if TealiumHelper.shared.enableHelperLogs {
                                          print("*** TealiumHelper: Remote Command Executed: response:\(response)")
                                      }

                                  }

                                  // this must be done inside the Tealium init callback, otherwise remotecommands won't be avaialable
                                  if let remoteCommands = self.tealium?.remoteCommands() {
                                      remoteCommands.add(remoteCommand)
                                  } else {
                                      return
                                  }
                              #endif

                          })
        // example showing persistent data
        self.tealium?.persistentData()?.add(data: ["testPersistentKey": "testPersistentValue"])
        // example showing volatile data
        self.tealium?.volatileData()?.add(data: ["testVolatileKey": "testVolatileValue"])
        // process a tracking call on the background queue
        // example tracking call - not required in production
        DispatchQueue.global(qos: .background).async {
            self.tealium?.track(title: "HelperReady_BG_Queue")
        }
        // example tracking call - not required in production
        self.tealium?.track(title: "HelperReady")
    }

    // Add Volitile Data
    func addVolitileData(data: [String: Any]) {
        // example showing volatile data
        self.tealium?.volatileData()?.add(data: ["testVolatileKey": "testVolatileValue"])
    }

    func trackAppearance(_ viewController: UIViewController) {
        if TealiumHelper.isEnabled == false {
            return
        }
        if let id = viewController.view.accessibilityIdentifier {
            track(title: id, data: nil)
            return
        }
        if let title = viewController.title {
            track(title: title, data: nil)
        }
    }

    // track an event
    func track(title: String, data: [String: Any]?) {
        if TealiumHelper.isEnabled == false {
            return
        }
        tealium?.track(title: title,
                       data: data,
                       completion: { (success, info, error) in

                           // Optional post processing
                           if self.enableHelperLogs == false {
                               return
                           }
                           print("*** TealiumHelper: track completed:\n\(success)\n\(String(describing: info))\n\(String(describing: error))")
                       })
    }

    // track a screen view
    func trackView(title: String, data: [String: Any]?) {
        if TealiumHelper.isEnabled == false {
            return
        }
        tealium?.trackView(title: title,
                           data: data,
                           completion: { (success, info, error) in

                               // Optional post processing
                               // Alternatively, monitoring track completions can be done here vs. using the delegate module's callbacks.
                               if self.enableHelperLogs == false {
                                   return
                               }
                               print("*** TealiumHelper: view completed:\n\(success)\n\(String(describing: info))\n\(String(describing: error))")
                           })
    }

    func crash() {
        NSException.raise(NSExceptionName(rawValue: "Exception"), format: "This is a test exception", arguments: getVaList(["nil"]))
    }

}

extension TealiumHelper: TealiumDelegate {

    func tealiumShouldTrack(data: [String: Any]) -> Bool {
        return true
    }

    func tealiumTrackCompleted(success: Bool, info: [String: Any]?, error: Error?) {

        if enableHelperLogs == false {
            return
        }
        print("\n*** Tealium Helper: Tealium Delegate : tealiumTrackCompleted *** Track finished. Was successful:\(success)\nInfo:\(info as AnyObject)\((error != nil) ? "\nError:\(String(describing: error))" : "")")
    }

}
