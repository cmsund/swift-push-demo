//
//  MenuManager.swift
//  PushMessagingSample
//
//  Created by Christina on 7/30/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import UIKit
import JJFloatingActionButton

class MenuButton {

    let actionButton = JJFloatingActionButton()

    func configure(buttonColor: UIColor?, buttonImageColor: UIColor?) {
        actionButton.buttonImage = UIImage(named: "Dots")
        actionButton.buttonColor = UIColor(displayP3Red: 9.0, green: 102.0, blue: 153.0, alpha: 0.5)
        actionButton.buttonImageColor = UIColor(displayP3Red: 9.0, green: 102.0, blue: 153.0, alpha: 1)
        guard let buttonColor = buttonColor else {
            Log.error("buttonColor is nil")
            return
        }
        actionButton.buttonColor = buttonColor
        guard let buttonImageColor = buttonImageColor else {
            Log.error("buttonImageColor is nil")
            return
        }
        actionButton.buttonImageColor = buttonImageColor
        actionButton.layer.shadowColor = UIColor.black.cgColor
        actionButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        actionButton.layer.shadowOpacity = Float(0.4)
        actionButton.layer.shadowRadius = CGFloat(2)
        actionButton.itemSizeRatio = CGFloat(0.75)
        actionButton.configureDefaultItem { item in
            item.titleLabel.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
            item.titleLabel.textColor = .white
            item.buttonColor = buttonColor
            item.buttonImageColor = buttonImageColor
            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.shadowOffset = CGSize(width: 0, height: 1)
            item.layer.shadowOpacity = Float(0.4)
            item.layer.shadowRadius = CGFloat(2)
        }
    }

}

