//
//  PostDetailViewController.h
//  Videal
//
//  Created by Do Hyeong Kwon on 5/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpPostHelper.h"
@interface PostDetailViewController : UIViewController{
    
    NSURL *videoLink; 
    NSString *authKey;
    NSThread *uploadThread;
}

-(id) initWithVideoLink: (NSURL*) link;

@end
