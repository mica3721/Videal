//
//  ItemViewController.m
//  Videal
//
//  Created by Eunmo Yang on 5/23/12.
//  Copyright (c) 2d012 Stanford University. All rights reserved.
//

#import "ItemViewController.h"
#import "OptionLists.h"
#import "CategoryViewController.h"
#import "XMLReader.h"
#import "HttpPostHelper.h"
#import "AppDelegate.h"
#import "SubCategoryViewController.h"
#import "UploadViewController.h"

static NSString* const ebay_url = @"https://api.sandbox.ebay.com/ws/api.dll";


@interface ItemViewController ()

@end

@implementation ItemViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        detailNameArray = [[NSArray alloc] initWithObjects:@"Category",@"Pricing",@"Start price",@"Paypal",@"Duration",nil];
        detailStringArray = [[NSMutableArray alloc] initWithObjects:@"", @"Auction-like", @"", @"",  @"7 days",nil];
        detailSRNameArray = [[NSArray alloc] initWithObjects:@"Shipping",@"Dispatch",@"Zipcode",@"Return",@"Return cost", nil];
        detailSRStringArray = [[NSMutableArray alloc] initWithObjects:@"", @"3 days", @"", @"Moneyback, 14 Days", @"paid by buyer", nil];
        
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
        
        zipcode = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 210, 30)];
        zipcode.placeholder = @"Your Zipcode";
        [zipcode setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [zipcode setReturnKeyType:UIReturnKeyDone];
        [zipcode addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        ebayItemDetails = [[EBayItemDetails alloc] init];
        
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

- (void)        alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{}

- (void) VerifyAddItemResponse: (NSMutableData *) data
{
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data];
    NSLog(@"%@", [dict description]);
    NSDictionary *response = [dict objectForKey:@"VerifyAddItemResponse"];
    NSString *ack = [response objectForKey:@"Ack"];
    
    if ([ack isEqualToString:@"Success"] || [ack isEqualToString:@"Warning"]) {
        NSMutableArray *fees = [[response objectForKey:@"Fees"] objectForKey:@"Fee"];
        UploadViewController *view = [[UploadViewController alloc] initWithStyle:UITableViewStyleGrouped andArray:fees];
        view->ebayItemDetails = ebayItemDetails;
        view->videoLink = videoLink;
        [self.navigationController pushViewController:view animated:YES];
    }
    else if ([ack isEqualToString:@"Failure"])
    {
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

- (void) verify
{
    NSLog(@"Verify BTN clicked");
    
    NSString *returnPolicy = @"<ReturnsAcceptedOption>ReturnsNotAccepted</ReturnsAcceptedOption>";
    if ([returnsAcceptedOption isEqualToString:@"ReturnsAccepted"]) {
        returnPolicy = [NSString stringWithFormat:@"<ReturnsAcceptedOption>ReturnsAccepted</ReturnsAcceptedOption>"
                        "<RefundOption>%@</RefundOption>"
                        "<ReturnsWithinOption>%@</ReturnsWithinOption>"
                        "<ShippingCostPaidByOption>%@</ShippingCostPaidByOption>", refundOption, returnsWithinOption, returnShippingCode];
    }
    
    NSLog(@"VerifyAddItemRequest");
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ebayItemDetails->title = title.text;
    ebayItemDetails->desc = desc.text;
    ebayItemDetails->category = categoryCode;
    ebayItemDetails->price = price.text;
    ebayItemDetails->dispatch = dispatchTimeMax;
    ebayItemDetails->duration = durationCode;
    ebayItemDetails->auction = auctionCode;
    ebayItemDetails->paypal = paypal.text;
    ebayItemDetails->zipcode = zipcode.text;
    ebayItemDetails->returnPolicy = returnPolicy;
    ebayItemDetails->shipping = shippingCode;
    ebayItemDetails->shippingCost = @"3";
    ebayItemDetails->authKey = del->authKey;
    NSString *body = [ebayItemDetails getVerifyAddItemRequestBody];

    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:ebay_url andBody:body callName:@"VerifyAddItem"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
    
    [HttpPostHelper doPost:request from:self withSelector: @selector(VerifyAddItemResponse:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Posting Details";
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"orange.png"]];
    
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
            if (indexPath.row == DETAIL_SR_ZIPCODE) {
                [cell addSubview:zipcode];
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = [detailSRNameArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [detailSRStringArray objectAtIndex:indexPath.row];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell setBackgroundColor:[UIColor redColor]];
            cell.textLabel.text = @"Validate";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
    } else return @"Validate your settings";
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
    if (indexPath.section == 4) [self verify];
}

@end
