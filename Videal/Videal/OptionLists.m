//
//  OptionLists.m
//  Videal
//
//  Created by Eunmo Yang on 5/25/12.
//  Copyright (c) 2012 dStanford University. All rights reserved.
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
    [array addObject:[[NSArray alloc] initWithObjects:@"Fixed Price", @"FixedPriceItem", nil]];
    
    return array;
}

+ (NSMutableArray *) getDurationLists
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[NSArray alloc] initWithObjects:@"3 days", @"Days_3", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"5 days", @"Days_5", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"7 days", @"Days_7", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"10 days", @"Days_10", nil]];
    
    return array;
}

+ (NSMutableArray *) getShippingLists
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[NSArray alloc] initWithObjects:@"UPS Ground", @"UPSGround", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"UPS 3 Day Select", @"UPS3rdDay", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"UPS 2 Day Air", @"UPS2ndDay", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"UPS Next Day Air Saver", @"UPSNextDay", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"USPS Priority Mail", @"USPSPriority", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"USPS Parcel Post", @"USPSParcel", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"USPS Media Mail", @"USPSMedia", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"USPS First Class Letter", @"USPSFirstClassLetter", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"USPS Express Mail", @"USPS Express Mail", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"UPS Next Day Air", @"UPSNextDayAir", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"UPS Next Day Air AM", @"UPS2DayAirAM", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"USPS Global Express Mail", @"USPSGlobalExpress", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"USPS Global Priority Mail", @"USPSGlobalPriority", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"USPS Economy Parcel Post", @"USPSEconomyParcel", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"USPS Economy Letter Post", @"USPSEconomyLetter", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"USPS Airmail Letter Post", @"USPSAirmailLetter", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"USPS Airmail Parcel Post", @"USPSAirmailParcel", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"UPS Worldwide Express Plus", @"UPSWorldWideExpressPlus", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"UPS Worldwide Express", @"UPSWorldWideExpress", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"UPS Worldwide Expedited", @"UPSWorldWideExpedited", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"UPS Standard To Canada", @"UPSStandardToCanada", nil]];
    
    return array;
}

+ (NSMutableArray *) getReturnLists
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[NSArray alloc] initWithObjects:@"No Returns Accepted", @"ReturnsNotAccepted", @"", @"", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Moneyback, 14 Days", @"ReturnsAccepted", @"MoneyBack", @"Days_14", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Moneyback, 30 Days", @"ReturnsAccepted", @"MoneyBack", @"Days_30", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Moneyback, 60 Days", @"ReturnsAccepted", @"MoneyBack", @"Days_60", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Moneyback/Exchange, 14 Days", @"ReturnsAccepted", @"MoneyBackOrExchange", @"Days_14", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Moneyback/Exchange, 30 Days", @"ReturnsAccepted", @"MoneyBackOrExchange", @"Days_30", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"Moneyback/Exchange, 60 Days", @"ReturnsAccepted", @"MoneyBackOrExchange", @"Days_60", nil]];
    
    return array;
}

+ (NSMutableArray *) getReturnShippingLists
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[NSArray alloc] initWithObjects:@"paid by buyer", @"Buyer", nil]];
    [array addObject:[[NSArray alloc] initWithObjects:@"paid by seller", @"Seller", nil]];
    
    return array;
}

@end
