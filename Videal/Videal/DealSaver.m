//
//  DealSaver.m
//  Videal
//
//  Created by Do Hyeong Kwon on 5/19/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "DealSaver.h"

@implementation DealSaver



/*WRITING THINGS TO THE BUFFER*/ 
-(void) writeInt: (int) someInt {
    buffer[pos] = DATATYPE_INT;
    pos++;
    buffer[pos] = *(((unsigned char *)&someInt) + 3);
    pos ++;
    buffer[pos] = *(((unsigned char *)&someInt) + 2);
    pos ++;
    buffer[pos] = *(((unsigned char *)&someInt) + 1);
    pos ++;
    buffer[pos] = *(((unsigned char *)&someInt));
    pos ++;
}

-(void) writeString: (NSString *) someString {
    const char* strTmp = [someString cStringUsingEncoding:-2147481280];
    buffer[pos] = DATATYPE_STRING;
    pos++;
    short length = strlen(strTmp);
    buffer[pos] = *(((unsigned char *)&length) + 1);
    pos ++;
    buffer[pos] = *(((unsigned char *)&length));
    pos ++;
    memcpy(buffer + pos, strTmp, length);
    pos+= length;
}


/*READING THINGS FROM THE BUFFER*/
-(int) readInt {
    Byte intVerifier = buffer[pos];
    assert(intVerifier == DATATYPE_INT);
    (pos)++;
    int a;
    ((unsigned char *)(&a))[3] = buffer[pos]; 
    (pos) ++;
    ((unsigned char *)(&a))[2] = buffer[pos];
    (pos) ++;
    ((unsigned char *)(&a))[1] = buffer[pos]; 
    (pos) ++;
    ((unsigned char *)(&a))[0] = buffer[pos];
    (pos) ++;
    return a;
}

-(NSString *) readString {
    Byte stringVerifier = buffer[pos];
    assert(stringVerifier == DATATYPE_STRING);
    (pos) ++;
    short stringLength;
    ((unsigned char *)(&stringLength))[1] = buffer[pos];
    (pos) ++;
    ((unsigned char *)(&stringLength))[0] = buffer[pos];
    (pos) ++;
    char a[stringLength + 1];
    memcpy(&a, buffer + pos, stringLength);
    a[stringLength] =(char) nil;
    (pos) += stringLength;
    NSString * string = [NSString stringWithCString:(const char *)a encoding:-2147481280];
    return string;
}



-(NSString *) filePath {
    NSArray * pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"deals.plist"];
}

-(void) SaveDeals: (NSMutableArray*) deals {
    
    pos = 0;
    
    [self writeInt:[deals count]];
    
    for (int i = 0; i < [deals count]; i++) {
        [self writeString:[deals objectAtIndex:i]];
    }
    NSData *totalFriendsData = [NSData dataWithBytes:buffer length:pos];
    [totalFriendsData writeToFile:[self filePath] atomically:YES];

}

-(NSMutableArray *) LoadDeals {
    pos = 0;
    NSString * filePath = [self filePath];
    BOOL dealFileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    NSMutableArray *arr = [NSMutableArray new];
    if (dealFileExists) {
        NSData *dealData= [[NSData alloc] initWithContentsOfFile:filePath];
        [dealData getBytes:buffer length:[dealData length]];
        int num = [self readInt];
        for (int i = 0; i < num; i ++) {
            [arr addObject:[self readString]];
        }
        
    }
    return arr;
}





@end
