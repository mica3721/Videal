//
//  ItemViewController.m
//  Videal
//
//  Created by Eunmo Yang on 5/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ItemViewController.h"
#import "OptionLists.h"
#import "CategoryViewController.h"
#import "XMLReader.h"
#import "HttpPostHelper.h"
#import "AppDelegate.h"
#import "SubCategoryViewController.h"

#import "GData/GData.h"
#import "GData/GDataServiceGoogleYouTube.h"
#import "GData/GDataEntryYouTubeUpload.h"

static NSString* const videal_client_id = @"57312008374.apps.googleusercontent.com";
static NSString* const videal_client_secret = @"5HDLSxm0ciiFZ14etx-2q1hs";
static NSString* const videal_user_id = @"videal.test";
static NSString* const videal_user_secret = @"eunmo123";
static NSString* const videal_dev_key = @"AI39si65Z4UhYeyjyzbxDQApWSQb-5QYGwBumbfHupMMxWmoUd8j3xBjRYqaqcAtNCCPkqC3BcTBEO518uvIImcpE4jo89lm6Q";
static NSString* const ebay_url = @"https://api.sandbox.ebay.com/ws/api.dll";


@interface ItemViewController ()

@end

@implementation ItemViewController

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



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        detailNameArray = [[NSArray alloc] initWithObjects:@"Category",@"Pricing",@"Start price",@"Paypal",@"Duration",nil];
        detailStringArray = [[NSMutableArray alloc] initWithObjects:@"", @"Auction-like", @"", @"",  @"7 days",nil];
        detailSRNameArray = [[NSArray alloc] initWithObjects:@"Shipping",@"Ship cost",@"Dispatch",@"Zipcode",@"Return",@"Return cost", nil];
        detailSRStringArray = [[NSMutableArray alloc] initWithObjects:@"", @"", @"3 days", @"", @"Moneyback, 14 Days", @"paid by buyer", nil];
        
        title = [[UITextField alloc] initWithFrame:CGRectMake(20, 12, 280, 30)];
        title.placeholder = @"Title";
        [title setReturnKeyType:UIReturnKeyDone];
        [title addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        desc = [[UITextView alloc] initWithFrame:CGRectMake(15, 12, 290, 123)];
        desc.backgroundColor = [UIColor clearColor];
        [desc setReturnKeyType:UIReturnKeyDone];
        [desc setDelegate:self];
        
        // define defaults
        categoryIndex = NO_CATEGORY;
        auctionIndex = 0;
        auctionCode = [[[OptionLists getAuctionLists] objectAtIndex:auctionIndex] objectAtIndex:1];
        durationIndex = 2;
        durationCode = [[[OptionLists getDurationLists] objectAtIndex:durationIndex] objectAtIndex:1];
        shippingIndex = NO_CATEGORY;
        dispatchIndex = 3;
        dispatchTimeMax = [[[OptionLists getDispatchLists] objectAtIndex:dispatchIndex] objectAtIndex:1];
        returnIndex = 1;
        returnsAcceptedOption = [[[OptionLists getReturnLists] objectAtIndex:returnIndex] objectAtIndex:1];
        refundOption = [[[OptionLists getReturnLists] objectAtIndex:returnIndex] objectAtIndex:2];
        returnsWithinOption = [[[OptionLists getReturnLists] objectAtIndex:returnIndex] objectAtIndex:3];
        returnShippingIndex = 0;
        returnShippingCode = [[[OptionLists getReturnShippingLists] objectAtIndex:returnShippingIndex] objectAtIndex:1];
        
        price = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 210, 30)];
        price.placeholder = @"Name Your Price";
        [price setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [price setReturnKeyType:UIReturnKeyDone];
        [price addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        paypal = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 210, 30)];
        paypal.placeholder = @"Your Paypal Account";
        [paypal setKeyboardType:UIKeyboardTypeEmailAddress];
        [paypal setReturnKeyType:UIReturnKeyDone];
        [paypal addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        shippingCost = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 210, 30)];
        shippingCost.placeholder = @"Name your shipping cost";
        [shippingCost setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [shippingCost setReturnKeyType:UIReturnKeyDone];
        [shippingCost addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        zipcode = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 210, 30)];
        zipcode.placeholder = @"Your Zipcode";
        [zipcode setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [zipcode setReturnKeyType:UIReturnKeyDone];
        [zipcode addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
    }
    return self;
}

- (void) setCategory: (NSDictionary *) dict
{
    NSString *name = [dict objectForKey:@"CategoryName"];
    categoryCode = [dict objectForKey:@"CategoryID"];
    [detailStringArray replaceObjectAtIndex:DETAIL_CATEGORY withObject:name];
    [self.tableView reloadData];
    NSLog(@"Setting Category to: %@\t%@", [detailStringArray objectAtIndex:DETAIL_CATEGORY], categoryCode);
}

- (void) setAuction: (NSNumber *) index
{
    int idx = [index intValue];
    NSMutableArray *arr = [[OptionLists getAuctionLists] objectAtIndex:idx];
    [detailStringArray replaceObjectAtIndex:DETAIL_AUCTION withObject:[arr objectAtIndex:0]];
    auctionCode = [arr objectAtIndex:1];
    auctionIndex = idx;
    [self.tableView reloadData];
    NSLog(@"Setting Auction to: %@\t%@\t%d", [detailStringArray objectAtIndex:DETAIL_AUCTION], auctionCode, auctionIndex);
}

- (void) setDuration: (NSNumber *) index
{
    int idx = [index intValue];
    NSMutableArray *arr = [[OptionLists getDurationLists] objectAtIndex:idx];
    [detailStringArray replaceObjectAtIndex:DETAIL_DURATION withObject:[arr objectAtIndex:0]];
    durationCode = [arr objectAtIndex:1];
    durationIndex = idx;
    [self.tableView reloadData];
    NSLog(@"Setting Duration to: %@\t%@\t%d", [detailStringArray objectAtIndex:DETAIL_DURATION], durationCode, durationIndex);
}

- (void) setShipping: (NSNumber *) index
{
    int idx = [index intValue];
    NSMutableArray *arr = [[OptionLists getShippingLists] objectAtIndex:idx];
    [detailSRStringArray replaceObjectAtIndex:DETAIL_SR_SHIPPING withObject:[arr objectAtIndex:0]];
    shippingCode = [arr objectAtIndex:1];
    shippingIndex = idx;
    [self.tableView reloadData];
    NSLog(@"Setting Shipping to: %@\t%@\t%d", [detailSRStringArray objectAtIndex:DETAIL_SR_SHIPPING], shippingCode, shippingIndex);
}

- (void) setDispatch: (NSNumber *) index
{
    int idx = [index intValue];
    NSMutableArray *arr = [[OptionLists getDispatchLists] objectAtIndex:idx];
    [detailSRStringArray replaceObjectAtIndex:DETAIL_SR_DISPATCH withObject:[arr objectAtIndex:0]];
    dispatchTimeMax = [arr objectAtIndex:1];
    dispatchIndex = idx;
    [self.tableView reloadData];
    NSLog(@"Setting Dispatch Time to: %@ %d", dispatchTimeMax, dispatchIndex);
} 

- (void) setReturn: (NSNumber *) index
{
    int idx = [index intValue];
    NSMutableArray *arr = [[OptionLists getReturnLists] objectAtIndex:idx];
    [detailSRStringArray replaceObjectAtIndex:DETAIL_SR_RETURN withObject:[arr objectAtIndex:0]];
    returnsAcceptedOption = [arr objectAtIndex:1];
    refundOption = [arr objectAtIndex:2];
    returnsWithinOption = [arr objectAtIndex:3];
    returnIndex = idx;
    [self.tableView reloadData];
    NSLog(@"Setting Return to: %@\t%@\t%@\t%@\t%d", [detailSRStringArray objectAtIndex:DETAIL_SR_RETURN], returnsAcceptedOption, refundOption, returnsWithinOption, returnIndex);
}

- (void) setReturnShipping: (NSNumber *) index
{
    int idx = [index intValue];
    NSMutableArray *arr = [[OptionLists getReturnShippingLists] objectAtIndex:idx];
    [detailSRStringArray replaceObjectAtIndex:DETAIL_SR_RETURN_SHIPPING withObject:[arr objectAtIndex:0]];
    returnShippingCode = [arr objectAtIndex:0];
    returnShippingIndex = idx;
    [self.tableView reloadData];
    NSLog(@"Setting Return Shipping to: %@\t%@\t%d", [detailSRStringArray objectAtIndex:DETAIL_SR_RETURN_SHIPPING],returnShippingCode, returnShippingIndex);
} 

- (void) VerifyAddItemResponse: (NSMutableData *) data
{
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data];
    NSLog(@"%@", [dict description]);
    NSDictionary *response = [dict objectForKey:@"VerifyAddItemResponse"];
    NSString *ack = [response objectForKey:@"Ack"];
    
    if ([ack isEqualToString:@"Success"]) {
        
    } else if ([ack isEqualToString:@"Failure"]) {
        NSString *errorMessage = [[response objectForKey:@"Errors"] objectForKey:@"LongMessage"];
        
        /*
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [message show];
         */
    }
}

- (void) submit
{
    // There should be checks to validate the fields
    
    NSLog(@"Submit BTN clicked");
    NSLog(@"Title: %@", title.text);
    NSLog(@"Desc: %@", desc.text);
    NSLog(@"Setting Category to: %@\t%@", [detailStringArray objectAtIndex:DETAIL_CATEGORY], categoryCode);
    NSLog(@"Setting Auction to: %@\t%@\t%d", [detailStringArray objectAtIndex:DETAIL_AUCTION], auctionCode, auctionIndex);
    NSLog(@"Setting Duration to: %@\t%@\t%d", [detailStringArray objectAtIndex:DETAIL_DURATION], durationCode, durationIndex);
    NSLog(@"Setting Shipping to: %@\t%@\t%d", [detailSRStringArray objectAtIndex:DETAIL_SR_SHIPPING], shippingCode, shippingIndex);
    NSLog(@"Setting Dispatch to: %@\t%@\t%d", [detailSRStringArray objectAtIndex:DETAIL_SR_DISPATCH], dispatchTimeMax, dispatchIndex);
    NSLog(@"Setting Return to: %@\t%@\t%@\t%@\t%d", [detailSRStringArray objectAtIndex:DETAIL_SR_RETURN], returnsAcceptedOption, refundOption, returnsWithinOption, returnIndex);
    NSLog(@"Setting Return Shipping to: %@\t%@\t%d", [detailSRStringArray objectAtIndex:DETAIL_SR_RETURN_SHIPPING],returnShippingCode, returnShippingIndex);
    
    NSString *returnPolicy = @"<ReturnsAcceptedOption>ReturnsNotAccepted</ReturnsAcceptedOption>";
    if ([returnsAcceptedOption isEqualToString:@"ReturnsAccepted"]) {
        returnPolicy = [NSString stringWithFormat:@"<ReturnsAcceptedOption>ReturnsAccepted</ReturnsAcceptedOption>"
                        "<RefundOption>%@</RefundOption>"
                        "<ReturnsWithinOption>%@</ReturnsWithinOption>"
                        "<ShippingCostPaidByOption>%@</ShippingCostPaidByOption>", refundOption, returnsWithinOption, returnShippingCode];
    }
    
    NSLog(@"VerifyAddItemRequest");
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *body = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<VerifyAddItemRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
                      "<ErrorLanguage>en_US</ErrorLanguage>"
                      "<WarningLevel>High</WarningLevel>"
                      "<Item>"
                      "<Title>%@</Title>"
                      "<Description>%@</Description>"
                      "<PrimaryCategory>"
                      "<CategoryID>%@</CategoryID>"
                      "</PrimaryCategory>"
                      "<StartPrice>%@</StartPrice>"
                      "<CategoryMappingAllowed>true</CategoryMappingAllowed>"
                      "<ConditionID>1000</ConditionID>"
                      "<Country>US</Country>"
                      "<Currency>USD</Currency>"
                      "<DispatchTimeMax>%@</DispatchTimeMax>"
                      "<ListingDuration>%@</ListingDuration>"
                      "<ListingType>%@</ListingType>"
                      "<Quantity>1</Quantity>"
                      "<PaymentMethods>PayPal</PaymentMethods>"
                      "<PayPalEmailAddress>%@</PayPalEmailAddress>"
                      "<PostalCode>%@</PostalCode>"
                      "<ReturnPolicy>%@</ReturnPolicy>"
                      "<ShippingDetails>"
                      "<ShippingType>Flat</ShippingType>"
                      "<ShippingServiceOptions>"
                      "<ShippingServicePriority>1</ShippingServicePriority>"
                      "<ShippingService>%@</ShippingService>"
                      "<ShippingServiceCost>%@</ShippingServiceCost>"
                      "</ShippingServiceOptions>"
                      "</ShippingDetails>"
                      "<Site>US</Site>"
                      "</Item>"
                      "<RequesterCredentials>"
                      "<eBayAuthToken>%@</eBayAuthToken>"
                      "</RequesterCredentials>"
                      "<WarningLevel>High</WarningLevel>"
                      "</VerifyAddItemRequest>", title.text, desc.text, @"377", price.text, dispatchTimeMax, durationCode, auctionCode, paypal.text, zipcode.text, returnPolicy, shippingCode, shippingCost.text, del->authKey];
    
    //NSLog(@"%@", body);

    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:ebay_url andBody:body callName:@"VerifyAddItem"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
    
    [HttpPostHelper doPost:request from:self withSelector: @selector(VerifyAddItemResponse:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.navigationController);
    UILabel *label = [[UILabel alloc]init];
    label.text = @"Pick options";
    [label setFont:[UIFont fontWithName:@"Futura" size:20]];
    label.frame = CGRectMake(0, 0, 200, 200);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
	label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.navigationItem.titleView = label;
    
    uploadThread = [[NSThread alloc] initWithTarget:self selector:@selector(uploadVideoFile) object:nil];
    // Category
    // Start Price
    // Duration
    // Paypal account
    // Shipping Details
    // Return Details

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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 2) {
        return [detailNameArray count];
    } if (section == 3) {
        return [detailSRNameArray count];
    } else return 1;
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
            [cell addSubview:title];
        } else if (indexPath.section == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell addSubview:desc];
        } else if (indexPath.section == 2) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
            if (indexPath.row == DETAIL_PRICE) {
                [cell addSubview:price];
            } else if (indexPath.row == DETAIL_PAYPAL)
            {
                [cell addSubview:paypal];
            }else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = [detailNameArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [detailStringArray objectAtIndex:indexPath.row];
        }  else if (indexPath.section == 3) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
            if (indexPath.row == DETAIL_SR_SHIPPING_COST) {
                [cell addSubview:shippingCost];
            } else if (indexPath.row == DETAIL_SR_ZIPCODE) {
                [cell addSubview:zipcode];
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = [detailSRNameArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [detailSRStringArray objectAtIndex:indexPath.row];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell setBackgroundColor:[UIColor redColor]];
            cell.textLabel.text = @"Submit";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) return 145;
    return 45;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Title";
    } else if (section == 1) {
        return @"Description";
    } else if (section == 2) {
        return @"List Details";
    } else if (section == 3) {
        return @"Shipping and Return";
    } else return @"Finalize and submit";
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction) textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
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

- (void) getTopLevelCategories: (NSMutableData *) data
{
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data];
    NSLog(@"%@", [dict description]);
    NSMutableArray *categoryArray = [[[dict objectForKey:@"GetCategoriesResponse"] objectForKey:@"CategoryArray"] objectForKey:@"Category"];
    
    SubCategoryViewController *view = [[SubCategoryViewController alloc] initWithStyle:UITableViewStyleGrouped andArray:categoryArray];
    [view registerParentViewController:self withSelector:@selector(setCategory:)];
    [view setDepth:1];
    [self.navigationController pushViewController:view animated:YES];
    /*
    for (int i = 0; i < [categoryArray count]; i++) {
        NSDictionary *category = [categoryArray objectAtIndex:i];
        NSLog(@"%d\t%@\t%@", i, [category objectForKey:@"CategoryName"], [category objectForKey:@"CategoryID"]);
    }
    */
}

- (void) GetCategoriesRequest
{
    NSLog(@"GetCategories");
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *body = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<GetCategoriesRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
                      "<CategorySiteID>0</CategorySiteID>"
                      "<LevelLimit>1</LevelLimit>"
                      "<DetailLevel>ReturnAll</DetailLevel>"
                      "<RequesterCredentials>"
                      "<eBayAuthToken>%@</eBayAuthToken>"
                      "</RequesterCredentials>"
                      "<WarningLevel>High</WarningLevel>"
                      "</GetCategoriesRequest>", del->authKey];
    
    
    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:ebay_url andBody:body callName:@"GetCategories"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
    
    [HttpPostHelper doPost:request from:self withSelector: @selector(getTopLevelCategories:)];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 2) {
        if (indexPath.row == DETAIL_CATEGORY) {
            NSLog(@"Clicked Category");
            [self GetCategoriesRequest];
            /*
            CategoryViewController *view = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                andArray:[OptionLists getCategoryLists]];
            [view registerParentViewController:self withSelector:@selector(setCategory:) andIndex:categoryIndex];
            [view setSectionTitle:@"Which a category that best fits your item?"];
            [self.navigationController pushViewController:view animated:YES];
             */
        } else if (indexPath.row == DETAIL_AUCTION) {
            NSLog(@"Clicked Auction");
            CategoryViewController *view = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                andArray:[OptionLists getAuctionLists]];
            [view registerParentViewController:self withSelector:@selector(setAuction:) andIndex:auctionIndex];
            [view setSectionTitle:@"How do you want your auction to be?"];
            [self.navigationController pushViewController:view animated:YES];
        } else if (indexPath.row == DETAIL_DURATION) {
            NSLog(@"Clicked Duration");
            CategoryViewController *view = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                andArray:[OptionLists getDurationLists]];
            [view registerParentViewController:self withSelector:@selector(setDuration:) andIndex:durationIndex];
            [view setSectionTitle:@"How long do you want your item to be listed?"];
            [self.navigationController pushViewController:view animated:YES];
        } 
    }
    if (indexPath.section == 3) {
        if (indexPath.row == DETAIL_SR_SHIPPING) {
            NSLog(@"Clicked Shipping");
            CategoryViewController *view = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                andArray:[OptionLists getShippingLists]];
            [view registerParentViewController:self withSelector:@selector(setShipping:) andIndex:shippingIndex];
            [view setSectionTitle:@"Which shipping method will you use?"];
            [self.navigationController pushViewController:view animated:YES];
        } else if (indexPath.row == DETAIL_SR_DISPATCH) {
            NSLog(@"Clicked Dispatch");
            CategoryViewController *view = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                andArray:[OptionLists getDispatchLists]];
            [view registerParentViewController:self withSelector:@selector(setDispatch:) andIndex:dispatchIndex];
            [view setSectionTitle:@"How long would it take for you to send the item?"];
            [self.navigationController pushViewController:view animated:YES];
        } else if (indexPath.row == DETAIL_SR_RETURN) {
            NSLog(@"Clicked Return");
            CategoryViewController *view = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                andArray:[OptionLists getReturnLists]];
            [view registerParentViewController:self withSelector:@selector(setReturn:) andIndex:returnIndex];
            [view setSectionTitle:@"What is your return policy? How long will you accept returns?"];
            [self.navigationController pushViewController:view animated:YES];
        } else if (indexPath.row == DETAIL_SR_RETURN_SHIPPING) {
            NSLog(@"Clicked Return Shipping");
            CategoryViewController *view = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                andArray:[OptionLists getReturnShippingLists]];
            [view registerParentViewController:self withSelector:@selector(setReturnShipping:) andIndex:returnShippingIndex];
            [view setSectionTitle:@"Who will pay the return shipping cost?"];
            [self.navigationController pushViewController:view animated:YES];
        }
    }
    if (indexPath.section == 4) [self submit];
}

@end
