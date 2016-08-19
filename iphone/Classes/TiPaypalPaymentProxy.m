/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPaypalPaymentProxy.h"
#import "TiPaypalPaymentItemProxy.h"
#import "TiUtils.h"
#import "TiApp.h"

@implementation TiPaypalPaymentProxy

-(void)dealloc
{
    RELEASE_TO_NIL(payment);
    RELEASE_TO_NIL(paymentDialog);
    RELEASE_TO_NIL(configuration);
    
    [super dealloc];
}

-(PayPalPayment *)payment
{
    if (payment == nil) {
        payment = [PayPalPayment new];
    }
    
    return payment;
}

-(PayPalPaymentViewController*)paymentDialog
{
    if (paymentDialog == nil) {
        paymentDialog = [[PayPalPaymentViewController alloc] initWithPayment:[self payment]
                                                               configuration:[configuration configuration]
                                                                    delegate:self];
    }
    
    return paymentDialog;
}

-(void)show:(id)args
{
    id animated = [args valueForKey:@"animated"];
    ENSURE_TYPE_OR_NIL(animated, NSNumber);
    
    if (![[self payment] processable]) {
        NSLog(@"[ERROR] Ti.PayPal: Payment is not processable, dialog aborted!");
        return;
    }

    TiThreadPerformOnMainThread(^{
        [[TiApp app] showModalController:[self paymentDialog]
                                animated:[TiUtils boolValue:animated def:YES]];
    }, YES);
}

-(void)setConfiguration:(id)value
{
    ENSURE_TYPE(value, TiPaypalConfigurationProxy);
    configuration = value;
}

-(void)setItems:(id)value
{
    ENSURE_TYPE(value, NSArray);
    NSMutableArray *result = [NSMutableArray new];
    
    for (id item in (NSArray*)value) {
        ENSURE_TYPE(item, TiPaypalPaymentItemProxy);
        TiPaypalPaymentItemProxy *proxy = (TiPaypalPaymentItemProxy*)item;
        [result addObject:[proxy item]];
    }

   [[self payment] setItems:result];
    RELEASE_TO_NIL(result);
}

-(void)setCurrencyCode:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self payment] setCurrencyCode:[TiUtils stringValue:value]];
}

-(void)setAmount:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    [[self payment] setAmount:[NSDecimalNumber decimalNumberWithDecimal:[[TiUtils numberFromObject:value] decimalValue]]];
}

-(void)setShortDescription:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self payment] setShortDescription:[TiUtils stringValue:value]];
}

-(void)setIntent:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    [[self payment] setIntent:[TiUtils intValue:value def:PayPalPaymentIntentSale]];
}

-(void)setSoftDescriptor:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self payment] setSoftDescriptor:[TiUtils stringValue:value]];
}

-(void)setCustom:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self payment] setCustom:[TiUtils stringValue:value]];
}

-(void)setInvoiceNumber:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self payment] setInvoiceNumber:[TiUtils stringValue:value]];
}

-(void)setBnCode:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self payment] setBnCode:[TiUtils stringValue:value]];
}

-(void)setShippingAddress:(id)args
{
    ENSURE_TYPE(args, NSDictionary);
    
    NSString *recipientName;
    NSString *line1;
    NSString *city;
    NSString *countryCode;
    
    NSString *line2;
    NSString *state;
    NSString *postalCode;
    
    // Required
    ENSURE_ARG_FOR_KEY(recipientName, args, @"recipientName", NSString);
    ENSURE_ARG_FOR_KEY(line1, args, @"line1", NSString);
    ENSURE_ARG_FOR_KEY(city, args, @"city", NSString);
    ENSURE_ARG_FOR_KEY(countryCode, args, @"countryCode", NSString);

    // Optional
    ENSURE_ARG_OR_NIL_FOR_KEY(line2, args, @"line2", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(state, args, @"state", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(postalCode, args, @"postalCode", NSString);

    PayPalShippingAddress *shippingAddress = [PayPalShippingAddress shippingAddressWithRecipientName:recipientName
                                                                                           withLine1:line1
                                                                                           withLine2:line2
                                                                                            withCity:city
                                                                                           withState:state
                                                                                      withPostalCode:postalCode
                                                                                     withCountryCode:countryCode];
    [[self payment] setShippingAddress:shippingAddress];
}

-(void)setPaymentDetails:(id)args
{
    ENSURE_TYPE(args, NSDictionary);
    
    NSNumber *subtotal;
    NSNumber *shipping;
    NSNumber *tax;
    
    ENSURE_ARG_OR_NIL_FOR_KEY(subtotal, args, @"subtotal", NSNumber);
    ENSURE_ARG_OR_NIL_FOR_KEY(shipping, args, @"shipping", NSNumber);
    ENSURE_ARG_OR_NIL_FOR_KEY(tax, args, @"tax", NSNumber);
    
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails
                                            paymentDetailsWithSubtotal:[NSDecimalNumber decimalNumberWithDecimal:[subtotal decimalValue]]
                                            withShipping:[NSDecimalNumber decimalNumberWithDecimal:[shipping decimalValue]]
                                            withTax:[NSDecimalNumber decimalNumberWithDecimal:[tax decimalValue]]];
    
    [[self payment] setPaymentDetails:paymentDetails];
}

#pragma mark - Delegates

#pragma mark Simple payments

-(void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    if ([self _hasListeners:@"paymentDidCancel"]) {
        [self fireEvent:@"paymentDidCancel" withObject:@{@"cancelled": NUMBOOL(YES)}];
    }
    
    TiThreadPerformOnMainThread(^{
        [[self paymentDialog] dismissViewControllerAnimated:YES completion:nil];
        RELEASE_TO_NIL(paymentDialog);
    }, YES);
}

-(void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController willCompletePayment:(PayPalPayment *)completedPayment completionBlock:(PayPalPaymentDelegateCompletionBlock)completionBlock
{
    if ([self _hasListeners:@"paymentWillComplete"]) {
        [self fireEvent:@"paymentWillComplete" withObject:[self confirmationFromPayment:completedPayment]];
    }
    completionBlock();
}

-(void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    if ([self _hasListeners:@"paymentDidComplete"]) {
        [self fireEvent:@"paymentDidComplete" withObject:[self confirmationFromPayment:completedPayment]];
    }

    TiThreadPerformOnMainThread(^{
        [[self paymentDialog] dismissViewControllerAnimated:YES completion:nil];
        RELEASE_TO_NIL(paymentDialog);
    }, YES);
}

#pragma mark Utilities

-(NSDictionary*)confirmationFromPayment:(PayPalPayment*)_payment
{
    NSDictionary *event = @{
        @"payment": [_payment confirmation]
    };
    
    return event;
}

@end
