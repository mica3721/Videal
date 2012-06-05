//
//  SearchViewController.h
//  Videal
//
//  Created by Do Hyeong Kwon on 5/3/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource> {
    UISearchBar *searchBar;
    UITableView *categories;
    NSArray *options;
}

@end
