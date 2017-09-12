//
//  CompoboxCustomView.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/11/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "CompoboxCustomView.h"
#import "Constants.h"
#import "Masonry.h"

@interface CompoboxCustomView ()

@property (nonatomic) UIImageView* iconImageView;
@property (nonatomic) CompoboxType type;

@end

@implementation CompoboxCustomView

#pragma mark - initWithFrame

- (instancetype)initWithType:(CompoboxType)type {
    
    self = [super init];
    
    if (self) {
        
        _type = type;
        [self setupLayoutSubview];
    }
    
    return self;
}

#pragma mark - setupLayoutSubview

- (void)setupLayoutSubview {
    
    CGFloat scale = FONTSIZE_SCALE;
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.cornerRadius = 5;
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"ic_down"];
    [self addSubview:_iconImageView];
    
    _valueLabel = [[UILabel alloc] init];
    
    if (_type == CompoboxTypeRadius) {
        
        _valueLabel.text =@"10 Km";
    } else {
        
        _valueLabel.text =@"Coffee";
    }
    
    [_valueLabel setTextColor:[UIColor darkGrayColor]];
    [_valueLabel setFont:[UIFont boldSystemFontOfSize:12 * scale]];
    [self addSubview:_valueLabel];
    
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-5);
        make.width.and.height.mas_offset(15);
    }];

    [_valueLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(_iconImageView.mas_left).offset(-2);
    }];
    
    UITapGestureRecognizer* singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    [self addGestureRecognizer:singleFingerTap];
}

#pragma mark - tapOnView

- (void)tapOnView:(UITapGestureRecognizer *)recognizer {
    
    if (_delegate) {
        
        [_delegate tapOnCompoboxCustomView:_type];
    }
}

@end
