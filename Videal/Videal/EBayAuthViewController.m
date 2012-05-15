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
@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) NSString *eBayURL;
@property (nonatomic, strong) NSString *ruName;

@end

@implementation EBayAuthViewController

@synthesize sessionID = _sessionID;
@synthesize authToken = _authToken;
@synthesize eBayURL = _eBayURL;
@synthesize ruName = _ruName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.eBayURL = @"https://api.sandbox.ebay.com/ws/api.dll";
        self.ruName = @"Videal-Videal79d-642a--tyyobjxod";
    }
    return self;
}

- (void) getAuthKey: (NSNotification *) notif {
    NSString * html = [notif object];
    [authWeb loadHTMLString:html baseURL:nil];
}

/*
 * Called when http POST request to ebay for sessionID returns.
 * Extracts xml data to get the sessionID
 * And opens up a login window to get user's authentification.
 */
- (void) getSessionID: (NSMutableData *) data
{
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data];
    NSLog(@"%@", [dict description]);
    self.sessionID = [[dict objectForKey:@"GetSessionIDResponse"] objectForKey:@"SessionID"];
    NSLog(@"%@", self.sessionID);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://signin.sandbox.ebay.com/ws/ebayISAPI.dll?"
                                       "SignIn&RuName=%@&SessID=%@", self.ruName, self.sessionID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [authWeb loadRequest:request];
}

/*
 * Formulates a http POST request to ebay for sessionID.
 */
- (void) sessionIDRequest
{
    NSLog(@"sessionIDRequest");
    NSString *body = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<GetSessionIDRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
                      "<RuName>%@</RuName>"
                      "</GetSessionIDRequest>", self.ruName];
    
    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:self.eBayURL andBody:body callName:@"GetSessionID"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
    
    [HttpPostHelper doPost:request from:self withSelector: @selector(getSessionID:)];
}

/*
 * Requests for sessionID
 * And creates a UIWebView to display the login page for user authroization.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(getAuthKey:) name:keNotificationGotLoginPage object: NULL];
    
    [self sessionIDRequest];
    
    authWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    authWeb.delegate = self;
    authWeb.scalesPageToFit = YES;
    [self.view addSubview:authWeb];
}

/*
 * Called when http POST request to ebay for authToken returns.
 * Extracts xml data to get the authToken.
 *
 * TODO: And opens up a category selector.
 */
- (void) getAuthToken: (NSMutableData *) data
{
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data];
    NSLog(@"%@", [dict description]);
    self.authToken = [[dict objectForKey:@"FetchTokenResponse"] objectForKey:@"eBayAuthToken"];
    NSLog(@"%@", self.authToken);
}

/*
 * Formulates a http POST request to ebay for authToken.
 */
- (void) fetchTokenRequest
{
    NSLog(@"fetchTokenRequest");
    NSString *body = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<FetchTokenRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
    "<SessionID>%@</SessionID>"
    "</FetchTokenRequest>", self.sessionID];
    
    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:self.eBayURL andBody:body callName:@"FetchToken"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
    
    [HttpPostHelper doPost:request from:self withSelector: @selector(getAuthToken:)];
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

/*
 * Detects redirections in order to see if the user granted access.
 * The access grant page is currently set to https://www.stanford.edu/~eyang89
 * but this page is never shown to the user.
 */
- (BOOL)           webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Trying to redirect to: %@", [request.URL absoluteString]);
    if ([[request.URL absoluteString] hasPrefix:@"https://www.stanford.edu/~eyang89"])
    {
        NSLog(@"success!");
        [self fetchTokenRequest];
        return NO;
    }
    return YES;
}

@end
