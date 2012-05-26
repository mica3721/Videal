//
//  CategoryViewController.h
//  Videal
//
//  Created by Eunmo Yang on 5/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemViewController.h"

@interface CategoryViewController : UITableViewController {
    NSMutableArray *categoryArray;
    ItemViewController *itemViewController;
    int selectedIndex;
    SEL selector;
}

- (id) initWithStyle: (UITableViewStyle)style
            andArray: (NSMutableArray *)arr;

- (void) registerParentViewController: (ItemViewController *)vc
                         withSelector: (SEL)sel
                             andIndex: (int) index;
- (void) setIndex: (int)index;

@end
