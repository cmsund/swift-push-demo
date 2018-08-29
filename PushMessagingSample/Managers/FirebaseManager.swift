//
//  FirebaseManager.swift
//  PushMessagingSample
//
//  Created by Christina on 7/22/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications

enum FirebaseManagerError: Error {
    case couldNotRetrieveFirebaseInstanceIDToken
}

class FirebaseManager: NSObject {

    static let shared = FirebaseManager()
    var didStart = false

    func start(_ completion: @escaping () -> ()) {
        if didStart == true { return }
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        firebaseToken()
        didStart = true
        completion()
    }

    // Turn on/off direct connection to Firebase
    func connectToFirebaseCloudMessaging(enable: Bool) {
        Messaging.messaging().shouldEstablishDirectChannel = enable
    }

    // Get Firebase token and save to persistence
    func firebaseToken() {
        guard let firebaseToken = InstanceID.instanceID().token() else {
            return
        }
        Persistence.saveStringToUserDefaults(string: firebaseToken, key: "firebase_token")
    }

}

extension FirebaseManager: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }

}


extension FirebaseManager: MessagingDelegate {

    // Get Firebase token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        connectToFirebaseCloudMessaging(enable: true)
    }

}
