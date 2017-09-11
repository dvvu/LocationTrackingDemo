//
//  DetailCustomView.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/8/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "DetailCustomView.h"
#import "Constants.h"
#import "Masonry.h"

@interface DetailCustomView ()

@property (nonatomic) UIImageView* distanceImageView;
@property (nonatomic) UIImageView* durationImageView;
@property (nonatomic) UIButton* exitButton;
@property (nonatomic) UILabel* distance;
@property (nonatomic) UILabel* duration;

@end

@implementation DetailCustomView

#pragma mark - initWithFrame

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupLayoutSubview];
    }
    
    return self;
}

#pragma mark - setupWithData

- (void)setupWithData:(DirectionDetailEntity *)directionDetailEntity {

    _distance.text = directionDetailEntity.distance;
    _duration.text = directionDetailEntity.duration;
}

#pragma mark - setupLayoutSubview

- (void)setupLayoutSubview {

    CGFloat scale = FONTSIZE_SCALE;
    [self setBackgroundColor:[UIColor colorWithRed:160/255.f green:203/255.f blue:252/255.f alpha:0.8f]];
    
    _exitButton = [[UIButton alloc] init];
    [_exitButton addTarget:self action:@selector(closeDetailView:) forControlEvents:UIControlEventTouchUpInside];
    [_exitButton setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [self addSubview:_exitButton];
    
    _distance = [[UILabel alloc] init];
    [_distance setTextColor:[UIColor whiteColor]];
    [_distance setFont:[UIFont boldSystemFontOfSize:10 * scale]];
    [self addSubview:_distance];
    
    _duration = [[UILabel alloc] init];
    [_duration setTextColor:[UIColor whiteColor]];
    [_duration setFont:[UIFont boldSystemFontOfSize:10 * scale]];
    [self addSubview:_duration];
    
    _distanceImageView = [[UIImageView alloc] init];
    _distanceImageView.image = [UIImage imageNamed:@"ic_distance"];
    [self addSubview:_distanceImageView];
    
    _durationImageView = [[UIImageView alloc] init];
    _durationImageView.image = [UIImage imageNamed:@"ic_duration"];
    [self addSubview:_durationImageView];
    
    [_exitButton mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(8);
        make.width.and.height.mas_offset(10);
    }];
    
    [_distanceImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_exitButton.mas_bottom).offset(5);
        make.left.equalTo(self).offset(8);
        make.width.and.height.mas_offset(20);
    }];
    
    [_durationImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_distanceImageView.mas_bottom).offset(5);
        make.left.equalTo(self).offset(8);
        make.width.and.height.mas_offset(20);
    }];
    
    [_distance mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_exitButton.mas_bottom).offset(5);
        make.left.equalTo(_distanceImageView.mas_right).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.mas_offset(20);
    }];
    
    [_duration mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_distanceImageView.mas_bottom).offset(5);
        make.left.equalTo(_distanceImageView.mas_right).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.mas_offset(20);
    }];
}

- (IBAction)closeDetailView:(id)sender {
    
    if (_delegate) {
        
        [_delegate closeDetailCustomView];
    }
}

@end
