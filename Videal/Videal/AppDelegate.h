//
//  AppDelegate.h
//  Videal
//
//  Created by Do Hyeong Kwon on 5/1/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {
    
    UINavigationController *navController;
    NSMutableArray *deals;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray * deals; 

@end
