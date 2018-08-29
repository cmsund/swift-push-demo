//
//  UIViews+Fades.swift
//  PushMessagingSample
//
//  Created by Christina on 8/5/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import UIKit

extension UIView {
    func reveal() {
        if self.alpha == 1.0 {
            return
        }
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
            self.isUserInteractionEnabled = true
        }
    }

    func hide() {
        if self.alpha == 0.0 {
            return
        }
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0.0
        }
    }

    func dim() {
        if self.alpha == 0.5 {
            return
        }
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0.5
            self.isUserInteractionEnabled = false
        }
    }
}

