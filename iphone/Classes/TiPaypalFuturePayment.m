/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPaypalFuturePayment.h"
#import "TiApp.h"

@implementation TiPaypalFuturePayment

#pragma mark Public APIs

-(void)show:(id)args
{
    NSNumber *animated;
    ENSURE_ARG_FOR_KEY(animated, args, @"animated", NSNumber);

    PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc]
                                                                      initWithConfiguration:configuration.configuration
                                                                      delegate:self];
    
    [[[[TiApp app] controller] topPresentedController] presentViewController:futurePaymentViewController
                                                                    animated:[TiUtils boolValue:animated def:YES]
                                                                  completion:nil];
}

-(void)setConfiguration:(id)value
{
    ENSURE_TYPE(value, TiPayPalConfiguration);
    configuration = value;
}

#pragma mark Delegates

-(void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController
{
    if ([self _hasListeners:@"futurePaymentDidCancel"]) {
        [self fireEvent:@"futurePaymentDidCancel"];
    }
}

-(void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController willAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization completionBlock:(PayPalFuturePaymentDelegateCompletionBlock)completionBlock
{
    if ([self _hasListeners:@"futurePaymentWillComplete"]) {
        [self fireEvent:@"futurePaymentWillComplete"];
    }
    completionBlock();
    
}

-(void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization
{
    if ([self _hasListeners:@"futurePaymentDidComplete"]) {
        [self fireEvent:@"futurePaymentDidComplete"];
    }
}

@end
