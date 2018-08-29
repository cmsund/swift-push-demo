//
//  LoginViewController.swift
//  PushMessagingSample
//
//  Created by Christina on 1/29/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import UIKit
import FirebaseInstanceID
import IBAnimatable


// Change Button Titles Here
enum ActionVCButtonTitles {
    static var button1 = "Add To Cart".localized()
    static var button2 = "Purchase".localized()
    static var button3 = "Reset Trace".localized()
    static var button4 = "Call To Action 1".localized()
    static var button5 = "Call To Action 2".localized()
    static var button6 = "Call To Action 3".localized()
}

// Change Menu Button Titles Here
enum ActionVCMenuButtonTitles {
    static var menu1 = "Trigger Push".localized()
    static var menu2 = "Reset Push".localized()
    static var menu3 = "Kill Trace".localized()
}

// Change Event Names Here (Buttons and Menu Buttons)
enum ActionVCEventNames {
    static var event1 = "cart_add".localized()
    static var event2 = "order_confirm".localized()
    static var event3 = "reset".localized()
    static var event4 = "".localized()
    static var event5 = "".localized()
    static var event6 = "".localized()
    static var killTrace = "kill_visitor_session" // localization not needed
    static var triggerPush = "trigger_push_message".localized()
    static var resetPush = "reset_push".localized()

}


class ActionViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupButtons()
        setUpMenuButtons()
        guard let emailString = Persistence.loadStringFromUserDefaults(key: "customer_email") else {
            return
        }
        let data = ["customer_email": emailString, "customer_id": DefaultData.customer_id]
        TealiumHelper.shared.trackView(title: "dashboard_view", data: data)
    }

    private func setupButtons() {
        UXElements.setupButton(button: button1, title: ActionVCButtonTitles.button1)
        UXElements.setupButton(button: button2, title: ActionVCButtonTitles.button2)
        UXElements.setupButton(button: button3, title: ActionVCButtonTitles.button3)
        UXElements.setupButton(button: button4, title: ActionVCButtonTitles.button4)
        UXElements.setupButton(button: button5, title: ActionVCButtonTitles.button5)
        UXElements.setupButton(button: button6, title: ActionVCButtonTitles.button6)
    }

    private func setUpMenuButtons() {
        let menuButton = MenuButton()
        menuButton.actionButton.addItem(title: ActionVCMenuButtonTitles.menu1, image: #imageLiteral(resourceName: "Like")) { item in
            TealiumHelper.shared.track(title: ActionVCEventNames.triggerPush, data: nil)
        }
        menuButton.actionButton.addItem(title: ActionVCMenuButtonTitles.menu2, image: UIImage(named: "Second")?.withRenderingMode(.alwaysTemplate)) { item in
            TealiumHelper.shared.track(title: ActionVCEventNames.resetPush, data: nil)
        }
        menuButton.actionButton.addItem(title: ActionVCMenuButtonTitles.menu3, image: UIImage(named: "X")?.withRenderingMode(.alwaysTemplate)) { item in
            self.killTrace()
        }
        menuButton.actionButton.display(inViewController: self)
    }
    
    private func resetView() {
        button1?.alpha = 0.0
        button2?.alpha = 0.0
        button3?.alpha = 0.0
        button4?.alpha = 0.0
        button5?.alpha = 0.0
        button6?.alpha = 0.0
    }

    private func killTrace() {
        if let UserDefaultsTraceId = Persistence.loadStringFromUserDefaults(key: "tealium_trace_id") {
            let data = ["event": ActionVCEventNames.killTrace, "cp.trace_id": UserDefaultsTraceId]
            TealiumHelper.shared.track(title: ActionVCEventNames.event3, data: data)
            Persistence.purgeStringFromUserDefaults(key: "tealium_trace_id")
        }
    }

    // Functionality for buttons - Pass in custom data dictionary or add/update DefaultData.swift
    @IBAction func onButtonOneTap(_ sender: Any) {
        TealiumHelper.shared.track(title: ActionVCEventNames.event1
                                             , data: DefaultData.addToCartData)
    }

    @IBAction func onButtonTwoTap(_ sender: Any) {
        guard let emailString = Persistence.loadStringFromUserDefaults(key: "customer_email") else {
            return
        }
        DefaultData.orderData["customer_email"] = emailString
        TealiumHelper.shared.trackView(title: ActionVCEventNames.event2, data: DefaultData.orderData)
    }

    @IBAction func onButtonThreeTap() {
        self.killTrace()
    }

    override func viewWillDisappear(_ animated: Bool) {
        resetView()
        super.viewWillDisappear(animated)
    }

}
