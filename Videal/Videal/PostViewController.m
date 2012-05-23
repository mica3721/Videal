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
@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Post Offers";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
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
    UISaveVideoAtPathToSavedPhotosAlbum((NSString *)videoLink, nil, nil, nil);
    [self dismissModalViewControllerAnimated:YES];
    
    PostDetailViewController *details = [[PostDetailViewController alloc] initWithVideoLink:videoLink];
    [self presentModalViewController:details animated:YES];
    
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

/*- (void) getAuthToken: (NSMutableData *) data
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
        
        PostDetailViewController *details = [[PostDetailViewController alloc] initWithVideoLink:videoLink];
        [self presentModalViewController:details animated:YES];
    }
}

-(void) Youtube {
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
 */

-(void) EBay {
    EBayAuthViewController *dataCtrl = [EBayAuthViewController new];
    [self presentModalViewController:dataCtrl animated:YES];
}

// Do all cleanup here.
- (void) logOut
{
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [label setBackgroundColor:[UIColor darkGrayColor]];
    [label setText:@"Your Deals"];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    [self.view addSubview:label];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    */
    
    picker = [[UIImagePickerController alloc] init];
    /*UIButton *pickBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pickBtn setFrame:CGRectMake(50, 30, 200, 60)];
    [pickBtn addTarget:self action:@selector(CallVideoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [pickBtn setTitle:@"Pick a Video" forState:UIControlStateNormal];
    [pickBtn setUserInteractionEnabled:YES];
    [self.view addSubview:pickBtn];
    
    UIButton *filmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [filmBtn setFrame:CGRectMake(50, 130, 200, 60)];
    [filmBtn addTarget:self action:@selector(CallVideoCamera:) forControlEvents:UIControlEventTouchUpInside];
    [filmBtn setTitle:@"Take a Video" forState:UIControlStateNormal];
    [filmBtn setUserInteractionEnabled:YES];
    [self.view addSubview:filmBtn];
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testBtn setFrame:CGRectMake(50, 230, 200, 60)];
    [testBtn addTarget:self action:@selector(Youtube) forControlEvents:UIControlEventTouchUpInside];
    [testBtn setTitle:@"Youtube" forState:UIControlStateNormal];
    [testBtn setUserInteractionEnabled:YES];
    [self.view addSubview:testBtn];*/
    
    UIButton *eBayBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [eBayBtn setFrame:CGRectMake(0, 0, 160, 40)];
    [eBayBtn addTarget:self action:@selector(EBay) forControlEvents:UIControlEventTouchUpInside];
    [eBayBtn setTitle:@"Sign in to eBay" forState:UIControlStateNormal];
    [eBayBtn setUserInteractionEnabled:YES];
    [self.view addSubview:eBayBtn];
    
    UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logOutBtn setFrame:CGRectMake(160, 0, 160, 40)];
    [logOutBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [logOutBtn setTitle:@"Log out" forState:UIControlStateNormal];
    //AppDelegate *del = [[UIApplication sharedApplication] delegate];
    //[logOutBtn setTitle:[del->deals objectAtIndex:DEALS_EBAY_AUTHKEY_INDEX] forState:UIControlStateNormal];
    [logOutBtn setUserInteractionEnabled:YES];
    [self.view addSubview:logOutBtn];
    
    postedDeals = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width , self.view.frame.size.height - 130) style:UITableViewStylePlain];
    postedDeals.delegate = self;
    postedDeals.dataSource = self; 
    [self.view addSubview:postedDeals];
    
    UIButton * postButton = [UIButton buttonWithType:UIButtonTypeCustom]; 
    postButton.frame = CGRectMake(116, 380, 88, 70);
    [postButton addTarget:self action:@selector(showPostOptions) forControlEvents:UIControlEventTouchUpInside];
    [postButton setUserInteractionEnabled:YES];
    //[postButton setTitle:@"Post Video Deals" forState: UIControlStateNormal];
    [postButton setBackgroundColor:[UIColor darkGrayColor]];
    [postButton setBackgroundImage:[UIImage imageNamed:@"camera.jpg"] forState:UIControlStateNormal];
    [self.view addSubview:postButton];
    
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 120;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	// Do Something here
    return;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [[appDel deals] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"Cell";
	AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [[appDel deals] objectAtIndex:indexPath.row];
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
