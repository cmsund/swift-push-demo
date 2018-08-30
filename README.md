![Logo of the project](https://tealium.com/wp-content/uploads/2015/12/tealium_footer_logo_01-206x49.png)

# Push Messaging Demo 
> Push Messaging using Firebase and the Tealium Universal Data Hub

This demo app will allow you to demo push messaging using the Tealium SDK and the Firebase Cloud Messaging connector. You can also use this app to demo generic use cases and tracking clicks/views with the Tealium SDK.

Tealium Employee? Check here for even more setup/configuration options.

## Installing / Getting started

A quick introduction of the minimal setup you need to get the push messaging app up &
running.

```shell
git clone https://github.com/cmsund/swift-push-demo.git
```

* Connect your iPhone
* Select your phone as the build target in Xcode
* Run

The application will build and run on your mobile device. 

### Initial Configuration

You will need an Apple Developer account to run on a device, the push messages do not come through on the Simulator. The application already has three push messages active, but if you would like to load your own profile and configure your own use case, open the Keys folder and open Keys.swift. Update your account/profile/datasource key here:

![](http://christinasund.com/images/keys.png)

```swift
enum Keys {
static let tealiumAccount = "account"
static let tealiumProfile = "profile"
static let tealiumEnvironment = "environment"
static let tealiumDatasource = "datasource key"
}
```

See the [advanced configuration steps here](#advanced-config).

Build and run.

## Features

* Login with and without a trace id
* Multiple customizable call to action, menu buttons, and Tealium event names to allow for other use cases/demos to be configured.
* Three pre-configured use cases that trigger a push message

## Developing

If you would like to update any of the button names, event names, or menu button names to suite your use case, edit the strings located in LoginViewController.swift and ActionViewController.swift:

```swift
enum LoginVCStrings {
static var loginScreenName = "login".localized()
static var loginButtonTitle = "Login".localized()
static var emailPlaceholder = "Email".localized()
static var traceIdPlaceholder = "Trace ID (optional)".localized()
static var userLoginEvent = "user_login".localized()
}
```

```swift
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
```
If you do not need localization (language other than English) for your particular use case, simply remove `.localized()` from the end of each string.

If you would like these strings to be localized, also update them in the Main.strings (in the subdirectory of Main.storyboard). You can also add another .strings file for your locale if your language is anything other than English.

![](http://christinasund.com/images/mainstrings.png)

Updating these strings will allow you to customize button titles and event names streaming into the UDH.

Adding localization will allow you to easily convert the strings to your local language.

### Default Push Messaging Behavior

The push messages are triggered in three different areas:

* After logging in with an email and trace id, tap "Add To Cart" then tap "Kill Trace" from the menu. This one will only work if you are using your own Tealium account/profile and can use Trace in the UDH.

![](http://christinasund.com/images/_cart_abandon.png)

* After logging in with an email, tap "Trigger Push" from the menu. In order to do this repeatedly, you must tap "Reset Push" before selecting "Trigger Push" again. This one will work out of the box.

![](http://christinasund.com/images/_trigger_push.png)

* Put the app into the background by pressing the "Home" button on your device. This one will work out of the box.

![](http://christinasund.com/images/_background.png)

###  <a name="advanced-config" style="color:black">Advanced Configuration</a>

The above examples are a result of the Firebase Cloud Messaging connector that is already configured in the default account/profile. In order to configure your own push message using the FCM connector, please refer to this article: [Firebase Cloud Messaging Connector Setup Guide](https://community.tealiumiq.com/t5/Universal-Data-Hub/Firebase-Cloud-Messaging-Connector-Setup-Guide/ta-p/20269). Be sure to obtain a server key by signing up for a Firebase account and following the instructions [here](https://firebase.google.com/docs/cloud-messaging/ios/client). _You will need to add your own GoogleService-Info.pist to the Keys folder within the PushMessagingSample project._

![](http://christinasund.com/images/fbsetup.png) 


## Issues/Feedback

In order to submit any bug reports or feedback please email christina.sund@tealium.com

