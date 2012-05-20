//
//  DealSaver.h
//  Videal
//
//  Created by Do Hyeong Kwon on 5/19/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

/* Forward definitions for the datatypes in a package */

#define DATATYPE_BYTE 1
#define DATATYPE_SHORT 2
#define DATATYPE_INT 3
#define DATATYPE_STRING 4
#define DATATYPE_DATE 5
#define DATATYPE_DOUBLE 6
#define DATATYPE_BINARY 7

@interface DealSaver : UIButton {
    int pos;
    Byte buffer[10000];
}



-(void) SaveDeals: (NSMutableArray*) deals;

-(NSMutableArray *) LoadDeals;


@end
