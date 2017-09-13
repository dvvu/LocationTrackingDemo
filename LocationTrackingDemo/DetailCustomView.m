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

@property (nonatomic) UIImageView* detailImageView;
@property (nonatomic) UIButton* exitButton;
@property (nonatomic) UILabel* distanceLabel;
@property (nonatomic) UILabel* durationLabel;

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

    _distanceLabel.text = [NSString stringWithFormat:@"Distance: %0.1f Km",directionDetailEntity.distance.floatValue/1000];
    _durationLabel.text = [NSString stringWithFormat:@"Duration: %@",directionDetailEntity.duration];
}

#pragma mark - setupLayoutSubview

- (void)setupLayoutSubview {

    CGFloat scale = FONTSIZE_SCALE;
    [self setBackgroundColor:[UIColor colorWithRed:48/255.f green:22/255.f blue:49/255.f alpha:0.8f]];
    
    _exitButton = [[UIButton alloc] init];
    [_exitButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_exitButton addTarget:self action:@selector(closeDetailView:) forControlEvents:UIControlEventTouchUpInside];
    [_exitButton setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [self addSubview:_exitButton];
    
    _distanceLabel = [[UILabel alloc] init];
    [_distanceLabel setTextColor:[UIColor whiteColor]];
    [_distanceLabel setFont:[UIFont boldSystemFontOfSize:10 * scale]];
    [self addSubview:_distanceLabel];
    
    _durationLabel = [[UILabel alloc] init];
    [_durationLabel setTextColor:[UIColor whiteColor]];
    [_durationLabel setFont:[UIFont boldSystemFontOfSize:10 * scale]];
    [self addSubview:_durationLabel];
    
    _detailImageView = [[UIImageView alloc] init];
    _detailImageView.image = [UIImage imageNamed:@"ic_whiteDetail"];
    [self addSubview:_detailImageView];
    
    [_exitButton mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.width.and.height.mas_offset(20);
    }];
    
    [_detailImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_exitButton.mas_bottom).offset(0);
        make.left.equalTo(self).offset(8);
        make.width.and.height.mas_offset(40);
    }];
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_exitButton.mas_bottom).offset(0);
        make.left.equalTo(_detailImageView.mas_right).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.mas_offset(20);
    }];
    
    [_durationLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_distanceLabel.mas_bottom).offset(5);
        make.left.equalTo(_detailImageView.mas_right).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.mas_offset(20);
    }];
}

#pragma mark - closeDetailView

- (IBAction)closeDetailView:(id)sender {
    
    if (_delegate) {
        
        [_delegate closeDetailCustomView];
    }
}

@end
