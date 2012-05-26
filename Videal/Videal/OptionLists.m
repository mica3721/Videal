//
//  OptionLists.m
//  Videal
//
//  Created by Eunmo Yang on 5/25/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "OptionLists.h"

@implementation OptionLists

+ (NSMutableArray *) getCategoryLists
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[NSArray alloc] initWithObjects:@"Antiques", @"20081", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Art", @"550", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Baby", @"2984", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Books", @"267", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Business & Industrial", @"12576", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Cameras & Photo", @"625", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Cell Phones & Accessories", @"15032", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Clothing, Shoes & Accessories", @"11450", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Coins & Paper Money", @"11116", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Collectibles", @"1", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Computers/Tablets & Networking", @"58058", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Consumer Electonics", @"293", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Crafts", @"14339", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Dolls & Bears", @"237", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"DVDs & Movies", @"11232", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Entertainment Memorabilia", @"45100", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Gift Cards & Coupons", @"172008", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Health & Beauty", @"26395", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Home & Garden", @"11700", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Jewelry & Watches", @"281", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Music", @"11233", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Musical Instruments & Gear", @"619", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Pet Supplies", @"1281", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Pottery & Glass", @"870", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Real Estate", @"10542", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Specialty Services", @"316", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Sporting Goods", @"382", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Sports Mem, Cards & Fan Shop", @"64482", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Stamps", @"260", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Tickets", @"1305", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Toys & Hobbies", @"220", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Travel", @"3252", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Video Games", @"1249", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Everything Else", @"99", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Partner", @"10159", nil]];
    
    return array;
}

+ (NSMutableArray *) getDispatchLists
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[NSArray alloc] initWithObjects:@"0 days", @"0", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"1 days", @"1", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"2 days", @"2", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"3 days", @"3", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"4 days", @"4", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"5 days", @"5", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"10 days", @"10", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"15 days", @"15", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"20 days", @"20", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"30 days", @"30", nil]];
    
    return array;
}

+ (NSMutableArray *) getAuctionLists
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[NSArray alloc] initWithObjects:@"Auction-like", @"Chinese", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Mutliple Item", @"Dutch", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Fixed Price", @"FixedPriceItem", nil]];
    
    return array;
}

@end
