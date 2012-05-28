//
//  AppDelegate.h
//  Videal
//
//  Created by Do Hyeong Kwon on 5/1/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEALS_EBAY_AUTHKEY_INDEX 0
#define DEALS_EBAY_HASCARD_INDEX 1
#define DEALS_EBAY_ITEMS_INDEX 2

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {
    
    UINavigationController *navController;
    
    @public
    NSString *authKey;
    NSMutableArray *deals;
    BOOL authKeyExists;
    BOOL hasCard;
}

@property (nonatomic, copy) NSString *authkey;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *deals; 

@property (nonatomic, strong) UINavigationController *navController;

@end
