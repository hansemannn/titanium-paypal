/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPaypalPaymentItem.h"
#import "TiUtils.h"

@implementation TiPaypalPaymentItem

-(PayPalItem *)item
{
    if (item == nil) {
        item = [PayPalItem new];
    }

    return item;
}

#pragma mark Public APIs

-(void)setName:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [[self item] setName:[TiUtils stringValue:value]];
}

-(void)setPrice:(id)value
{
    ENSURE_SINGLE_ARG(value, NSNumber);
    [[self item] setPrice:[NSDecimalNumber decimalNumberWithDecimal:[[TiUtils numberFromObject:value] decimalValue]]];
}

-(void)setQuantity:(id)value
{
    ENSURE_SINGLE_ARG(value, NSNumber);
    [[self item] setQuantity:[TiUtils intValue:value]];
}

-(void)setSku:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [[self item] setSku:[TiUtils stringValue:value]];
}

-(void)setCurrency:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [[self item] setCurrency:[TiUtils stringValue:value]];
}

@end
