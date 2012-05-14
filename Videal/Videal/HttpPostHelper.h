//
//  HttpPostHelper.h
//  Videal
//
//  Created by Eunmo Yang on 5/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpPostHelper : NSObject

+ (void) doPost: (NSMutableURLRequest *) request
           from: (id) delegate
   withSelector: (SEL) selector;

+ (NSMutableURLRequest *) createeBayRequestWithURL: (NSString *) url
                                           andBody: (NSString *) body
                                          callName: (NSString *) callName;
+ (void) setCert: (NSMutableURLRequest *) request;

@end
