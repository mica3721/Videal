//
//  PostViewController.h
//  Videal
//
//  Created by Do Hyeong Kwon on 5/3/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PostDetailViewController.h"
#import "YouTubeClient.h"

@interface PostViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImagePickerController *picker;
    NSThread *captureThread;     // Temporary get rid of later
}

@end
