//
//  BackgroundManager.swift
//  PushMessagingSample
//
//  Created by Christina on 7/25/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import UIKit

class BackgroundManager {

    static var useVideo: Bool = true

    class func appWindow() -> UIWindow? {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        guard let window = app.window else {
            return nil
        }
        return window
    }

    class func add() {
        if useVideo == true {
            appWindow()?.playBackgroundVideo(name: "teal_dots_lines_02",
                                     type: "mp4")
            return
        }
        appWindow()?.useBackgroundImage(name: "teal_dots.jpg")

    }

    class func pauseVideo() {
        if useVideo == false {
            return
        }
        appWindow()?.pauseBackgroundVideo()
    }

    class func resumeVideo() {
        if useVideo == false {
            return
        }
        appWindow()?.resumeBackgroundVideo()
    }

}
