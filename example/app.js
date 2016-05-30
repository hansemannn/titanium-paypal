
var PayPal = require('ti.paypal'),
	SimplePayment = require("payments/simplePayment"),
	FuturePayment = require("payments/futurePayment"),
	ProfileSharing = require("payments/profileSharing");

PayPal.initialize({
	clientIdSandbox: "<YOUR_CLIENT_ID_SANDBOX>",
	clientIdProduction: "<YOUR_CLIENT_ID_PRODUCTION>",
	environment: PayPal.ENVIRONMENT_SANDBOX // or: ENVIRONMENT_PRODUCTION
});

var window = Ti.UI.createWindow({
	backgroundColor: "#fff",
	layout: "vertical"
});

window.add(createButton("Simple Payment", doSimplePayment));
window.add(createButton("Future Payment", doFuturePayment));
window.add(createButton("Profile Sharing", doProfileSharing));

window.open();

function createButton(title, cb) {
	var btn = Ti.UI.createButton({
		title: title,
		width: 300,
		color: "#fff",
		height: 40,
		backgroundColor: "#333",
		top: 40
	});
	
	btn.addEventListener("click", cb);
	
	return btn;
}

function doSimplePayment() {
	SimplePayment.show();
}

function doFuturePayment() {
	FuturePayment.show();
}

function doProfileSharing() {
	ProfileSharing.show();
}