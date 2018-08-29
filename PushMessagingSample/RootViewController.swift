//
//  RootViewController.swift
//  PushMessagingSample
//
//  Created by Christina on 7/23/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import UIKit

class RootViewController: PushViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logic.run(rootViewController: self)
    }
    
}
