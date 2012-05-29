//
//  SubCategoryViewController.h
//  Videal
//
//  Created by Eunmo Yang on 5/28/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemViewController.h"

@interface SubCategoryViewController : UITableViewController {
    NSMutableArray *categoryArray;
    ItemViewController *itemViewController;
    SEL selector;
    NSString *sectionTitle;
    int depth;
}

- (id) initWithStyle: (UITableViewStyle)style
            andArray: (NSMutableArray *)arr;

- (void) registerParentViewController: (ItemViewController *)vc
                         withSelector: (SEL) sel;

- (void) setDepth: (int) d;
- (void) setSectionTitle: (NSString *)title;

@end
