//
//  EBayAuthClient.h
//  Videal
//
//  Created by Eunmo Yang on 5/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

#define keNotificationGotLoginPage @"2130jhfdjhdsljhle"

@interface EBayAuthClient : NSObject

-(void) sendQuery:(NSString*) query;

@end
