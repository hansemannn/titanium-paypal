/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import "PayPalMobile.h"
#import "TiPayPalConfiguration.h"

@interface TiPaypalPayment : TiProxy <PayPalPaymentDelegate> {
    TiPayPalConfiguration *configuration;
    PayPalPayment *payment;
}

-(PayPalPayment*)payment;

-(void)show:(id)args;

@end
