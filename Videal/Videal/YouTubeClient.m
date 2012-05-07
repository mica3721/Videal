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


- (void) uploadVideo {
    
    
    
}

- (void) sendQuery: (NSString *)query {
    
    //NSString *solution = @"https://accounts.google.com/o/oauth2/token&code=4/UMkd8g2LaQdgYl2Ab8npHZb-mTlH&client_id=57312008374.apps.googleusercontent.com&client_secret=5HDLSxm0ciiFZ14etx-2q1hs&redirect_uri=http://localhost/oauth2callback&grant_type=authorization_code";
    NSString *solution = @"https://accounts.google.com/o/oauth2/token";
    
    
    //https://accounts.google.com/o/oauth2/auth?client_id=57312008374.apps.googleusercontent.com&redirect_uri=http://localhost&response_type=code&scope=https://gdata.youtube.com&access_type=offline
    
    NSURL *URL = [NSURL URLWithString:solution];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"accounts.google.com" forHTTPHeaderField:@"Host"];
    
    
    NSString *sth = @"&code=4/aVJ5iOz2QHrODjNn_y1DJO9J2xET&client_id=57312008374.apps.googleusercontent.com&client_secret=5HDLSxm0ciiFZ14etx-2q1hs&redirect_uri=http://localhost&grant_type=authorization_code";
    [request setHTTPBody:[sth dataUsingEncoding:NSUTF8StringEncoding]];
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
