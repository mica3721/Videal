//
//  EBayAuthClient.m
//  Videal
//
//  Created by Eunmo Yang on 5/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "EBayAuthClient.h"

@implementation EBayAuthClient

- (void) sendQuery: (NSString *)sessID {
    NSString *urlString = @"https://signin.sandbox.ebay.com/ws/ebayISAPI.dll?"
    "SignIn&RuName=Videal-Videal79d-642a--tyyobjxod&SessID=";
    NSString *fullUrlString = [urlString stringByAppendingString:sessID];
    NSURL *url = [NSURL URLWithString:fullUrlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"Failed to connect to YouTube Client");
	
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSMutableData *)data {
	[responseData appendData:data];
}


/* When all the data is in place */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection cancel];
    NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
    
    NSNotification *notif = [NSNotification notificationWithName:keNotificationGotLoginPage object:jsonString];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
    
    
    // NSDictionary *results = [jsonString JSONValue];
    //NSLog(@"%@", jsonString);
}

@end
