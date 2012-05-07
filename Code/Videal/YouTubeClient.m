//
//  YouTubeClient.m
//  Videal
//
//  Created by Do Hyeong Kwon on 5/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "YouTubeClient.h"

@implementation YouTubeClient

-(id) init {
    self = [super init];
	if(self) {
        responseData = [[NSMutableData alloc] initWithCapacity:0];
	}
	return self;
}


- (void) sendQuery: (NSString *)query {
    NSString *base = @"http://accounts.google.com/o/oauth2/auth?";
    NSString *client_id = @"client_id=57312008374.apps.googleusercontent.com&";
    NSString *redirect_uri = @"redirect_uri=http://localhost/oauth2callback&";
    
    NSString *scope = @"scope=http://gdata.youtube.com&"; 
    NSString *response_type = @"response_type=json&";
    NSString *access_type = @"access_type=offline";
    NSString *solution = [[[[[base stringByAppendingString:client_id] stringByAppendingString:redirect_uri] stringByAppendingString:response_type] stringByAppendingString:scope] stringByAppendingString:access_type];
    
    
    
    NSURL *URL = [NSURL URLWithString:solution];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: URL];
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
	
    NSDictionary *results = [jsonString JSONValue];
    NSLog(@"%@", jsonString);
}


@end
