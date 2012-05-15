//
//  HttpPostHelper.m
//  Videal
//
//  Created by Eunmo Yang on 5/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "HttpPostHelper.h"

@interface HttpPostHelper()
{
    NSMutableData *data;
    id delegate;
    SEL selector;
}
@end

@implementation HttpPostHelper
- (id) initFrom: (id) _delegate
       selector: (SEL) _selector
{
    data = [NSMutableData alloc];
    delegate = _delegate;
    selector = _selector;
    return self;
}

+ (void) setCert: (NSMutableURLRequest *) request
{
    [request setValue:@"db25aef5-be73-4631-bbc9-78deeef3b2f2" forHTTPHeaderField:@"X-EBAY-API-DEV-NAME"];
    [request setValue:@"Videal79d-642a-442d-8c73-3607978d1f8" forHTTPHeaderField:@"X-EBAY-API-APP-NAME"];
    [request setValue:@"474662bd-0f40-40cc-8c82-a10095702c52" forHTTPHeaderField:@"X-EBAY-API-CERT-NAME"];
}

+ (NSMutableURLRequest *) createGoogleAuthRequestWithURL: (NSString *) url
                                                 andBody: (NSString *) body
{
    NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    return request;
}

+ (NSMutableURLRequest*) uploadVideoToYouTube: (NSURL *) videoLink
                                  withAuthKey: (NSString *) authKey
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"/feeds/api/users/default/uploads HTTP/1.1"]];
     NSError *error = NULL;
    
    NSString *temp = [NSString stringWithFormat:@"%@~", videoLink];
    [NSString stringWithFormat:@""];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".*/()~"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:temp
                                                    options:0
                                                      range:NSMakeRange(0, [temp length])];
    NSString *filename =@"";
    if (match) {
        NSRange range = [match rangeAtIndex:1];
        
        filename = [temp substringWithRange:range];
    }

    
    
    //NSData *video = [NSData dataWithContentsOfURL:videoLink];
    
    NSString *body = @"--f93dcbA3"
    "Content-Type: application/atom+xml; charset=UTF-8"
    "<?xml version=\"1.0\"?>"
    "<entry xmlns=\"http://www.w3.org/2005/Atom\""
        "xmlns:media=\"http://search.yahoo.com/mrss/\""
        "xmlns:yt=\"http://gdata.youtube.com/schemas/2007\">"
    "<media:group>"
    "<media:title type=\"plain\">Videal Video for: </media:title>"
    "<media:description type=\"plain\">"
    "</media:group>"
    "</entry>"
    "--f93dcbA3"
    "Content-Type: video/mp4"
    "Content-Transfer-Encoding: binary";
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfURL:videoLink];
    body = [body stringByAppendingFormat:[NSString stringWithContentsOfURL:videoLink encoding:NSUTF8StringEncoding error:nil]];
    NSString *footer = @"--f93dcbA3--";
    body = [body stringByAppendingFormat:[NSString stringWithFormat:@"%@", footer]];
    
    
    
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", authKey] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"2" forHTTPHeaderField:@"GData-Version"];
    [request setValue:@"key=AI39si65Z4UhYeyjyzbxDQApWSQb-5QYGwBumbfHupMMxWmoUd8j3xBjRYqaqcAtNCCPkqC3BcTBEO518uvIImcpE4jo89lm6Q" forHTTPHeaderField:@"X-GData-Key"];
    [request setValue:filename forHTTPHeaderField:@"Slug"];
    [request setValue:@"multipart/related; boundary=\"f93dcbA3\"" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-length"];
    [request setValue:@"close" forHTTPHeaderField:@"Connection"];
    
    [request setValue:@"uploads.gdata.youtube.com" forHTTPHeaderField:@"Host"];
    return request;
}

+ (NSMutableURLRequest *) createeBayRequestWithURL: (NSString *) url
                                           andBody: (NSString *) body
                                          callName: (NSString *) callName
{
    NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-length"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"0" forHTTPHeaderField:@"X-EBAY-API-SITEID"];
    [request setValue:@"681" forHTTPHeaderField:@"X-EBAY-API-COMPATIBILITY-LEVEL"];
    [request setValue:callName forHTTPHeaderField:@"X-EBAY-API-CALL-NAME"];
    
    return request;
}

+ (void) doPost: (NSMutableURLRequest *) request
           from: (id) delegate
   withSelector: (SEL) selector
{
    HttpPostHelper *http = [[HttpPostHelper alloc] initFrom: delegate selector: selector];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:http startImmediately:YES];
    
    // log
    if (!connection)
    {
        NSLog(@"Connection Failed");
    }
    else
    {
        NSLog(@"Connection Successful to %@", request.URL);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSMutableData *)receivedData {
	[data appendData:receivedData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error receiving response: %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // log
    NSLog(@"Success! Received %d bytes of data", [data length]);
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    [delegate performSelector:selector withObject:data];
}

@end
