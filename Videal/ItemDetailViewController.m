//
//  ItemDetailViewController.m
//  Videal
//
//  Created by Eunmo Yang on 5/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ItemDetailViewController.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // This should ultimately be a "grouped" tableview with detail disclosure buttons.
    
    UILabel *title_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, 30)];
    title_label.text = @"Help buyers find your items with a great title";
    [self.view addSubview:title_label];
    
    UITextField *title_textfield = [[UITextField alloc] initWithFrame:CGRectMake(5, 40, self.view.frame.size.width - 10, 30)];
    title_textfield.placeholder = @"title";
    title_textfield.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:title_textfield];
    
    UILabel *desc_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 75, self.view.frame.size.width - 10, 30)];
    desc_label.text = @"Describe the Item you're selling";
    [self.view addSubview:desc_label];
    
    UITextField *desc_textfield = [[UITextField alloc] initWithFrame:CGRectMake(5, 110, self.view.frame.size.width - 10, 90)];
    desc_textfield.placeholder = @"description";
    desc_textfield.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:desc_textfield];
    
    UILabel *category_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 205, self.view.frame.size.width - 10, 30)];
    category_label.text = @"Find a matching category";
    [self.view addSubview:category_label];
    
    // This should be an element with a detail disclosure button.
    
    // Start Price: textfield
    // Buy It Now Price: textfield
    // Duration: detail disclosure to table view
    // Paypal account: textfield
    // Shipping Details: detail disclosure to table view
    // Return Details: detail disclosure to table view
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
