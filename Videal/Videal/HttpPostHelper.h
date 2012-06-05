//
//  HttpPostHelper.h
//  Videal
//
//  Created by Edunmo Yang on 5/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBayItemDetails.h"

@interface HttpPostHelper : NSObject

/*
 * Handles HTTP POST request.
 * The received data will be sent to selector of delegate
 */
+ (void) doPost: (NSMutableURLRequest *) request
           from: (id) delegate
   withSelector: (SEL) selector;

/*
 * Creates a HTTP POST request to eBay with appropriate headers.
 */
+ (NSMutableURLRequest *) createeBayRequestWithURL: (NSString *) url
                                           andBody: (NSString *) body
                                          callName: (NSString *) callName;

/*
 * Insert additional headers for certification on eBay.
 * Not needed after receiving authToken.
 */
+ (void) setCert: (NSMutableURLRequest *) request;

@end
