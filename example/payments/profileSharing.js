
var PayPal = require('ti.paypal');

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
});

profile.addEventListener("profileSharingDidLogIn", function(e) {
	Ti.API.warn("profileSharingDidLogIn");
});

exports.show = function() {
	profile.show();
};
