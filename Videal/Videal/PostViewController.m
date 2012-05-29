//
//  PostViewController.m
//  Videal
//
//  Created by Do Hyeong Kwon on 5/3/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "PostViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AppDelegate.h"
#import "ItemViewController.h"
#import "HttpPostHelper.h"
static NSString* const ebay_url = @"https://api.sandbox.ebay.com/ws/api.dll";

@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Post Offers";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        postedDeals = [[NSMutableArray alloc] init];
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

#pragma mark - Delegate methods for UIImagePickerControllerDelegate

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)_picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


// as a delegate we are being told a picture was taken
- (void)imagePickerController:(UIImagePickerController *)_picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    videoLink = [[info objectForKey:UIImagePickerControllerMediaURL] copy];
    NSLog(@"%@", videoLink);
    UISaveVideoAtPathToSavedPhotosAlbum((NSString *)videoLink, nil, nil, nil);
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName:@"show" object:nil]];
}

/*
- (void) captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CALayer *sth = keyWindow.layer;
    [sth renderInContext:context];   
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(img, self, nil, nil);
}*/

-(void) CallVideoLibrary {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"The device does not have a camera.");
        return; // Change this with a warning message later
    }
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeMovie]; 
    //picker.videoQuality = UIImagePickerControllerQualityTypeHigh; 
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
}

/*
-(void) capt {
    sleep(10);
    [self captureScreen];
    [captureThread cancel];
}*/

-(void) CallVideoCamera{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"The device does not have a camera.");
        return; // Change this with a warning message later
    }
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType]; 
    if(![sourceTypes containsObject:(NSString *)kUTTypeMovie]) {
        NSLog(@"The device does not support video.");
        return; 
    }
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeMovie]; 
    picker.videoQuality = UIImagePickerControllerQualityTypeHigh; 
    picker.delegate = self;
    
    [self presentModalViewController:picker animated:YES];	 
    /*captureThread = [[NSThread alloc] initWithTarget:self selector:@selector(capt) object:nil];
    [captureThread start];*/
    
}

-(void) eBay {
    
}

- (void) postDetailView {
    ItemViewController *detailCtrl = [[ItemViewController new] initWithStyle:UITableViewStyleGrouped];
    detailCtrl->videoLink = videoLink;
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

// Do all cleanup here.
- (void) logOut
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    del->authKeyExists = NO;
    del->hasCard = NO;
    [del->deals removeAllObjects]; 
    
    /*
     ********
     * TODO *
     ********
     * There should be code to get rid of already existing items in this view.
     */
}

-(void) dismissLoginPage:(NSNotification *) notif {
    
    UIViewController *prev = (UIViewController *) [notif object];
    [self dismissModalViewControllerAnimated:YES];
    NSLog(@"fsdadfsdfsadfsfdsadfsfsd");
}

- (NSString *) formatTimeLeft: (NSString *) timeLeft
{
    const char *cString = [timeLeft cStringUsingEncoding:NSASCIIStringEncoding];
    int days = 0, hours = 0, minutes = 0, seconds = 0;
    
    const char *ptr = cString;
    while(*ptr)
    {
        if(*ptr == 'P' || *ptr == 'T')
        {
            ptr++;
            continue;
        }
        
        int value, charsRead;
        char type;
        if(sscanf(ptr, "%d%c%n", &value, &type, &charsRead) != 2)
            ;  // handle parse error
        if(type == 'D')
            days = value;
        else if(type == 'H')
            hours = value;
        else if(type == 'M')
            minutes = value;
        else if(type == 'S')
            seconds = value;
        else
            ;  // handle invalid type
        
        ptr += charsRead;
    }
    
    NSString *formattedTimeLeft;

    if (days == 0) {
        if (hours == 1) {
            formattedTimeLeft = [NSString stringWithFormat:@"%d Hour left", hours];
        } else {
            formattedTimeLeft = [NSString stringWithFormat:@"%d Hours left", hours];
        }
    } else if (days == 1) {
        if (hours == 1) {
            formattedTimeLeft = [NSString stringWithFormat:@"%d Day %d Hour left", days, hours];
        } else {
            formattedTimeLeft = [NSString stringWithFormat:@"%d Day %d Hours left", days, hours];
        }
    } else {
        if (hours == 1) {
            formattedTimeLeft = [NSString stringWithFormat:@"%d Days %d Hour left", days, hours];
        } else {
            formattedTimeLeft = [NSString stringWithFormat:@"%d Days %d Hours left", days, hours];
        }
    }
    
    return formattedTimeLeft;
}

- (void) updateSellingItems: (NSMutableData *) data
{
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data];
    NSLog(@"%@", [dict description]);
    
    NSMutableArray *itemArray = [[[[dict objectForKey:@"GetMyeBaySellingResponse"] objectForKey:@"ActiveList"] objectForKey:@"ItemArray"] objectForKey:@"Item"];
    NSLog(@"%d", [itemArray count]);
    [postedDeals removeAllObjects];
    
    for (int i = 0; i < [itemArray count]; i++) {
        NSDictionary *item = [itemArray objectAtIndex:i];
        
        NSString *currentPrice = [[[item objectForKey:@"SellingStatus"] objectForKey:@"CurrentPrice"] objectForKey:@"text"];
        NSString *itemTitle = [item objectForKey:@"Title"];
        NSString *timeLeft = [self formatTimeLeft:[item objectForKey:@"TimeLeft"]];
        NSString *itemDetail = [NSString stringWithFormat:@"currently $%@  %@", currentPrice, timeLeft];
        NSString *itemUrl = [[item objectForKey:@"ListingDetails"] objectForKey:@"ViewItemURL"];
        
        [postedDeals addObject:[[NSArray alloc] initWithObjects:itemTitle, itemDetail, itemUrl, nil]];
        NSLog(@"%d\t%@\t%@\t%@", i, itemTitle, itemDetail, itemUrl);
    }
    
    [postedDealsView reloadData];
}

/*
 * Formulates a http POST request to ebay for authToken.
 */
- (void) GetMyeBaySellingRequest
{
    NSLog(@"GetMyeBaySellingRequest");
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *body = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<GetMyeBaySellingRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
                      "<ActiveList>"
                      "<Sort>TimeLeft</Sort>"
                      "<Pagination>"
                      "<EntriesPerPage>7</EntriesPerPage>"
                      "<PageNumber>1</PageNumber>"
                      "</Pagination>"
                      "</ActiveList>"
                      "<RequesterCredentials>"
                      "<eBayAuthToken>%@</eBayAuthToken>"
                      "</RequesterCredentials>"
                      "<WarningLevel>High</WarningLevel>"
                      "</GetMyeBaySellingRequest>", del->authKey];
    
    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:ebay_url andBody:body callName:@"GetMyeBaySelling"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
    
    [HttpPostHelper doPost:request from:self withSelector: @selector(updateSellingItems:)];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postDetailView) name:@"show" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissLoginPage:dismissLoginPage:) name:@"dismissLoginPage" object:nil];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    picker = [[UIImagePickerController alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											   initWithTitle:@"Logout"
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(logOut)]; 
    
    
    
    postedDealsView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height - 130) style:UITableViewStylePlain];
    postedDealsView.delegate = self;
    postedDealsView.dataSource = self; 
    [self.view addSubview:postedDealsView];
    
    UIButton * postButton = [UIButton buttonWithType:UIButtonTypeCustom]; 
    postButton.frame = CGRectMake(116, 330, 88, 70);
    [postButton addTarget:self action:@selector(showPostOptions) forControlEvents:UIControlEventTouchUpInside];
    [postButton setUserInteractionEnabled:YES];
    //[postButton setTitle:@"Post Video Deals" forState: UIControlStateNormal];
    [postButton setBackgroundColor:[UIColor darkGrayColor]];
    [postButton setBackgroundImage:[UIImage imageNamed:@"camera.jpg"] forState:UIControlStateNormal];
    [self.view addSubview:postButton];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!del->authKeyExists) {
        EBayAuthViewController *dataCtrl = [EBayAuthViewController new];
        [self.navigationController pushViewController: dataCtrl animated:YES];
    }
    
    [self GetMyeBaySellingRequest];
}
     
#pragma mark UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Actionsheet recieved %d as buttonIndex", buttonIndex);
    if (buttonIndex == 0) {
        [self CallVideoLibrary];
    } else if (buttonIndex == 1){
        [self CallVideoCamera];
    }
    
}


-(void) showPostOptions {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a Video Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Choose From Library", @"Take a Video", nil];
    
    [actionSheet showInView:self.view];
    
}


/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 120;
}
*/

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    // Do Something here
    /*
    if (indexPath.row < [postedDeals count]) {
        UIViewController *view = [[UIViewController alloc] init];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //NSString *itemUrl = [[postedDeals objectAtIndex:indexPath.row] objectAtIndex:2];
        NSString *itemUrl = @"http://cgi.sandbox.ebay.com/Sf-/110099282940#ht_500wt_951";
        NSLog(@"%@", itemUrl);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:itemUrl]];
        [webView loadRequest:request];
        [view.view addSubview:webView];
        [self.navigationController pushViewController:view animated:YES];
    }
     */
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //return [[appDel deals] count];
    return [postedDeals count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"Cell";
	AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [[postedDeals objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.detailTextLabel.text = [[postedDeals objectAtIndex:indexPath.row] objectAtIndex:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;

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
