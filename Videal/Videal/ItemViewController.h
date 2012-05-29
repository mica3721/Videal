//
//  ItemViewController.h
//  Videal
//
//  Created by Eunmo Yang on 5/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NO_CATEGORY -1
#define DETAIL_CATEGORY 0
#define DETAIL_AUCTION 1
#define DETAIL_PRICE 2
#define DETAIL_PAYPAL 3
#define DETAIL_DURATION 4
#define DETAIL_SR_SHIPPING 0
#define DETAIL_SR_SHIPPING_COST 1
#define DETAIL_SR_DISPATCH 2
#define DETAIL_SR_ZIPCODE 3
#define DETAIL_SR_RETURN 4
#define DETAIL_SR_RETURN_SHIPPING 5

@interface ItemViewController : UITableViewController<UITextFieldDelegate, UITextViewDelegate> {
    
    @public
    NSArray *detailNameArray;
    NSMutableArray *detailStringArray;
    NSArray *detailSRNameArray;
    NSMutableArray *detailSRStringArray;
    
    UITextField *title;
    UITextView *desc;
    int categoryIndex;
    NSString *categoryCode;
    int auctionIndex;
    NSString *auctionCode;
    int durationIndex;
    NSString *durationCode;
    int shippingIndex;
    NSString *shippingCode;
    int dispatchIndex;
    NSString *dispatchTimeMax;
    int returnIndex;
    NSString *returnsAcceptedOption;
    NSString *refundOption;
    NSString *returnsWithinOption;
    int returnShippingIndex;
    NSString *returnShippingCode;
    UITextField *paypal;
    UITextField *price;
    UITextField *shippingCost;
    UITextField *zipcode;
    NSURL *videoLink; 
    NSString *authKey;
    @private
    NSThread *uploadThread;
    
}

- (void) setCategory: (NSDictionary *) dict;
- (void) setAuction: (NSNumber *) index;
- (void) setDuration: (NSNumber *) index;
- (void) setShipping: (NSNumber *) index;
- (void) setDispatch: (NSNumber *) index;
- (void) setReturn: (NSNumber *) index;
- (void) setReturnShipping: (NSNumber *) index;

@end
