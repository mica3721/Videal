//
//  EBayAuthViewController.m
//  Videal
//
//  Created by Eunmo Yang on 5/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "EBayAuthViewController.h"

@interface EBayAuthViewController ()

@property (nonatomic, strong) NSString *sessionID;

@end

@implementation EBayAuthViewController

@synthesize sessionID = _sessionID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) getAuthKey: (NSNotification *) notif {
    NSString * html = [notif object];
    [authWeb loadHTMLString:html baseURL:nil];
}

- (void) getSessionID: (NSMutableData *) data
{
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data];
    NSLog(@"%@", [dict description]);
    self.sessionID = [[dict objectForKey:@"GetSessionIDResponse"] objectForKey:@"SessionID"];
    NSLog(@"%@", self.sessionID);
    
    NSString *urlString = @"https://signin.sandbox.ebay.com/ws/ebayISAPI.dll?"
    "SignIn&RuName=Videal-Videal79d-642a--tyyobjxod&SessID=";
    NSString *fullUrlString = [urlString stringByAppendingString:self.sessionID];
    NSURL *url = [NSURL URLWithString:fullUrlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [authWeb loadRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(getAuthKey:) name:keNotificationGotLoginPage object: NULL];
    
    authWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    NSString *ebayURL = @"https://api.sandbox.ebay.com/ws/api.dll";
    NSString *body = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<GetSessionIDRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
    "<RuName>Videal-Videal79d-642a--tyyobjxod</RuName>"
    "</GetSessionIDRequest>";
    
    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:ebayURL andBody:body callName:@"GetSessionID"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
    
    [HttpPostHelper doPost:request from:self withSelector: @selector(getSessionID:)];
    authWeb.delegate = self;
    
    [self.view addSubview:authWeb];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)           webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Trying to redirect to: %@", [request.URL absoluteString]);
    if ([[request.URL absoluteString] hasPrefix:@"https://www.stanford.edu/~eyang89"])
    {
        NSLog(@"success!");
        return NO;
    }
    return YES;
}

@end
