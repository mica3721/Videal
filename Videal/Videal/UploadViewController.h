//
//  UploadViewController.h
//  Videal
//
//  Created by Eunmo Yang on 5/28/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBayItemDetails.h"

@interface UploadViewController : UITableViewController {
    @public
    EBayItemDetails *ebayItemDetails;
    NSURL *videoLink;
    NSMutableArray *fees;
    NSMutableArray *feesWithFormat;
    NSString *totalFee;
    UIProgressView *progressBar;
    BOOL uploadComplete;
}

- (id) initWithStyle: (UITableViewStyle)style
            andArray: (NSMutableArray *)arr;

@end
