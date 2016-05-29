
var PayPal = require('ti.paypal');

var configuration = PayPal.createConfiguration({
	merchantName: "John Doe",
	merchantPrivacyPolicyURL: "http://google.com",
	merchantUserAgreementURL: "http://google.com",
	locale: "de"
});

var payment = PayPal.createFuturePayment({
	configuration: configuration
});

payment.addEventListener("futurePaymentDidCancel", function(e) {
	Ti.API.warn("futurePaymentDidCancel");
});

payment.addEventListener("futurePaymentWillComplete", function(e) {
	Ti.API.warn("futurePaymentWillComplete");
});

payment.addEventListener("futurePaymentDidComplete", function(e) {
	Ti.API.warn("futurePaymentDidComplete");
});

exports.show = function() {
	payment.show();	
};