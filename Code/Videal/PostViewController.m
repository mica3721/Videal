//
//  PostViewController.m
//  Videal
//
//  Created by Do Hyeong Kwon on 5/3/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "PostViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

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
    
    NSURL *videoLink = [info objectForKey:UIImagePickerControllerMediaURL];
    
    // We will do something with the video in a minute
    //NSLog(videoLink);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) CallVideoLibrary: (id) sender {
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


-(void) CallVideoCamera:(id) sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"The device does not have a camera.");
        return; // Change this with a warning message later
    }
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
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    picker = [[UIImagePickerController alloc] init];
    
    
    UIButton *pickBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pickBtn setFrame:CGRectMake(50, 30, 200, 60)];
    [pickBtn addTarget:self action:@selector(CallVideoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [pickBtn setTitle:@"Pick a Video" forState:UIControlStateNormal];
    [pickBtn setUserInteractionEnabled:YES];
    [self.view addSubview:pickBtn];
    
    UIButton *filmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [filmBtn setFrame:CGRectMake(50, 150, 200, 60)];
    [filmBtn addTarget:self action:@selector(CallVideoCamera:) forControlEvents:UIControlEventTouchUpInside];
    [filmBtn setTitle:@"Take a Video" forState:UIControlStateNormal];
    [filmBtn setUserInteractionEnabled:YES];
    [self.view addSubview:filmBtn];
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
