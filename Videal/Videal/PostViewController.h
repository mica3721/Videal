//
//  PostViewController.h
//  Videal
//
//  Created by Do Hyeong Kwon on 5/3/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EBayAuthViewController.h"
#import <iAd/iAd.h>


@interface PostViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, ADBannerViewDelegate> {
    UIImagePickerController *picker;
    //NSThread *captureThread;     // Temporary get rid of later
    NSURL *videoLink;
    UITableView *postedDealsView;
    NSMutableArray *postedDeals;
    ADBannerView * adView;
    BOOL bannerVisible;
}


- (void) GetMyeBaySellingRequest;

@end
