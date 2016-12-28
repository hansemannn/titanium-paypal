# Ti.PayPal
[![Build Status](https://travis-ci.org/hansemannn/ti.paypal.svg?branch=master)](https://travis-ci.org/hansemannn/ti.paypal) [![License](http://hans-knoechel.de/shields/shield-license.svg)](./LICENSE)  [![Support](http://hans-knoechel.de/shields/shield-slack.svg)](http://tislack.org)

<img width="976" src="https://abload.de/img/showcase3vronaax58.png">

 Summary
---------------
Ti.PayPal is an open-source project to support the PayPal iOS-SDK 2.x in Appcelerator's Titanium Mobile. The module currently supports the following API's:
- [x] Simple Payments
- [x] Future Payments
- [x] Merchant Configuration

> Note: This is the iOS version of Ti.PayPal. You might want to check [appwert/ti.paypal](https://github.com/AppWerft/Ti.Paypal) for the Android equivalent 🚀.

Requirements
---------------
  - Titanium Mobile SDK 5.2.0.GA or later
  - iOS 7.1 or later
  - Xcode 7.0 or later

Download + Setup
---------------

### Download
  * [Stable release](https://github.com/hansemannn/ti.paypal/releases)

### Setup
Unpack the module and place it inside the `modules/iphone/` folder of your project.
Edit the modules section of your `tiapp.xml` file to include this module:
```xml
<modules>
    <module platform="iphone">ti.paypal</module>
</modules>
```

Integrate the following snippet in your tiapp.xml. It is used to enable 1Password support
that is used by the PayPal-SDK:
```xml
<ios>
    <plist>
        <dict>
            <key>LSApplicationQueriesSchemes</key>
            <array>
                <string>com.paypal.ppclient.touch.v1</string>
                <string>com.paypal.ppclient.touch.v2</string>
                <string>org-appextension-feature-password-management</string>
            </array>
        </dict>
    </plist>
</ios>
```

Initialize the module by setting the PayPal credentials which you can get from [here](https://developer.paypal.com).
```javascript
var PayPal = require("ti.paypal");
PayPal.initialize({
    clientIdSandbox: "<YOUR_CLIENT_ID_SANDBOX>",
    clientIdProduction: "<YOUR_CLIENT_ID_PRODUCTION>",
    environment: PayPal.ENVIRONMENT_SANDBOX // or: ENVIRONMENT_PRODUCTION, or: ENVIRONMENT_NO_NETWORK
});
```

Features
--------------------------------
#### Simple Payment
A simple payment is used for do instant payments with items you define. Watch the events for updates on your transaction.

```javascript

var item1 = PayPal.createPaymentItem({
    name: "My item",
    price: 23.99,
    sku: "my-item",
    quantity: 1,
    currency: "USD" // Any ISO-4217
});

var configuration = PayPal.createConfiguration({
    merchantName: "John Doe",
    merchantPrivacyPolicyURL: "http://google.com",
    merchantUserAgreementURL: "http://google.com",
    locale: "en" // Any ISO 639-1
});

var payment = PayPal.createPayment({
    // Required
    configuration: configuration,
    currencyCode: "USD",
    amount: 23.99, // Has to match the amount of your items if you set them
    shortDescription: "Your shopping trip at FooBar",
    intent: PayPal.PAYMENT_INTENT_SALE, // or: PAYMENT_INTENT_AUTHORIZE, PAYMENT_INTENT_ORDER
    
    // Optional, you can also just specify the amount
    items: [item1]
});

payment.addEventListener("paymentDidCancel", function(e) {
	Ti.API.warn("paymentDidCancel");
});

payment.addEventListener("paymentWillComplete", function(e) {
	Ti.API.warn("paymentWillComplete");
    Ti.API.warn(e.payment);
});

payment.addEventListener("paymentDidComplete", function(e) {
	Ti.API.warn("paymentDidComplete");
    Ti.API.warn(e.payment);
});

payment.show();	
```

#### Future Payment
A future payment is used to ask the buyer for the permission to charge his account later.

```javascript
var configuration = PayPal.createConfiguration({
    merchantName: "John Doe",
    merchantPrivacyPolicyURL: "http://google.com",
    merchantUserAgreementURL: "http://google.com",
    locale: "en"
});

var payment = PayPal.createFuturePayment({
    configuration: configuration
});

payment.addEventListener("futurePaymentDidCancel", function(e) {
    Ti.API.warn("futurePaymentDidCancel");
});

payment.addEventListener("futurePaymentWillComplete", function(e) {
    Ti.API.warn("futurePaymentWillComplete");
    Ti.API.warn(e.payment);
});

payment.addEventListener("futurePaymentDidComplete", function(e) {
    Ti.API.warn("futurePaymentDidComplete");
    Ti.API.warn(e.payment);
});

payment.show();	
```

#### Profile Sharing
Profile sharing is used to share a user profile by defining different scopes that can be authorized. Available Scopes:

- [x] SCOPE_FUTURE_PAYMENTS
- [x] SCOPE_PROFILE
- [x] SCOPE_OPEN_ID
- [x] SCOPE_PAYPAL_ATTRIBUTES
- [x] SCOPE_EMAIL
- [x] SCOPE_ADDRESS
- [x] SCOPE_PHONE

```javascript
var configuration = PayPal.createConfiguration({
    merchantName: "John Doe",
    merchantPrivacyPolicyURL: "http://google.com",
    merchantUserAgreementURL: "http://google.com",
    locale: "en"
});

var profile = PayPal.createProfileSharing({
    configuration: configuration,
    scopes: [PayPal.SCOPE_PROFILE, PayPal.SCOPE_EMAIL]
});

profile.addEventListener("profileSharingDidCancel", function(e) {
    Ti.API.warn("profileSharingDidCancel");
});

profile.addEventListener("profileSharingWillLogIn", function(e) {
    Ti.API.warn("profileSharingWillLogIn");
    Ti.API.warn(e.authorization);
});

profile.addEventListener("profileSharingDidLogIn", function(e) {
    Ti.API.warn("profileSharingDidLogIn");
    Ti.API.warn(e.authorization);
});

profile.show();
```

#### Example
For a full example covering all API's, check the demo in `iphone/example/app.js`.

Author
---------------
Hans Knoechel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))

License
---------------
Apache 2.0

Contributing
---------------
Code contributions are greatly appreciated, please submit a new [pull request](https://github.com/hansemannn/ti.paypal/pull/new/master)!
