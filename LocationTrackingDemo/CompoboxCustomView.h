//
//  CompoboxCustomView.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/11/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "CompoboxCustomViewDelegate.h"
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface CompoboxCustomView : UIView

@property (nonatomic) id<CompoboxCustomViewDelegate>delegate;
@property (nonatomic) UILabel* valueLabel;

- (instancetype)initWithType:(CompoboxType)type;

@end
