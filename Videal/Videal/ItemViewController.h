//
//  ItemViewController.h
//  Videal
//
//  Created by Eunmo Yang on 5/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UITableViewController<UITextFieldDelegate, UITextViewDelegate> {
    NSArray *detailNameArray;
    NSArray *detailStringArray;
    NSArray *detailValueArray;
    UITextField *title;
    UITextView *desc;
}

- (void) dismissKeyboard;

@end
