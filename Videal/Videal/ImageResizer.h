//
// ImageResizer.h
// UDPTesting2
//
// Created by Do Hyeodng Kwon on 8/16/11.
// Copyright 2011 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (INResizeImageAllocator)
+ (UIImage*)imageWithImage:(UIImage*)image
			  scaledToSize:(CGSize)newSize;
- (UIImage*)scaleImageToSize:(CGSize)newSize;
@end