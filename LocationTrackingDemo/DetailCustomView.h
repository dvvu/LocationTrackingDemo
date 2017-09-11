//
//  DetailCustomView.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/8/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "DetailCustomViewDelegate.h"
#import "DirectionDetailEntity.h"
#import <UIKit/UIKit.h>

@interface DetailCustomView : UIView

@property (nonatomic) id<DetailCustomViewDelegate>delegate;

#pragma mark - setupWithData
- (void)setupWithData:(DirectionDetailEntity *)directionDetailEntity;

@end
