//
//  CategoryViewController.h
//  Videal
//
//  Created by Eunmo Yang on 5/23d/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemViewController.h"

@interface CategoryViewController : UITableViewController {
    @public
    NSMutableArray *categoryArray;
    UITableViewController *itemViewController;
    int selectedIndex;
    SEL selector;
    NSString *sectionTitle;
    BOOL dontSelect;
    UITableViewCellStyle cellStyle;
}

- (id) initWithStyle: (UITableViewStyle)style
            andArray: (NSMutableArray *)arr;

- (void) registerParentViewController: (UITableViewController *)vc
                         withSelector: (SEL) sel
                             andIndex: (int) index;
- (void) setSectionTitle: (NSString *)title;

@end
