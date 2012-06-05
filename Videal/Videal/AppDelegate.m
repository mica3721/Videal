//
//  AppDelegate.m
//  Videal
//
//  Created by Do Hyeong Kwon on 5/1/12.
//  Copyright (c) 2012 Stdanford University. All rights reserved.
//

#import "AppDelegate.h"

#import "SearchViewController.h"

#import "PostViewController.h"

#import "DealSaver.h"

#import "ImageResizer.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize authkey;

@synthesize deals;

@synthesize navController =_navigationController;

- (void) checkEBayAccountDetails
{
    authKeyExists = NO;
    hasCard = NO;
    if (deals.count >= 1)
    {
        authKeyExists = YES;

        /*
        if ([[deals objectAtIndex:DEALS_EBAY_HASCARD_INDEX] isEqualToString:@"hasCard"])
        {
            hasCard = YES;
        }
         */
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    DealSaver *saver= [DealSaver new];
    deals = [saver LoadDeals];
    authKey = [saver LoadAuthKey];
    NSLog(@"Authkey = %@", authKey);
    if (authKey != nil) {
        authKeyExists = true;
    }
    // Make an EBay api call to see if our auth token, if it exists, is valid
    [self checkEBayAccountDetails];
    
    UIViewController *viewController1 = [[PostViewController alloc] initWithNibName:nil bundle:nil];
    //UIViewController *viewController2 = [[HotViewController alloc] initWithNibName:nil bundle:nil];
    //self.tabBarController = [[UITabBarController alloc] init];
    //self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, nil];

    
    navController = [[UINavigationController alloc] initWithRootViewController: viewController1];
    //UIImage *image = [UIImage imageNamed:@"titanium.png"];
    //image = [image scaleImageToSize:CGSizeMake(320, 44)];
    
    
    //[navController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [navController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0/255.0 alpha:1]];
    //[navController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    navController.navigationBar.layer.masksToBounds = NO;
    navController.navigationBar.layer.shadowOffset = CGSizeMake(0, 3);
    navController.navigationBar.layer.shadowOpacity = 0.6;
    navController.navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:navController.navigationBar.bounds].CGPath;

    
    [self.window setRootViewController: navController];
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    NSLog(@"Entering Background");
    NSLog(@"%d", deals.count);
    NSLog(@"%@", authKey);
    DealSaver *saver = [DealSaver new];
    [saver SaveDeals:deals];
    [saver SaveAuthKey:authKey];
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    NSLog(@"Terminating");
    NSLog(@"%@", authKey);
    DealSaver *saver = [DealSaver new];
    if(self.authkey != nil) {
        [saver SaveAuthKey:authKey];
    }
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
