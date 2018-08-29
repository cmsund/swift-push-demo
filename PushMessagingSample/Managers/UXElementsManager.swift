//
//  UXElements.swift
//  PushMessagingSample
//
//  Created by Christina on 8/4/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import Foundation
import IBAnimatable

enum UXTextFieldType {
    case password
    case email
    case number
    case text
}

class UXElements {

    class func setupTextField(textField: AnimatableTextField, textFieldType: UXTextFieldType, placeholder: String?) {
        textField.textColor = .white
        textField.backgroundColor = UIColor.dim()
        if let placeholder = placeholder {
            textField.placeholder = placeholder
        }
        textField.placeholderColor = .lightGray
        switch (textFieldType) {
        case .password:
            textField.isSecureTextEntry = true
            textField.autocorrectionType = .no
            break
        case .email:
            textField.autocorrectionType = .no
            break
        case .number:
            textField.keyboardType = UIKeyboardType.numberPad
            break
        default:
            break
        }
    }

    class func setupButton(button: UIButton, title: String?) {
        if let title = title {
            button.setTitle(title, for: .normal)
        }
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.tealiumColor.purple
    }

}
