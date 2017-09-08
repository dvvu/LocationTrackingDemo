//
//  SupportManager.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/7/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "SupportManager.h"

@implementation SupportManager

#pragma mark - resizeimage

+ (UIImage *)resizeImage:(UIImage*)originalImage scaledToSize:(CGSize)size {
    
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size)) {
        
        return originalImage;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
