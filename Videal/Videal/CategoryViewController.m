//
//  CategoryViewController.m
//  Videal
//
//  Created by Eunmo Yang on 5/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "CategoryViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (id)initWithStyle: (UITableViewStyle)style
           andArray: (NSMutableArray *)arr;
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        categoryArray = arr;
        
        // Define the eBay categories
        /*
        categoryArray = [[NSMutableArray alloc] init];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Antiques", @"20081", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Art", @"550", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Baby", @"2984", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Books", @"267", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Business & Industrial", @"12576", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Cameras & Photo", @"625", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Cell Phones & Accessories", @"15032", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Clothing, Shoes & Accessories", @"11450", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Coins & Paper Money", @"11116", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Collectibles", @"1", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Computers/Tablets & Networking", @"58058", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Consumer Electonics", @"293", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Crafts", @"14339", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Dolls & Bears", @"237", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"DVDs & Movies", @"11232", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Entertainment Memorabilia", @"45100", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Gift Cards & Coupons", @"172008", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Health & Beauty", @"26395", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Home & Garden", @"11700", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Jewelry & Watches", @"281", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Music", @"11233", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Musical Instruments & Gear", @"619", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Pet Supplies", @"1281", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Pottery & Glass", @"870", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Real Estate", @"10542", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Specialty Services", @"316", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Sporting Goods", @"382", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Sports Mem, Cards & Fan Shop", @"64482", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Stamps", @"260", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Tickets", @"1305", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Toys & Hobbies", @"220", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Travel", @"3252", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Video Games", @"1249", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Everything Else", @"99", nil]];
        [categoryArray addObject:[[NSArray alloc] initWithObjects:@"Partner", @"10159", nil]];
         */
    }
    return self;
}

- (void) registerParentViewController: (ItemViewController *)vc
                         withSelector: (SEL)sel
                             andIndex: (int) index;
{
    itemViewController = vc;
    selector = sel;
    selectedIndex = index;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [categoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [[categoryArray objectAtIndex:indexPath.row] objectAtIndex:0];
    if (indexPath.row == selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Choose a category that best matches your item";
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
    
    [itemViewController performSelector:selector withObject:[NSNumber numberWithInt:indexPath.row]];
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

@end
