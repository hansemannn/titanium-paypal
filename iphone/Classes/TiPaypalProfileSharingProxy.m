/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPaypalProfileSharingProxy.h"
#import "TiApp.h"

@implementation TiPaypalProfileSharingProxy

-(NSMutableArray*)scopes
{
    if (scopes == nil) {
        scopes = [NSMutableArray new];
    }
    
    return scopes;
}

#pragma mark Public APIs

-(void)show:(id)args
{
    NSNumber *animated;
    ENSURE_ARG_FOR_KEY(animated, args, @"animated", NSNumber);

    if ([[self scopes] count] == 0) {
        NSLog(@"[ERROR] Ti.PayPal: Cannot request profile sharing without `scoped` defined, aborting!");
        return;
    }
    
    PayPalProfileSharingViewController *sharing = [[PayPalProfileSharingViewController alloc] initWithScopeValues:[NSSet setWithArray:scopes]
                                                                                                    configuration:configuration.configuration
                                                                                                         delegate:self];
    
    [[[[TiApp app] controller] topPresentedController] presentViewController:sharing animated:[TiUtils boolValue:animated def:YES] completion:nil];
}

-(void)setScopes:(id)value
{
    ENSURE_SINGLE_ARG(value, NSArray);
    [[self scopes] removeAllObjects];
    
    for (id scope in (NSArray*)value) {
        ENSURE_TYPE(scope, NSString);
        [[self scopes] addObject:scope];
    }
}

-(void)setConfiguration:(id)value
{
    ENSURE_TYPE(value, TiPaypalConfigurationProxy);
    configuration = value;
}

#pragma mark Delegates

-(void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
{
    if ([self _hasListeners:@"profileSharingDidCancel"]) {
        [self fireEvent:@"profileSharingDidCancel"];
    }
}

-(void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController userWillLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization completionBlock:(PayPalProfileSharingDelegateCompletionBlock)completionBlock
{
    if ([self _hasListeners:@"profileSharingWillLogIn"]) {
        [self fireEvent:@"profileSharingWillLogIn"];
    }
    completionBlock();
}

-(void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization
{
    if ([self _hasListeners:@"profileSharingDidLogIn"]) {
        [self fireEvent:@"profileSharingDidLogIn"];
    }
}

@end
