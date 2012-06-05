//
//  EBayItemDetails.h
//  Videal
//
//  Created by Eunmo Yang on 5/28/d12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBayItemDetails : NSObject {
    @public
    NSString *title;
    NSString *desc;
    NSString *category;
    NSString *price;
    NSString *dispatch;
    NSString *duration;
    NSString *auction;
    NSString *paypal;
    NSString *zipcode;
    NSString *returnPolicy;
    NSString *shipping;
    NSString *shippingCost;
    NSString *authKey;
    NSString *video;
}

- (NSString *) getVerifyAddItemRequestBody;
- (NSString *) getAddItemRequestBody;

@end
