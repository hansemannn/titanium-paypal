/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPayPalConfiguration.h"
#import "TiUtils.h"

@implementation TiPayPalConfiguration

-(PayPalConfiguration *)configuration
{
    if (configuration == nil) {
        configuration = [PayPalConfiguration new];
        
        // TODO: Map all properties to public API
        configuration.acceptCreditCards = NO;                
        configuration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    }
    
    return configuration;
}

#pragma mark Public APIs

-(void)setMerchantName:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [[self configuration] setMerchantName:[TiUtils stringValue:value]];
}

-(void)setLocale:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [[self configuration] setLanguageOrLocale:[TiUtils stringValue:value]];
}

-(void)setMerchantPrivacyPolicyURL:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [[self configuration] setMerchantPrivacyPolicyURL:[NSURL URLWithString:[TiUtils stringValue:value]]];
}

-(void)setMerchantUserAgreementURL:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [[self configuration] setMerchantUserAgreementURL:[NSURL URLWithString:[TiUtils stringValue:value]]];
}

@end
