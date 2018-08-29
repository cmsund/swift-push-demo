//
//  ViewController.swift
//  PushMessagingSample
//
//  Created by Christina on 12/18/17.
//  Copyright © 2017 Christina. All rights reserved.
//
import Foundation
import UIKit
import JJFloatingActionButton
import IBAnimatable

struct LoginState {
    var email: String?

    func isValidEmail() -> Bool {
        guard let email = email else {
            return false
        }
        return email.isValidEmail
    }

}

enum LoginVCStrings {
    static var loginScreenName = "login".localized()
    static var loginButtonTitle = "Login".localized()
    static var emailPlaceholder = "Email".localized()
    static var traceIdPlaceholder = "Trace ID (optional)".localized()
    static var userLoginEvent = "user_login".localized()
}

class LoginViewController: UIViewController {

    @IBOutlet weak var traceId: AnimatableTextField?
    @IBOutlet weak var email: AnimatableTextField?
    @IBOutlet weak var loginButton: UIButton?
    var state: LoginState = LoginState()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.traceId?.delegate = self
        self.email?.delegate = self
        setupTextFields()
        setupButtons()
        initialState()
        TealiumHelper.shared.trackView(title: LoginVCStrings.loginScreenName, data: nil)
    }

    func setupTextFields() {
        guard let email = email else {
            Log.error("Email text field is nil")
            return
        }
        UXElements.setupTextField(textField: email, textFieldType: .email, placeholder: LoginVCStrings.emailPlaceholder)
        guard let traceId = traceId else {
            Log.error("Trace ID text field is nil")
            return
        }
        UXElements.setupTextField(textField: traceId, textFieldType: .number, placeholder: LoginVCStrings.traceIdPlaceholder)
    }

    func setupButtons() {
        guard let loginButton = loginButton else {
            Log.error("Login button is nil")
            return
        }
        UXElements.setupButton(button: loginButton, title: LoginVCStrings.loginButtonTitle)
    }

    func triggerStateChange() {
        stateHasChanged(self.state)
    }

    private func initialState() {
        email?.becomeFirstResponder()
        if let emailInUserDefaults = Persistence.loadStringFromUserDefaults(key: "customer_email") {
            email?.text = emailInUserDefaults
            traceId?.reveal()
            loginButton?.reveal()
        } else {
            traceId?.alpha = 0.0
            loginButton?.alpha = 0.0
        }
    }

    private func resetView() {
        email?.alpha = 0.0
        traceId?.alpha = 0.0
        loginButton?.alpha = 0.0
    }

    override func viewWillDisappear(_ animated: Bool) {
        resetView()
        super.viewWillDisappear(animated)
    }

    private func stateHasChanged(_ state: LoginState) {
        if state.isValidEmail() == true {
            traceId?.reveal()
            loginButton?.reveal()
        } else {
            traceId?.hide()
            loginButton?.hide()
        }
    }

    @IBAction func login(_ sender: Any) {
        let traceIdString = traceId?.text ?? ""
        guard let emailString = email?.text else {
            return
        }
        guard let firebaseToken = Persistence.loadStringFromUserDefaults(key: "firebase_token") else {
            return
        }
        let dataDictionary = ["tealium_trace_id": traceIdString, "customer_email": emailString, "firebase_token": firebaseToken]
        Persistence.saveStringToUserDefaults(string: traceIdString, key: "tealium_trace_id")
        Persistence.saveStringToUserDefaults(string: emailString, key: "customer_email")
        TealiumHelper.shared.addVolitileData(data: ["tealium_trace_id": traceIdString])
        TealiumHelper.shared.track(title: LoginVCStrings.userLoginEvent, data: dataDictionary)
    }

}

extension LoginViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 &&
            string == "" {
            update(textField: textField,
                    string: string)
        } else {
            update(textField: textField,
                    string: textField.text)
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        update(textField: textField,
                string: textField.text)
    }

    func update(textField: UITextField,
                 string: String?) {
        if textField == email { self.state.email = string }
        triggerStateChange()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}





