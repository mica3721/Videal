//
//  EBayAuthViewController.m
//  Videal
//
//  Created by Eunmo Yang on 5/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "EBayAuthViewController.h"
#import "AppDelegate.h"

@interface EBayAuthViewController ()

@property (nonatomic, strong) NSString *sessionID;
@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) NSString *eBayURL;
@property (nonatomic, strong) NSString *ruName;
@property (nonatomic, strong) NSString *fee;

@end

@implementation EBayAuthViewController

@synthesize sessionID = _sessionID;
@synthesize authToken = _authToken;
@synthesize eBayURL = _eBayURL;
@synthesize ruName = _ruName;
@synthesize fee = _fee;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.eBayURL = @"https://api.sandbox.ebay.com/ws/api.dll";
        self.ruName = @"Videal-Videal79d-642a--tyyobjxod";
        self.authToken = @"AgAAAA**AQAAAA**aAAAAA**AAK6Tw**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6wFk4GhCJiApQidj6x9nY+seQ**H88BAA**AAMAAA**tLYLmBUTikeNlwwPhFoN1AO8lUkIJVoUNDtX5STrMjsUNfjR7qAqJ9fD/N16ZMiC6xBI7MUFElt6Ci7DLCUIieRrniTHIj6XjM/6nvxUJ7fMdXRhXe1/5qhyvPaVkCa1umWYSn45JQ7oIdFoD5I7dSF9bDEkOzZFtmS5drDUEBVH5qZgYzbbjcdfdRF4XgvoXD1/dTor0FiuRojfCB2QD/2Mo9IUD1eS5dcGNiKhAZp/3Qq9o1xnaaXvkUDYEhMHQIpkJ0MAzZb+0NcZZkbf3C3muLiG8+lLMgYGDvFx4lvDh3xh17dUvBVgmNBJ/DwLgaBNgz1QpzWnmVcszZ/ha3nzHn5Lm9VM6CtOEFTOMUpGUEpawFlU8cLmZZHfIPEv+0KBhfbK9h38o9O3pgNDrZ4d5KMNSd+kX7dTkW3jqjmlIQzGug8gxvqpKImVUvR5kwHhDa5d9xR9gAvEBR6s/cXSsVC25/EUqxmlN/TWgYgudRbChLkVAvmoONVnMpHuW0Sc37lzWin/5SwLHkw4KA/zebADfNBDticXonq88XRr1C4CBkdlSQVWa4FAGCXLvIZMo5j8W5voxC5oLZKoMI6ac+xt/8EmE7EpBDpX72Zt3E/QiCb7VHJdgN8OV8FRIfdQG1yA/lzex9NZUQC2fXmdv/7GSPeoGiKpEWkBw6iEv4EfO0vHp0UI1Vlh5uHFcmiMlk4kak0eWsGLrByMxLGysHt5c6UMRhsyQQOoY8DLYXZP0/lKZU2so+ylzjh4";
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
 * Called after getting Authkey.
 * Retrieves return policy from the eBay website.
 */
- (void) getReturnPolicy: (NSMutableData *) data
{
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data];
    NSLog(@"%@", [dict description]);
}

- (void) getFees: (NSMutableData *) data
{
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data];
    NSLog(@"%@", [dict description]);
    NSMutableArray *arr = [[[dict objectForKey:@"VerifyAddItemResponse"] objectForKey:@"Fees"] objectForKey:@"Fee"];
}

/*
 * Validates test user
 */
- (void) ValidateTestUser
{
    NSLog(@"ValidateTestUserRegistrationRequest");
    NSString *body = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<ValidateTestUserRegistrationRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
                      "<FeedbackScore>500</FeedbackScore>"
                      "<RequesterCredentials>"
                      "<eBayAuthToken>%@</eBayAuthToken>"
                      "</RequesterCredentials>"
                      "<WarningLevel>High</WarningLevel>"
                      "</ValidateTestUserRegistrationRequest>", self.authToken];
    
    
    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:self.eBayURL andBody:body callName:@"ValidateTestUserRegistration"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
    
    [HttpPostHelper doPost:request from:self withSelector: @selector(getReturnPolicy:)];
}

- (void) VerifyAddItemResponse: (NSMutableData *) data
{
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data];
    NSLog(@"%@", [dict description]);
    
}

/*
 * Formulates a http POST request to ebay to see if our item will be valid for listing.
 */
- (void) VerifyAddItemRequest
{
    NSLog(@"GeteBayDetailsRequest");
    NSString *body = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<VerifyAddItemRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
                        "<ErrorLanguage>en_US</ErrorLanguage>"
                        "<WarningLevel>High</WarningLevel>"
                        "<Item>"
                            "<Title>Harry Potter and the Philosopher's Stone</Title>"
                            "<Description>This is the first book in the Harry Potter series. In excellent condition!</Description>"
                            "<PrimaryCategory>"
                                "<CategoryID>377</CategoryID>"
                            "</PrimaryCategory>"
                            "<StartPrice>1.00</StartPrice>"
                            "<CategoryMappingAllowed>true</CategoryMappingAllowed>"
                            "<ConditionID>1000</ConditionID>"
                            "<Country>US</Country>"
                            "<Currency>USD</Currency>"
                            "<DispatchTimeMax>3</DispatchTimeMax>"
                            "<ListingDuration>Days_7</ListingDuration>"
                            "<ListingType>Chinese</ListingType>"
                            "<PaymentMethods>PayPal</PaymentMethods>"
                            "<PayPalEmailAddress>magicalbookseller@yahoo.com</PayPalEmailAddress>"
                            "<PictureDetails>"
                                "<PictureURL>http://i.ebayimg.sandbox.ebay.com/00/s/MTAwMFg2NjA=/$(KGrHqZHJFEE-ko8eGBiBPs1CEKTZQ~~60_1.JPG?set_id=8800005007</PictureURL>"
                            "</PictureDetails>"
                            "<PostalCode>95125</PostalCode>"
                            "<Quantity>1</Quantity>"
                            "<ReturnPolicy>"
                                "<ReturnsAcceptedOption>ReturnsAccepted</ReturnsAcceptedOption>"
                                "<RefundOption>MoneyBack</RefundOption>"
                                "<ReturnsWithinOption>Days_30</ReturnsWithinOption>"
                                "<Description>If you are not satisfied, return the item for refund.</Description>"
                                "<ShippingCostPaidByOption>Buyer</ShippingCostPaidByOption>"
                            "</ReturnPolicy>"
                            "<ShippingDetails>"
                                "<ShippingType>Flat</ShippingType>"
                                "<ShippingServiceOptions>"
                                    "<ShippingServicePriority>1</ShippingServicePriority>"
                                    "<ShippingService>USPSMedia</ShippingService>"
                                    "<ShippingServiceCost>2.50</ShippingServiceCost>"
                                "</ShippingServiceOptions>"
                            "</ShippingDetails>"
                            "<Site>US</Site>"
                        "</Item>"
                        "<RequesterCredentials>"
                            "<eBayAuthToken>%@</eBayAuthToken>"
                        "</RequesterCredentials>"
                        "<WarningLevel>High</WarningLevel>"
                      "</VerifyAddItemRequest>", self.authToken];
                      
                      
    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:self.eBayURL andBody:body callName:@"VerifyAddItem"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
                      
    [HttpPostHelper doPost:request from:self withSelector: @selector(VerifyAddItemResponse:)];
}


/*
 * Formulates a http POST request to ebay to see if our item will be valid for listing.
 */
- (void) AddItemRequest
{
    NSLog(@"GeteBayDetailsRequest");
    NSString *body = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<AddItemRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
                      "<ErrorLanguage>en_US</ErrorLanguage>"
                      "<WarningLevel>High</WarningLevel>"
                      "<Item>"
                      "<Title>Harry Potter and the Philosopher's Stone</Title>"
                      "<Description>This is the first book in the Harry Potter series. In excellent condition!</Description>"
                      "<PrimaryCategory>"
                      "<CategoryID>377</CategoryID>"
                      "</PrimaryCategory>"
                      "<StartPrice>1.00</StartPrice>"
                      "<CategoryMappingAllowed>true</CategoryMappingAllowed>"
                      "<ConditionID>1000</ConditionID>"
                      "<Country>US</Country>"
                      "<Currency>USD</Currency>"
                      "<DispatchTimeMax>3</DispatchTimeMax>"
                      "<ListingDuration>Days_7</ListingDuration>"
                      "<ListingType>Chinese</ListingType>"
                      "<PaymentMethods>PayPal</PaymentMethods>"
                      "<PayPalEmailAddress>magicalbookseller@yahoo.com</PayPalEmailAddress>"
                      "<PictureDetails>"
                      "<PictureURL>http://i.ebayimg.sandbox.ebay.com/00/s/MTAwMFg2NjA=/$(KGrHqZHJFEE-ko8eGBiBPs1CEKTZQ~~60_1.JPG?set_id=8800005007</PictureURL>"
                      "</PictureDetails>"
                      "<PostalCode>95125</PostalCode>"
                      "<Quantity>1</Quantity>"
                      "<ReturnPolicy>"
                      "<ReturnsAcceptedOption>ReturnsAccepted</ReturnsAcceptedOption>"
                      "<RefundOption>MoneyBack</RefundOption>"
                      "<ReturnsWithinOption>Days_30</ReturnsWithinOption>"
                      "<Description>If you are not satisfied, return the item for refund.</Description>"
                      "<ShippingCostPaidByOption>Buyer</ShippingCostPaidByOption>"
                      "</ReturnPolicy>"
                      "<ShippingDetails>"
                      "<ShippingType>Flat</ShippingType>"
                      "<ShippingServiceOptions>"
                      "<ShippingServicePriority>1</ShippingServicePriority>"
                      "<ShippingService>USPSMedia</ShippingService>"
                      "<ShippingServiceCost>2.50</ShippingServiceCost>"
                      "</ShippingServiceOptions>"
                      "</ShippingDetails>"
                      "<Site>US</Site>"
                      "<UUID>8344f8f3207b4e21b387fb7d41ca45d1</UUID>"
                      "</Item>"
                      "<RequesterCredentials>"
                      "<eBayAuthToken>%@</eBayAuthToken>"
                      "</RequesterCredentials>"
                      "<WarningLevel>High</WarningLevel>"
                      "</AddItemRequest>", self.authToken];
    
    
    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:self.eBayURL andBody:body callName:@"AddItem"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
    
    [HttpPostHelper doPost:request from:self withSelector: @selector(getFees:)];
}

/*
 * Formulates a http POST request to ebay for return policy.
 */
- (void) returnPolicyRequest
{
    NSLog(@"GeteBayDetailsRequest");
    NSString *body = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<GeteBayDetailsRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
                        "<DetailName>ReturnPolicyDetails</DetailName>"
                        "<RequesterCredentials>"
                            "<eBayAuthToken>%@</eBayAuthToken>"
                        "</RequesterCredentials>"
                        "<WarningLevel>High</WarningLevel>"
                      "</GeteBayDetailsRequest>", self.authToken];
    
    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:self.eBayURL andBody:body callName:@"GeteBayDetails"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
    
    [HttpPostHelper doPost:request from:self withSelector: @selector(getReturnPolicy:)];
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

- (void) doneWithAuth
{
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
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
    
    //[self ValidateTestUser];
    //[self VerifyAddItemRequest];
    //[self AddItemRequest];
    
    [self sessionIDRequest];
    
    UIButton *bypassBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bypassBtn setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [bypassBtn addTarget:self action:@selector(doneWithAuth) forControlEvents:UIControlEventTouchUpInside];
    [bypassBtn setTitle:@"Bypass" forState:UIControlStateNormal];
    [bypassBtn setUserInteractionEnabled:YES];
    [self.view addSubview:bypassBtn];
    
    authWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40)];
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
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    del->authKey = self.authToken;
    del->authKeyExists = YES;
    [del->deals addObject:self.authToken]; 
    NSLog(@"%@", self.authToken);
    
    [self VerifyAddItemRequest];
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
