
var PayPal = require('ti.paypal'),
	SimplePayment = require("payments/simplePayment"),
	FuturePayment = require("payments/futurePayment"),
	ProfileSharing = require("payments/profileSharing");

PayPal.initialize({
	clientIdSandbox: "123",
	clientIdProduction: "456",
	environment: PayPal.ENVIRONMENT_SANDBOX
});

var window = Ti.UI.createWindow({
	backgroundColor: "#fff",
	layout: "vertical"
});

window.add(createButton("Simple Payment", doSimplePayment));
window.add(createButton("Future Payment", doFuturePayment));
window.add(createButton("Profile Sharing", doProfileSharing));

function createButton(title, cb) {
	var btn = Ti.UI.createButton({
		title: title,
		width: 300,
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