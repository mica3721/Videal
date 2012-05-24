//
//  ItemViewController.m
//  Videal
//
//  Created by Eunmo Yang on 5/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ItemViewController.h"

@interface ItemViewController ()

@end

@implementation ItemViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void) submit
{
    NSLog(@"Submit BTN clicked");
    NSLog(@"Title: %@", title.text);
    NSLog(@"Desc: %@", desc.text);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Now list your item on eBay!";
    detailNameArray = [[NSArray alloc] initWithObjects:@"Category",@"Start price",@"Duration",@"Paypal",@"Shipping",@"Return", nil];
    detailStringArray = [[NSArray alloc] initWithObjects:@"", @"$1.00", @"7 days", @"", @"USPS", @"Moneyback, 30 days", nil];
    detailValueArray = [[NSArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", nil];
    
    /*
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [view addGestureRecognizer:tap];
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
     */
    
    title = [[UITextField alloc] initWithFrame:CGRectMake(20, 12, 280, 30)];
    title.placeholder = @"Title";
    [title setReturnKeyType:UIReturnKeyDone];
    [title addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    desc = [[UITextView alloc] initWithFrame:CGRectMake(15, 12, 290, 123)];
    desc.backgroundColor = [UIColor clearColor];
    [desc setReturnKeyType:UIReturnKeyDone];
    [desc setDelegate:self];
    
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 2) {
        return 4;
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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell setBackgroundColor:[UIColor redColor]];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section > 1) {
        cell.textLabel.text = [arrayAdobeProducts objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [arrayAppleProducts objectAtIndex:indexPath.row];
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
    } else return @"List Details";
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
    
    if (indexPath.section == 3) [self submit];
}

@end
