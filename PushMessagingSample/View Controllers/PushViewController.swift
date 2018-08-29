//
//  PushViewController.swift
//  PushMessagingSample
//
//  Created by Christina on 7/23/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import UIKit

class PushViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TealiumHelper.shared.trackAppearance(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
