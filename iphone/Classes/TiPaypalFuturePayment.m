/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPaypalFuturePaymentProxy.h"
#import "TiApp.h"

@implementation TiPaypalFuturePaymentProxy

-(void)dealloc
{
    RELEASE_TO_NIL(futurePaymentDialog);
    
    [self forgetProxy:configuration];
    RELEASE_TO_NIL(configuration);
    
    [super dealloc];
}

#pragma mark Public APIs

-(PayPalFuturePaymentViewController*)futurePaymentDialog
{
    if (futurePaymentDialog == nil) {
        futurePaymentDialog = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:[configuration configuration]
                                                                                      delegate:self];
    }
    
    return futurePaymentDialog;
}

-(void)show:(id)args
{
    ENSURE_UI_THREAD(show, args);
    ENSURE_SINGLE_ARG(args, NSArray);

    id animated = [args valueForKey:@"animated"];
    ENSURE_TYPE_OR_NIL(animated, NSNumber);
    
    [self rememberSelf];

    [[TiApp app] showModalController:[self futurePaymentDialog]
                            animated:[TiUtils boolValue:animated def:YES]];
}

-(void)setConfiguration:(id)value
{
    ENSURE_TYPE(value, TiPaypalConfigurationProxy);
    
    if (configuration) {
        [self forgetProxy:configuration];
        RELEASE_TO_NIL(configuration);
    }
    
    configuration = [value autorelease];
    [self rememberProxy:configuration];
}

#pragma mark Delegates

-(void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController
{
    if ([self _hasListeners:@"futurePaymentDidCancel"]) {
        [self fireEvent:@"futurePaymentDidCancel"];
    }
    
    [[TiApp app] hideModalController:futurePaymentViewController animated:YES];
    [futurePaymentDialog setDelegate:nil];
    RELEASE_TO_NIL(futurePaymentDialog);
}

-(void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController willAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization completionBlock:(PayPalFuturePaymentDelegateCompletionBlock)completionBlock
{
    if ([self _hasListeners:@"futurePaymentWillComplete"]) {
        [self fireEvent:@"futurePaymentWillComplete" withObject:@{@"payment": futurePaymentAuthorization}];
    }
    
    completionBlock();
}

-(void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization
{
    if ([self _hasListeners:@"futurePaymentDidComplete"]) {
        [self fireEvent:@"futurePaymentDidComplete" withObject:@{@"payment": futurePaymentAuthorization}];
    }
    
    [[TiApp app] hideModalController:futurePaymentViewController animated:YES];
    [futurePaymentDialog setDelegate:nil];
    RELEASE_TO_NIL(futurePaymentDialog);
}

@end
