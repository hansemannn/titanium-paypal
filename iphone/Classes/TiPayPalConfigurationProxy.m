/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPaypalConfigurationProxy.h"
#import "TiUtils.h"

@implementation TiPaypalConfigurationProxy

-(PayPalConfiguration *)configuration
{
    if (configuration == nil) {
        configuration = [PayPalConfiguration new];
        
        // TODO: Map all properties to public API
        configuration.acceptCreditCards = NO;                
        configuration.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
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

-(void)setDefaultUserEmail:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [[self configuration] setDefaultUserEmail:[TiUtils stringValue:value]];
}

-(void)setDefaultUserPhoneNumber:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [[self configuration] setDefaultUserPhoneNumber:[TiUtils stringValue:value]];
}

-(void)setDefaultUserPhoneCountryCode:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [[self configuration] setDefaultUserPhoneCountryCode:[TiUtils stringValue:value]];
}

-(void)setAcceptCreditCards:(id)value
{
    ENSURE_SINGLE_ARG(value, NSNumber);
    [[self configuration] setAcceptCreditCards:[TiUtils boolValue:value def:YES]];
}

-(void)setAlwaysDisplayCurrencyCodes:(id)value
{
    ENSURE_SINGLE_ARG(value, NSNumber);
    [[self configuration] setAlwaysDisplayCurrencyCodes:[TiUtils boolValue:value def:NO]];
}

-(void)setDisableBlurWhenBackgrounding:(id)value
{
    ENSURE_SINGLE_ARG(value, NSNumber);
    [[self configuration] setDisableBlurWhenBackgrounding:[TiUtils boolValue:value def:NO]];
}

-(void)setPresentingInPopover:(id)value
{
    ENSURE_SINGLE_ARG(value, NSNumber);
    [[self configuration] setPresentingInPopover:[TiUtils boolValue:value def:NO]];
}

-(void)setForceDefaultsInSandbox:(id)value
{
    ENSURE_SINGLE_ARG(value, NSNumber);
    [[self configuration] setForceDefaultsInSandbox:[TiUtils boolValue:value def:NO]];
}

-(void)setSandboxUserPassword:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [[self configuration] setSandboxUserPassword:[TiUtils stringValue:value]];
}

-(void)setSandboxUserPin:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [[self configuration] setSandboxUserPin:[TiUtils stringValue:value]];
}

-(void)setPayPalShippingAddressOption:(id)value
{
    ENSURE_SINGLE_ARG(value, NSNumber);
    [[self configuration] setPayPalShippingAddressOption:[TiUtils intValue:value def:PayPalShippingAddressOptionNone]];
}

-(void)setRememberUser:(id)value
{
    ENSURE_SINGLE_ARG(value, NSNumber);
    [[self configuration] setRememberUser:[TiUtils boolValue:value def:NO]];
}

-(void)setDisableShakeAnimations:(id)value
{
    ENSURE_SINGLE_ARG(value, NSNumber);
    [[self configuration] setDisableShakeAnimations:[TiUtils boolValue:value def:NO]];
}

@end
