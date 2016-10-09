/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiPaypalModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiPaypalModule

#pragma mark Internal

-(id)moduleGUID
{
	return @"799af6ef-dece-432a-8ec0-723579b2c823";
}

-(NSString*)moduleId
{
	return @"ti.paypal";
}

#pragma mark Lifecycle

-(void)startup
{
	[super startup];
	NSLog(@"[INFO] %@ loaded",self);
}

#pragma - Public APIs

/**
 *  Initializes the PayPal module
 *
 *  @param args The client id keys for sandbox and production as well as the environment
 */
- (void)initialize:(id)args
{
    ENSURE_TYPE(args, NSArray);
    args = [args objectAtIndex:0];
    
    NSString *clientIdProduction;
    NSString *clientIdSandbox;
    NSString *environment;
    
    ENSURE_ARG_FOR_KEY(clientIdProduction, args, @"clientIdProduction", NSString);
    ENSURE_ARG_FOR_KEY(clientIdSandbox, args, @"clientIdSandbox", NSString);
    ENSURE_ARG_FOR_KEY(environment, args, @"environment", NSString);
    
    TiThreadPerformOnMainThread(^{
        [PayPalMobile initializeWithClientIdsForEnvironments:@{
            PayPalEnvironmentProduction : clientIdProduction,
            PayPalEnvironmentSandbox : clientIdSandbox
        }];
        
        [PayPalMobile preconnectWithEnvironment:environment];
    }, NO);
}

-(NSString*)clientMetadataID
{
    return [PayPalMobile clientMetadataID];
}

-(NSString*)libraryVersion
{
    return [PayPalMobile libraryVersion];
}

-(void)clearAllUserData:(id)unused
{
    [PayPalMobile clearAllUserData];
}

MAKE_SYSTEM_STR(ENVIRONMENT_PRODUCTION, PayPalEnvironmentProduction);
MAKE_SYSTEM_STR(ENVIRONMENT_SANDBOX, PayPalEnvironmentSandbox);
MAKE_SYSTEM_STR(ENVIRONMENT_NO_NETWORK, PayPalEnvironmentNoNetwork);

MAKE_SYSTEM_PROP(PAYMENT_INTENT_SALE, PayPalPaymentIntentSale);
MAKE_SYSTEM_PROP(PAYMENT_INTENT_AUTHORIZE, PayPalPaymentIntentAuthorize);
MAKE_SYSTEM_PROP(PAYMENT_INTENT_ORDER, PayPalPaymentIntentOrder);

MAKE_SYSTEM_STR(SCOPE_FUTURE_PAYMENTS, kPayPalOAuth2ScopeFuturePayments);
MAKE_SYSTEM_STR(SCOPE_PROFILE, kPayPalOAuth2ScopeProfile);
MAKE_SYSTEM_STR(SCOPE_OPEN_ID, kPayPalOAuth2ScopeOpenId);
MAKE_SYSTEM_STR(SCOPE_PAYPAL_ATTRIBUTES, kPayPalOAuth2ScopePayPalAttributes);
MAKE_SYSTEM_STR(SCOPE_EMAIL, kPayPalOAuth2ScopeEmail);
MAKE_SYSTEM_STR(SCOPE_ADDRESS, kPayPalOAuth2ScopeAddress);
MAKE_SYSTEM_STR(SCOPE_PHONE, kPayPalOAuth2ScopePhone);

MAKE_SYSTEM_PROP(PAYPAL_SHIPPING_ADDRESS_OPTION_NONE, PayPalShippingAddressOptionNone);
MAKE_SYSTEM_PROP(PAYPAL_SHIPPING_ADDRESS_OPTION_PROVIDED, PayPalShippingAddressOptionProvided);
MAKE_SYSTEM_PROP(PAYPAL_SHIPPING_ADDRESS_OPTION_PAYPAL, PayPalShippingAddressOptionPayPal);
MAKE_SYSTEM_PROP(PAYPAL_SHIPPING_ADDRESS_OPTION_BOTH, PayPalShippingAddressOptionBoth);

@end
