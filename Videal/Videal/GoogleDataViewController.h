//
//  GoogleDataViewController.h
//  Videal
//
//  Created by Do Hyeong Kwon on 5/12/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YouTubeClient.h"

@interface GoogleDataViewController : UIViewController <UIWebViewDelegate>{
    UIWebView *hiddenWeb;
    BOOL used;
}

@end
