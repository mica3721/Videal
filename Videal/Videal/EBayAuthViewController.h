//
//  EBayAuthViewController.h
//  Videal
//
//  Created by Eunmo Yang on 5/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpPostHelper.h"
#import "EBayAuthClient.h"
#import "XMLReader.h"

#define kNotificationGotAuthKey @"got_auth_key"

@interface EBayAuthViewController : UIViewController <UIWebViewDelegate>{
    UIWebView *authWeb;
}

@end
