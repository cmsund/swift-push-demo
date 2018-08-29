//
//  Logic.swift
//  PushMessagingSample
//
//  Created by Christina on 7/22/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import UIKit

class Logic {

    class func run(rootViewController: PushViewController) {
        let tasks = [
            Logic.configure(rootViewController),
            Logic.presentLogin(rootViewController)
        ]
        tasks.runAsyncTasks(loops: 1, initialState: nil, completion: nil)
    }

    class func configure(_ viewController: PushViewController) -> AsyncTask {
        return { (session: Any?, taskCompletion: @escaping AsyncTaskCompletion) in
            config()
            taskCompletion(session)
        }
    }

    class func presentLogin(_ viewController: UIViewController) -> AsyncTask {
        return { (session: Any?, taskCompletion: @escaping AsyncTaskCompletion) in
            viewController.performSegue(withIdentifier: "present", sender: nil)
        }
    }
}


