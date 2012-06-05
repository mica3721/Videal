//
// ImageResizer.m
// UDPTesting2
//
// Created by Do Hyeong Kwon on 8/16/11.
// Copyright 2011 Standford University. All rights reserved.
//

#import "ImageResizer.h"


@implementation UIImage (INResizeImageAllocator)
+ (UIImage*)imageWithImage:(UIImage*)image
			  scaledToSize:(CGSize)newSize;
{
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}
- (UIImage*)scaleImageToSize:(CGSize)newSize
{
	return [UIImage imageWithImage:self scaledToSize:newSize];
}


@end