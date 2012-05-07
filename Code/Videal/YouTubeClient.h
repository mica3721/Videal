//
//  YouTubeClient.h
//  Videal
//
//  Created by Do Hyeong Kwon on 5/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
@interface YouTubeClient : NSObject {
    NSMutableData *responseData;
}

-(void) sendQuery:(NSString*) query;

@end
