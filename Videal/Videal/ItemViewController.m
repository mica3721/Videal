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

@interface ItemViewController ()

@end

@implementation ItemViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        detailNameArray = [[NSArray alloc] initWithObjects:@"Category",@"Pricing",@"Start price",@"Duration",@"Paypal",@"Shipping",@"Dispatch", @"Return", nil];
        detailStringArray = [[NSMutableArray alloc] initWithObjects:@"", @"Auction-like", @"", @"7 days", @"", @"USPS", @"3 days", @"Moneyback, 30 days", nil];
        
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
        dispatchIndex = 3;
        
        paypal = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 210, 30)];
        paypal.placeholder = @"Your Paypal Account";
        [paypal setKeyboardType:UIKeyboardTypeEmailAddress];
        [paypal setReturnKeyType:UIReturnKeyDone];
        [paypal addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        price = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 210, 30)];
        price.placeholder = @"Name Your Price";
        [price setKeyboardType:UIKeyboardTypeEmailAddress];
        [price setReturnKeyType:UIReturnKeyDone];
        [price addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
    }
    return self;
}

- (void) setCategory: (NSNumber *) index
{
    int idx = [index intValue];
    NSMutableArray *arr = [[OptionLists getCategoryLists] objectAtIndex:idx];
    [detailStringArray replaceObjectAtIndex:DETAIL_CATEGORY withObject:[arr objectAtIndex:0]];
    categoryCode = [arr objectAtIndex:1];
    categoryIndex = idx;
    [self.tableView reloadData];
    NSLog(@"Setting Category to: %@\t%@\t%d", [detailStringArray objectAtIndex:DETAIL_CATEGORY], categoryCode, categoryIndex);
}

- (void) setDispatch: (NSNumber *) index
{
    int idx = [index intValue];
    NSMutableArray *arr = [[OptionLists getDispatchLists] objectAtIndex:idx];
    [detailStringArray replaceObjectAtIndex:DETAIL_DISPATCH withObject:[arr objectAtIndex:0]];
    dispatchTimeMax = [arr objectAtIndex:1];
    dispatchIndex = idx;
    [self.tableView reloadData];
    NSLog(@"Setting Dispatch Time to: %@ %d", dispatchTimeMax, dispatchIndex);
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

- (void) submit
{
    NSLog(@"Submit BTN clicked");
    NSLog(@"Title: %@", title.text);
    NSLog(@"Desc: %@", desc.text);
    NSLog(@"Category: %@\t%@\t %d", [detailStringArray objectAtIndex:DETAIL_CATEGORY], categoryCode, categoryIndex);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 2) {
        return [detailNameArray count];
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
            } else if (indexPath.row == DETAIL_PAYPAL) {
                [cell addSubview:paypal];
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = [detailNameArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [detailStringArray objectAtIndex:indexPath.row];
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
    if (indexPath.section == 2) {
        if (indexPath.row == DETAIL_CATEGORY) {
            NSLog(@"Clicked Category");
            CategoryViewController *view = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                andArray:[OptionLists getCategoryLists]];
            [view registerParentViewController:self withSelector:@selector(setCategory:) andIndex:categoryIndex];
            [self presentModalViewController:view animated:YES];
        } else if (indexPath.row == DETAIL_DISPATCH) {
            NSLog(@"Clicked Dispatch");
            CategoryViewController *view = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                andArray:[OptionLists getDispatchLists]];
            [view registerParentViewController:self withSelector:@selector(setDispatch:) andIndex:dispatchIndex];
            [self presentModalViewController:view animated:YES];
        } else if (indexPath.row == DETAIL_AUCTION) {
            NSLog(@"Clicked Auction");
            CategoryViewController *view = [[CategoryViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                andArray:[OptionLists getAuctionLists]];
            [view registerParentViewController:self withSelector:@selector(setAuction:) andIndex:auctionIndex];
            [self presentModalViewController:view animated:YES];
        }
    }
    if (indexPath.section == 3) [self submit];
}

@end
