//
//  SupportManager.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/7/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SupportManager : NSObject

#pragma mark - resizeimage
+ (UIImage *)resizeImage:(UIImage*)originalImage scaledToSize:(CGSize)size;

@end
