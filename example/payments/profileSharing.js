
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
	Ti.API.warn(e.authorization);
});

profile.addEventListener("profileSharingDidLogIn", function(e) {
	Ti.API.warn("profileSharingDidLogIn");
	Ti.API.warn(e.authorization);
});

exports.show = function() {
	profile.show();
};
