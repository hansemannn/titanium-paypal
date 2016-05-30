
var PayPal = require('ti.paypal');

var item1 = PayPal.createPaymentItem({
	name: "My item",
	price: 23.99,
	sku: "my-item",
	quantity: 1,
	currency: "USD"
});

var configuration = PayPal.createConfiguration({
	merchantName: "John Doe",
	merchantPrivacyPolicyURL: "http://google.com",
	merchantUserAgreementURL: "http://google.com",
	locale: "en"
});

var payment = PayPal.createPayment({
	// Required
	configuration: configuration,
	currencyCode: "USD",
	amount: 23.99,
	shortDescription: "Your shopping trip at FooBar",
	intent: PayPal.PAYMENT_INTENT_SALE,
	// Optional
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

exports.show = function() {
	payment.show({
		animated: true
	});	
};