//
//  PostDetailViewController.m
//  Videal
//
//  Created by Do Hyeong Kwon on 5/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "PostDetailViewController.h"
#import "GData/GData.h"
#import "GData/GDataServiceGoogleYouTube.h"
#import "GData/GDataEntryYouTubeUpload.h"

static NSString* const videal_client_id = @"57312008374.apps.googleusercontent.com";
static NSString* const videal_client_secret = @"5HDLSxm0ciiFZ14etx-2q1hs";
static NSString* const videal_user_id = @"videal.test";
static NSString* const videal_user_secret = @"eunmo123";
static NSString* const videal_dev_key = @"AI39si65Z4UhYeyjyzbxDQApWSQb-5QYGwBumbfHupMMxWmoUd8j3xBjRYqaqcAtNCCPkqC3BcTBEO518uvIImcpE4jo89lm6Q";

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
    [uploadThread cancel];
    NSLog(@"%@", data);
    EBayAuthViewController *dataCtrl = [EBayAuthViewController new];
    [self presentModalViewController:dataCtrl animated:YES];
}


-(void) upload {
   
    
    NSMutableURLRequest *req = [HttpPostHelper uploadVideoToYouTube:videoLink withAuthKey:authKey];
    [HttpPostHelper doPost:req from:self withSelector: @selector(doneUploadingVideo:)];
    
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
        uploadThread = [[NSThread alloc] initWithTarget:self selector:@selector(upload) object:nil];
        [uploadThread start];
    } else{
        NSLog(@"Authkey retrieval failed.");
    }
    
}

- (GDataServiceGoogleYouTube *)youTubeService
{
    
    GDataServiceGoogleYouTube* service = [[GDataServiceGoogleYouTube alloc] init];
    [service setShouldCacheResponseData:YES];
    [service setServiceShouldFollowNextLinks:YES];
    [service setIsServiceRetryEnabled:YES];
    
    [service setUserCredentialsWithUsername:videal_user_id password:videal_user_secret];
    [service setYouTubeDeveloperKey:videal_dev_key];
    
    return service;
}

// progress callback
- (void)       ticket:(GDataServiceTicket *)ticket
hasDeliveredByteCount:(unsigned long long)numberOfBytesRead
     ofTotalByteCount:(unsigned long long)dataLength
{
    /*
    [mUploadProgressIndicator setMinValue:0.0];
    [mUploadProgressIndicator setMaxValue:(double)dataLength];
    [mUploadProgressIndicator setDoubleValue:(double)numberOfBytesRead];
     */
}

// upload callback
- (void)uploadTicket:(GDataServiceTicket *)ticket
   finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry
               error:(NSError *)error {
    if (error == nil) {
        // tell the user that the add worked
        NSLog(@"URL is :%@", [[[[videoEntry mediaGroup] mediaContents] objectAtIndex:0] URLString]);
         
        // refetch the current entries, in case the list of uploads
        // has changed
        //[self fetchAllEntries];
    } else {
        NSLog(@"Upload failed: %@", error);
    }
    //[mUploadProgressIndicator setDoubleValue:0.0];
    
    //[self setUploadTicket:nil];
}

- (void)uploadVideoFile
{
    
    //NSString *devKey = videal_dev_key;
    
    GDataServiceGoogleYouTube *service = [self youTubeService];
    
    NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:kGDataServiceDefaultUser];
    
    // load the file data
    NSString *path = [videoLink path];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSString *filename = [path lastPathComponent];
    
    // gather all the metadata needed for the mediaGroup
    NSString *titleStr = @"TEST_TITLE_EUNMO";
    GDataMediaTitle *title = [GDataMediaTitle textConstructWithString:titleStr];
    
    NSString *categoryStr = @"People";
    GDataMediaCategory *category = [GDataMediaCategory mediaCategoryWithString:categoryStr];
    [category setScheme:kGDataSchemeYouTubeCategory];
    
    NSString *descStr = @"TEST_DESC";
    GDataMediaDescription *desc = [GDataMediaDescription textConstructWithString:descStr];
    
    NSString *keywordsStr = @"";
    GDataMediaKeywords *keywords = [GDataMediaKeywords keywordsWithString:keywordsStr];
    
    BOOL isPrivate = NO;
    
    GDataYouTubeMediaGroup *mediaGroup = [GDataYouTubeMediaGroup mediaGroup];
    [mediaGroup setMediaTitle:title];
    [mediaGroup setMediaDescription:desc];
    [mediaGroup addMediaCategory:category];
    [mediaGroup setMediaKeywords:keywords];
    [mediaGroup setIsPrivate:isPrivate];
    
    NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:path
                                               defaultMIMEType:@"video/mp4"];
    
    // create the upload entry with the mediaGroup and the file
    GDataEntryYouTubeUpload *entry;
    entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup
                                                    fileHandle:fileHandle
                                                      MIMEType:mimeType
                                                          slug:filename];
    [entry addAccessControl:[GDataYouTubeAccessControl accessControlWithAction:@"list" permission:@"denied"]];
    
    SEL progressSel = @selector(ticket:hasDeliveredByteCount:ofTotalByteCount:);
    [service setServiceUploadProgressSelector:progressSel];
    
    GDataServiceTicket *ticket;
    ticket = [service fetchEntryByInsertingEntry:entry
                                      forFeedURL:url
                                        delegate:self
                               didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)];
    //[self setUploadTicket:ticket];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    /* More comments or some shit */
    [super viewDidLoad];
    [self uploadVideoFile];
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
