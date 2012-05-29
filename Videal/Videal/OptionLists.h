//
//  OptionLists.h
//  Videal
//
//  Created by Eunmo Yang on 5/25/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionLists : NSObject

+ (NSMutableArray *) getCategoryLists;
+ (NSMutableArray *) getDispatchLists;
+ (NSMutableArray *) getAuctionLists;
+ (NSMutableArray *) getDurationLists;
+ (NSMutableArray *) getShippingLists;
+ (NSMutableArray *) getReturnLists;
+ (NSMutableArray *) getReturnShippingLists;

@end
