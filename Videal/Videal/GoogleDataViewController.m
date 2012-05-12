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
    NSString * html = [notif object];
    [hiddenWeb loadHTMLString:html baseURL:nil];
    
    [hiddenWeb stringByEvaluatingJavaScriptFromString: @"<script type=\"text/javascript\">function auto_sign_in(){document.getElementById(\"Email\").setAttribute(\"value\", \"Videal.Test\"); document.getElementById(\"Passwd\").setAttribute(\"value\", \"eunmo123\");document.getElementById(\"signIn\").click();} window.onload = auto_sign_in;</script>"];
    [hiddenWeb reload];
    
    
    [hiddenWeb stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"  
     "script.type = 'text/javascript';"  
     "script.text = \"function myFunction() { "  
     "document.getElementById('submit_approve_access').click();"  
     "};"
     "window.onload = myFunction"
     ];
    
    //[hiddenWeb stringByEvaluatingJavaScriptFromString:@"document.getElementById('submit_approve_access').click()"]; 
    [hiddenWeb reload];
    //[hiddenWeb reloadInputViews];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(getAuthKey:) name:kNotificationGotLoginPage object: NULL];

    hiddenWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    YouTubeClient *client = [YouTubeClient new];
    hiddenWeb.delegate = self;
    [client sendQuery:@""];
    
    [self.view addSubview:hiddenWeb];
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
