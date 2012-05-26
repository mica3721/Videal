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
#define DETAIL_DURATION 3
#define DETAIL_PAYPAL 4
#define DETAIL_SHIPPING 5
#define DETAIL_DISPATCH 6
#define DETAIL_RETURN 7

@interface ItemViewController : UITableViewController<UITextFieldDelegate, UITextViewDelegate> {
    
    @public
    NSArray *detailNameArray;
    NSMutableArray *detailStringArray;
    UITextField *title;
    UITextView *desc;
    int categoryIndex;
    NSString *categoryCode;
    int dispatchIndex;
    NSString *dispatchTimeMax;
    int auctionIndex;
    NSString *auctionCode;
    UITextField *paypal;
    UITextField *price;
}

- (void) setCategory: (NSNumber *) index;
- (void) setDispatch: (NSNumber *) index;
- (void) setAuction: (NSNumber *) index;

@end