//
//  SearchViewController.h
//  Videal
//
//  Created by Do Hyeong Kwon on 5/3/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate> {
    UISearchBar *searchBar;
    UITableView *categories;
}

@end
