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
    RELEASE_TO_NIL(profileSharingDialog);
    RELEASE_TO_NIL(scopes);
    
    [self forgetProxy:configuration];
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

-(PayPalProfileSharingViewController*)profileSharingDialog
{
    if (profileSharingDialog == nil) {
        profileSharingDialog = [[PayPalProfileSharingViewController alloc] initWithScopeValues:[NSSet setWithArray:[self scopes]]
                                                                                 configuration:[configuration configuration]
                                                                                      delegate:self];
    }
    
    return profileSharingDialog;
}


#pragma mark Public APIs

-(void)show:(id)args
{
    ENSURE_UI_THREAD(show, args);
    ENSURE_SINGLE_ARG_OR_NIL(args, NSArray);

    BOOL animated = [TiUtils boolValue:@"animated" properties:args def:YES];

    if ([[self scopes] count] == 0) {
        NSLog(@"[ERROR] Ti.PayPal: Cannot request profile sharing without `scopes` defined, aborting!");
        return;
    }
    
    [self rememberSelf];

    [[TiApp app] showModalController:[self profileSharingDialog]
                            animated:animated];
}

-(void)setScopes:(id)args
{
    ENSURE_TYPE(args, NSArray);
    [[self scopes] removeAllObjects];
    
    for (id scope in (NSArray*)args) {
        ENSURE_TYPE(scope, NSString);
        [[self scopes] addObject:[TiUtils stringValue:scope]];
    }
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

-(void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
{
    if ([self _hasListeners:@"profileSharingDidCancel"]) {
        [self fireEvent:@"profileSharingDidCancel"];
    }
    
    [[TiApp app] hideModalController:profileSharingViewController animated:YES];
    [profileSharingDialog setDelegate:nil];
    RELEASE_TO_NIL(profileSharingDialog);
}

-(void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController userWillLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization completionBlock:(PayPalProfileSharingDelegateCompletionBlock)completionBlock
{
    if ([self _hasListeners:@"profileSharingWillLogIn"]) {
        [self fireEvent:@"profileSharingWillLogIn" withObject:@{@"authorization": profileSharingAuthorization}];
    }
    completionBlock();
}

-(void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization
{
    if ([self _hasListeners:@"profileSharingDidLogIn"]) {
        [self fireEvent:@"profileSharingDidLogIn" withObject:@{@"authorization": profileSharingAuthorization}];
    }

    [[TiApp app] hideModalController:profileSharingViewController animated:YES];
    [profileSharingDialog setDelegate:nil];
    RELEASE_TO_NIL(profileSharingDialog);
}

@end
