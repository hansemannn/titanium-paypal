
var PayPal = require('ti.paypal');

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

exports.show = function() {
	payment.show();	
};