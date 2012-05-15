//
//  PostDetailViewController.m
//  Videal
//
//  Created by Do Hyeong Kwon on 5/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "PostDetailViewController.h"

@implementation PostDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id) initWithVideoLink: (NSURL*) link{
    self = [super init];
    if(self) {
        
        videoLink = link;
       
        
    }
    return self;
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void) doneUploadingVideo:  (NSMutableData *) data {
    
    
    // Do something here
}

- (void) getAuthToken: (NSMutableData *) data
{
    NSString *authResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", authResponse);
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".*Auth=()"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:authResponse
                                                    options:0
                                                      range:NSMakeRange(0, [authResponse length])];
    
    if (match) {
        NSRange range = [match rangeAtIndex:1];
        
        authResponse = [authResponse substringFromIndex:range.location];
        NSLog(@"%@",authResponse);
        
        authKey = authResponse;
    }
    
    NSMutableURLRequest *request = [HttpPostHelper uploadVideoToYouTube:videoLink withAuthKey:authKey];
    [HttpPostHelper doPost:request from:self withSelector: @selector(doneUploadingVideo:)];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Google Client Login");
    NSString *googleURL = @"https://www.google.com/accounts/ClientLogin";
    NSString *googleID = @"Videal.Test";
    NSString *googlePW = @"eunmo123";
    NSString *googleSource = @"Videal_Test";
    NSString *body = [NSString stringWithFormat:@"Email=%@&Passwd=%@&service=youtube&source=%@", googleID, googlePW, googleSource];
    NSLog(@"%@", body);
    
    NSMutableURLRequest *request = [HttpPostHelper createGoogleAuthRequestWithURL:googleURL andBody:body];
    [HttpPostHelper doPost:request from:self withSelector: @selector(getAuthToken:)];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
