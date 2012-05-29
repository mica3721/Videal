//
//  UploadViewController.m
//  Videal
//
//  Created by Eunmo Yang on 5/28/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "UploadViewController.h"
#import "CategoryViewController.h"
#import "HttpPostHelper.h"
#import "XMLReader.h"

#import "GData/GData.h"
#import "GData/GDataServiceGoogleYouTube.h"
#import "GData/GDataEntryYouTubeUpload.h"

static NSString* const videal_client_id = @"57312008374.apps.googleusercontent.com";
static NSString* const videal_client_secret = @"5HDLSxm0ciiFZ14etx-2q1hs";
static NSString* const videal_user_id = @"videal.test";
static NSString* const videal_user_secret = @"eunmo123";
static NSString* const videal_dev_key = @"AI39si65Z4UhYeyjyzbxDQApWSQb-5QYGwBumbfHupMMxWmoUd8j3xBjRYqaqcAtNCCPkqC3BcTBEO518uvIImcpE4jo89lm6Q";
static NSString* const ebay_url = @"https://api.sandbox.ebay.com/ws/api.dll";

@interface UploadViewController ()

@end

@implementation UploadViewController

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
    double progress = ((double)numberOfBytesRead) / ((double)dataLength);
    [progressBar setProgress:progress animated:YES];
}

// upload callback
- (void)uploadTicket:(GDataServiceTicket *)ticket
   finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry
               error:(NSError *)error {
    if (error == nil) {
        // tell the user that the add worked
        NSString *videoUrl = [[[[videoEntry mediaGroup] mediaContents] objectAtIndex:0] URLString];
        NSLog(@"URL is :%@", videoUrl);
        ebayItemDetails->video = [videoUrl substringWithRange:NSMakeRange(26, 11)];
        NSLog(@"Video is:%@", ebayItemDetails->video);
        uploadComplete = YES;
    } else {
        NSLog(@"Upload failed: %@", error);
    }
}

- (void)uploadVideoFile
{
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

- (id)initWithStyle: (UITableViewStyle)style
           andArray: (NSMutableArray *)arr
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        fees = arr;
        feesWithFormat = [[NSMutableArray alloc] init];
        double sum = 0.0;
        for (int i = 0; i < [fees count]; i++) {
            NSDictionary *fee = [fees objectAtIndex:i];
            NSString *feeName = [fee objectForKey:@"Name"];
            if ([feeName isEqualToString:@"BasicUpgradePackBundleFee"]) {
                feeName = @"BasicUpgradePackBundle";
            }
            NSString *feeValue = [[fee objectForKey:@"Fee"] objectForKey:@"text"];
            NSStream *feeFormatted = [NSString stringWithFormat:@"$ %.2f", [feeValue doubleValue]];
            [feesWithFormat addObject:[[NSArray alloc] initWithObjects:feeName, feeFormatted, nil]];
            sum += [feeValue doubleValue];
        }
        totalFee = [NSString stringWithFormat:@"USD %.2f", sum];
        
        progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(27, 18, 268, 10)];
        [progressBar setProgressViewStyle:UIProgressViewStyleDefault];
        [progressBar setProgress:0.0];
        
        uploadComplete = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (ebayItemDetails->video != nil) {
        uploadComplete = YES;
        [progressBar setProgress:1.0];
    } else {
        [self uploadVideoFile];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell addSubview:progressBar];
        } else if (indexPath.section == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Total Fees";
            cell.detailTextLabel.text = totalFee;
        }  else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell setBackgroundColor:[UIColor redColor]];
            cell.textLabel.text = @"Submit";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Video upload status";
    } else if (section == 1) {
        return @"Fees for listing to eBay";
    } else return @"Submit";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void) feesCallbackFuntion: (NSInteger *) idx{}


- (void)        alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Done"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) AddItemResponse: (NSMutableData *) data
{
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data];
    NSLog(@"%@", [dict description]);
    NSDictionary *response = [dict objectForKey:@"AddItemResponse"];
    NSString *ack = [response objectForKey:@"Ack"];
    
    if ([ack isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if ([ack isEqualToString:@"Failure"]) {
        NSString *errorMessage;
        if ([[response objectForKey:@"Errors"] isKindOfClass:[NSMutableArray class]]) {
            NSLog(@"Multiple errors");
            errorMessage = [[[response objectForKey:@"Errors"] objectAtIndex:0] objectForKey:@"LongMessage"];
            NSLog(@"%@", errorMessage);
        } else {
            errorMessage = [[response objectForKey:@"Errors"] objectForKey:@"LongMessage"];
            NSLog(@"%@", errorMessage);
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void) submit
{
    NSLog(@"Submit BTN clicked");
    NSString *body = [ebayItemDetails getAddItemRequestBody];
    
    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:ebay_url andBody:body callName:@"AddItem"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
    
    [HttpPostHelper doPost:request from:self withSelector: @selector(AddItemResponse:)];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if (indexPath.section == 1) {
        NSLog(@"Clicked Fees");
        CategoryViewController *view = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                            andArray:feesWithFormat];
        [view registerParentViewController:self withSelector:@selector(feesCallbackFuntion:) andIndex:-1];
        [view setSectionTitle:@"This is a breakdown of your fees"];
        view->dontSelect = YES;
        view->cellStyle = UITableViewCellStyleValue1;
        [self.navigationController pushViewController:view animated:YES];
    } else if (indexPath.section == 2) {
        if (uploadComplete) {
            [self submit];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please wait until video upload is complete" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

@end
