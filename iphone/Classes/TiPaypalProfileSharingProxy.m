/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPaypalProfileSharingProxy.h"
#import "TiApp.h"

@implementation TiPaypalProfileSharingProxy

-(void)dealloc
{
    RELEASE_TO_NIL(scopes);
    RELEASE_TO_NIL(profileSharingDialog);
    RELEASE_TO_NIL(configuration);
    
    [super dealloc];
}

-(NSMutableArray*)scopes
{
    if (scopes == nil) {
        scopes = [[NSMutableArray alloc] init];
    }
    
    return scopes;
}

#pragma mark Public APIs

-(void)show:(id)args
{
    id animated = [args valueForKey:@"animated"];
    ENSURE_TYPE_OR_NIL(animated, NSNumber);

    if ([[self scopes] count] == 0) {
        NSLog(@"[ERROR] Ti.PayPal: Cannot request profile sharing without `scopes` defined, aborting!");
        return;
    }
    
    profileSharingDialog = [[PayPalProfileSharingViewController alloc] initWithScopeValues:[NSSet setWithArray:[self scopes]]
                                                                             configuration:[configuration configuration]
                                                                                  delegate:self];
    
    [[[[TiApp app] controller] topPresentedController] presentViewController:profileSharingDialog
                                                                    animated:[TiUtils boolValue:animated def:YES]
                                                                  completion:nil];
}

-(void)setScopes:(id)args
{
    ENSURE_SINGLE_ARG(args, NSArray);
    [[self scopes] removeAllObjects];
    
    for (id scope in (NSArray*)args) {
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
    [profileSharingDialog dismissViewControllerAnimated:YES completion:nil];
    RELEASE_TO_NIL(profileSharingDialog);
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
    [profileSharingDialog dismissViewControllerAnimated:YES completion:nil];
    RELEASE_TO_NIL(profileSharingDialog);
}

@end
