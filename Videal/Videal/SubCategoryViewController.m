//
//  SubCategoryViewController.m
//  Videal
//
//  Created by Eunmo Yang on 5/28/12.
//  Copyright (c)d 2012 Stanford University. All rights reserved.
//

#import "SubCategoryViewController.h"
#import "AppDelegate.h"
#import "XMLReader.h"
#import "HttpPostHelper.h"

static NSString* const ebay_url = @"https://api.sandbox.ebay.com/ws/api.dll";

@interface SubCategoryViewController ()

@end

@implementation SubCategoryViewController

- (id)initWithStyle: (UITableViewStyle)style
           andArray: (NSMutableArray *)arr
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        sectionTitle = @"";
        categoryArray = arr;
    }
    return self;
}

- (void) registerParentViewController: (ItemViewController *)vc
                         withSelector: (SEL) sel
{
    itemViewController = vc;
    selector = sel;
}

- (void) setDepth:(int)d
{
    depth = d;
}

- (void) setSectionTitle:(NSString *)title
{
    sectionTitle = title;
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
    cell.textLabel.text = [[categoryArray objectAtIndex:indexPath.row] objectForKey:@"CategoryName"];
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionTitle;
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

- (void) getNextLevelCategories: (NSMutableData *) data
{
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data];
    NSLog(@"%@", [dict description]);
    NSMutableArray *nextCategoryArray = [[[dict objectForKey:@"GetCategoriesResponse"] objectForKey:@"CategoryArray"] objectForKey:@"Category"];
    
    
    for (int i = 0; i < [nextCategoryArray count]; i++) {
        NSDictionary *category = [nextCategoryArray objectAtIndex:i];
        NSString *level = [category objectForKey:@"CategoryLevel"];
        //NSString *parentId = [category objectForKey:@"CategoryParentID"];
        //NSLog(@"%@\t%@", id, parentId);
        if ([level isEqualToString:[NSString stringWithFormat:@"%d", depth]]) {
            [nextCategoryArray removeObjectAtIndex:i];
        }
    }
    
    
    //[nextCategoryArray removeObjectAtIndex:0];
    SubCategoryViewController *view = [[SubCategoryViewController alloc] initWithStyle:UITableViewStyleGrouped andArray:nextCategoryArray];
    [view registerParentViewController:itemViewController withSelector:@selector(setCategory:)];
    [view setDepth:(depth + 1)];
    [self.navigationController pushViewController:view animated:YES];
    /*
     for (int i = 0; i < [categoryArray count]; i++) {
     NSDictionary *category = [categoryArray objectAtIndex:i];
     NSLog(@"%d\t%@\t%@", i, [category objectForKey:@"CategoryName"], [category objectForKey:@"CategoryID"]);
     }
     */
}


- (void) GetCategoriesRequest: (NSString *) categoryCode
{
    NSLog(@"GetCategories");
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *levelLimit = [NSString stringWithFormat:@"%d", (depth + 1)];
    NSString *body = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<GetCategoriesRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
                      "<CategorySiteID>0</CategorySiteID>"
                      "<CategoryParent>%@</CategoryParent>"
                      "<LevelLimit>%@</LevelLimit>"
                      "<DetailLevel>ReturnAll</DetailLevel>"
                      "<RequesterCredentials>"
                      "<eBayAuthToken>%@</eBayAuthToken>"
                      "</RequesterCredentials>"
                      "<WarningLevel>High</WarningLevel>"
                      "</GetCategoriesRequest>", categoryCode, levelLimit, del->authKey];
    
    
    NSMutableURLRequest *request = [HttpPostHelper createeBayRequestWithURL:ebay_url andBody:body callName:@"GetCategories"];
    [HttpPostHelper setCert:request];
    NSLog(@"%@", body);
    
    [HttpPostHelper doPost:request from:self withSelector: @selector(getNextLevelCategories:)];
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
    
    NSDictionary *category = [categoryArray objectAtIndex:indexPath.row];
    NSString *leafNode = [category objectForKey:@"LeafCategory"];
    
    if (leafNode == nil) {
        NSString *code = [category objectForKey:@"CategoryID"];
        [self GetCategoriesRequest:code];
    } else {
        [itemViewController performSelector:selector withObject:category];
        [self.navigationController popToViewController:itemViewController animated:YES];
    }
}

@end
