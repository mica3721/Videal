//
//  GoogleDataViewController.m
//  Videal
//
//  Created by Do Hyeong Kwon on 5/12/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "GoogleDataViewController.h"

@implementation GoogleDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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


-(void) getAuthKey: (NSNotification *) notif {
    NSString *ho = @"https://accounts.google.com/o/oauth2/auth?client_id=57312008374.apps.googleusercontent.com&redirect_uri=http://localhost&response_type=code&scope=https://gdata.youtube.com&access_type=offline";
    NSURL *haha = [NSURL URLWithString:ho];
    NSString * html = [notif object];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"()</body>"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:html
                                                    options:0
                                                      range:NSMakeRange(0, [html length])];
    
    if (match) {
        NSRange firstHalfRange = [match rangeAtIndex:1];
        firstHalfRange.location -= 9;
        NSString *substitute = @"<script type=\"text/javascript\">function auto_sign_in(){document.getElementById(\"Email\").setAttribute(\"value\", \"Videal.Test\"); document.getElementById(\"Passwd\").setAttribute(\"value\", \"eunmo123\");document.getElementById(\"signIn\").click();} window.onload = auto_sign_in;</script>";
        
        html = [html stringByReplacingCharactersInRange:firstHalfRange withString:substitute];
    }
    [hiddenWeb loadHTMLString:html baseURL:haha];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *h = [hiddenWeb stringByEvaluatingJavaScriptFromString:@"document.getElementById('submit_approve_access').click();"]; 
    NSLog(@"%@", h);
    /*if (!used) {
        
    
        [hiddenWeb reload];
        used = TRUE;
    }*/
    NSString *str = hiddenWeb.request.URL.absoluteString;
    NSLog(@" %@",str);
    
    /*UIWebView *second = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.view = second;
    NSString *auth = [NSString stringWithContentsOfFile:@"/Users/dokwon/Desktop/CS194/Videal/Videal/fff" encoding:NSUTF8StringEncoding error:nil];
    NSString *ho = @"https://accounts.google.com/o/oauth2/auth?client_id=57312008374.apps.googleusercontent.com&redirect_uri=http://localhost&response_type=code&scope=https://gdata.youtube.com&access_type=offline";
    NSURL *haha = [NSURL URLWithString:ho];
    [second loadHTMLString:auth baseURL:haha];*/
    /*while ([second isLoading]) {
        sleep(1);
    }
    NSString *str = second.request.URL.absoluteString;
    NSLog(@" %@",str);*/
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(getAuthKey:) name:kNotificationGotLoginPage object: NULL];

    hiddenWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.view = hiddenWeb;
    YouTubeClient *client = [YouTubeClient new];
    hiddenWeb.delegate = self;
    [client sendQuery:@""];
    
    
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
