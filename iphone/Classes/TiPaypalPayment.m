/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPaypalPayment.h"
#import "TiUtils.h"
#import "TiApp.h"

@implementation TiPaypalPayment

-(PayPalPayment *)payment
{
    if (payment == nil) {
        payment = [PayPalPayment new];
    }
}

-(void)show:(id)args
{
    NSNumber *animated;
    ENSURE_ARG_FOR_KEY(animated, args, @"animated", NSNumber);
    
    if (![payment processable]) {
        NSLog(@"[ERROR] Ti.PayPal: Payment is not processable, dialog aborted!");
        return;
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:configuration.configuration
                                                                                                     delegate:self];

    [[[[TiApp app] controller] topPresentedController] presentViewController:paymentViewController
                                                                    animated:[TiUtils boolValue:animated def:YES]
                                                                  completion:nil];
}

-(void)setConfiguration:(id)value
{
    ENSURE_TYPE(value, TiPayPalConfiguration);
    configuration = value;
}

#pragma mark - Delegates

#pragma mark Simple payments

-(void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    if ([self _hasListeners:@"paymentDidCancel"]) {
        [self fireEvent:@"paymentDidCancel"];
    }
}

-(void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController willCompletePayment:(PayPalPayment *)completedPayment completionBlock:(PayPalPaymentDelegateCompletionBlock)completionBlock
{
    if ([self _hasListeners:@"paymentWillComplete"]) {
        [self fireEvent:@"paymentWillComplete"];
    }
    completionBlock();
}

-(void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    if ([self _hasListeners:@"paymentDidComplete"]) {
        [self fireEvent:@"paymentDidComplete"];
    }
}

@end
