//
//  SearchPlacesCustomView.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/11/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "SearchPlacesCustomView.h"
#import "CompoboxTableViewSource.h"
#import "CompoboxCustomView.h"
#import "CompoboxCustomViewDelegate.h"
#import "Constants.h"
#import "Masonry.h"

@interface SearchPlacesCustomView () <CompoboxCustomViewDelegate, CompoboxTableViewSourceDelegate>

@property (nonatomic) CompoboxTableViewSource* placeFindTableViewSource;
@property (nonatomic) CompoboxTableViewSource* distanceTableViewSource;
@property (nonatomic) CompoboxCustomView* placeFindCompoboxCustomView;
@property (nonatomic) CompoboxCustomView* distanceCompoboxCustomView;
@property (nonatomic) UIButton* currentlocationButton;
@property (nonatomic) UITableView* placeFindTableView;
@property (nonatomic) UITableView* distanceTableView;
@property (nonatomic) UITextField* startTextField;
@property (nonatomic) UILabel* searchInfoLabel;
@property (nonatomic) UILabel* placeFindLabel;
@property (nonatomic) UILabel* distanceLabel;
@property (nonatomic) UIButton* searchButton;
@property (nonatomic) UILabel* startLabel;

@end

@implementation SearchPlacesCustomView

#pragma mark - initWithFrame

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupLayoutSubview];
    }
    
    return self;
}

#pragma mark - setupLayoutSubview

- (void)setupLayoutSubview {
    
    CGFloat scale = FONTSIZE_SCALE;
    [self setBackgroundColor:[UIColor colorWithRed:48/255.f green:22/255.f blue:49/255.f alpha:0.8f]];
    
//    _startLabel = [[UILabel alloc] init];
//    _startLabel.text = @"Enter start point";
//    [_startLabel setTextColor:[UIColor whiteColor]];
//    [_startLabel setFont:[UIFont boldSystemFontOfSize:12 * scale]];
//    [self addSubview:_startLabel];
//    
//    _startTextField = [[UITextField alloc] init];
//    _startTextField.placeholder = @"start point";
//    [_startTextField setTextAlignment:NSTextAlignmentCenter];
//    [_startTextField setBorderStyle:UITextBorderStyleRoundedRect];
//    [_startTextField addTarget:self action:@selector(startTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self addSubview:_startTextField];
//    
//    _currentlocationButton = [[UIButton alloc] init];
//    [_currentlocationButton setImage:[UIImage imageNamed:@"ic_location"] forState:UIControlStateNormal];
//    [_currentlocationButton addTarget:self action:@selector(getCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_currentlocationButton];
    
    _searchInfoLabel = [[UILabel alloc] init];
    [_searchInfoLabel setTextColor:[UIColor greenColor]];
    [_searchInfoLabel setFont:[UIFont boldSystemFontOfSize:11 * scale]];
    _searchInfoLabel.text = @"Selected name's place and radius to search";
    [self addSubview:_searchInfoLabel];
    
    _placeFindLabel = [[UILabel alloc] init];
    [_placeFindLabel setTextColor:[UIColor whiteColor]];
    [_placeFindLabel setFont:[UIFont boldSystemFontOfSize:10 * scale]];
    _placeFindLabel.text = @"Place Find";
    [self addSubview:_placeFindLabel];
    
    _placeFindCompoboxCustomView = [[CompoboxCustomView alloc] initWithType:CompoboxTypeFindPlace];
    _placeFindCompoboxCustomView.delegate = self;
    [self addSubview:_placeFindCompoboxCustomView];
    
    _distanceLabel = [[UILabel alloc] init];
    [_distanceLabel setTextColor:[UIColor whiteColor]];
    [_distanceLabel setFont:[UIFont boldSystemFontOfSize:10 * scale]];
    _distanceLabel.text = @"Radius";
    [self addSubview:_distanceLabel];
    
    _distanceCompoboxCustomView = [[CompoboxCustomView alloc] initWithType:CompoboxTypeRadius];
    _distanceCompoboxCustomView.delegate = self;
    [self addSubview:_distanceCompoboxCustomView];
    
    _searchButton = [[UIButton alloc] init];
    [_searchButton setImage:[UIImage imageNamed:@"ic_direction"] forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_searchButton];
    
    _placeFindTableView = [[UITableView alloc] init];
    _placeFindTableViewSource =[[CompoboxTableViewSource alloc] initWithTableView:_placeFindTableView andType:CompoboxTypeFindPlace];
    _placeFindTableViewSource.delegate = self;
    [self addSubview:_placeFindTableView];
    
    _distanceTableView = [[UITableView alloc] init];
    _distanceTableViewSource = [[CompoboxTableViewSource alloc] initWithTableView:_distanceTableView andType:CompoboxTypeRadius];
    _distanceTableViewSource.delegate = self;
    [self addSubview:_distanceTableView];
    
//    [_startLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.equalTo(self).offset(5);
//        make.left.equalTo(self).offset(8);
//        make.right.equalTo(self).offset(-8);
//        make.height.mas_offset(30);
//    }];
//    
//    [_startTextField mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.equalTo(_startLabel.mas_bottom).offset(2);
//        make.left.equalTo(self).offset(8);
//        make.right.equalTo(_currentlocationButton.mas_left).offset(-5);
//        make.height.mas_offset(30);
//    }];
//    
//    [_currentlocationButton mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.equalTo(_startLabel.mas_bottom).offset(2);
//        make.left.equalTo(_startTextField.mas_right).offset(5);
//        make.right.equalTo(self).offset(-8);
//        make.width.and.height.mas_offset(30);
//    }];
    
    [_searchInfoLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(self).offset(2);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.mas_offset(30);
    }];
    
    float placeFindWidth = [_placeFindLabel.text boundingRectWithSize:_placeFindLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:_placeFindLabel.font} context:nil].size.width;
    
    [_placeFindLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_searchInfoLabel.mas_bottom).offset(2);
        make.left.equalTo(self).offset(8);
        make.height.mas_offset(30);
        make.width.mas_equalTo(placeFindWidth * scale);
    }];
    
    [_placeFindCompoboxCustomView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_searchInfoLabel.mas_bottom).offset(2);
        make.left.equalTo(_placeFindLabel.mas_right).offset(5);
        make.width.mas_equalTo(_distanceCompoboxCustomView.mas_width);
        make.height.mas_offset(30);
    }];
    
    float distanceWidth = [_distanceLabel.text boundingRectWithSize:_distanceLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:_distanceLabel.font} context:nil].size.width;
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_searchInfoLabel.mas_bottom).offset(2);
        make.left.equalTo(_placeFindCompoboxCustomView.mas_right).offset(5);
        make.right.equalTo(_distanceCompoboxCustomView.mas_left).offset(-5);
        make.height.mas_offset(30);
        make.width.mas_equalTo(distanceWidth * scale);
    }];
    
    [_distanceCompoboxCustomView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_searchInfoLabel.mas_bottom).offset(2);
        make.left.equalTo(_distanceLabel.mas_right).offset(5);
        make.width.mas_equalTo(_placeFindCompoboxCustomView.mas_width);
        make.height.mas_offset(30);
    }];
    
    [_searchButton mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_searchInfoLabel.mas_bottom).offset(2);
        make.left.equalTo(_distanceCompoboxCustomView.mas_right).offset(5);
        make.right.equalTo(self).offset(-8);
        make.width.and.height.mas_offset(30);
    }];
    
    [_placeFindTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_placeFindCompoboxCustomView.mas_bottom).offset(0);
        make.centerX.equalTo(_placeFindCompoboxCustomView);
        make.width.mas_equalTo(_placeFindCompoboxCustomView.mas_width);
        make.height.mas_offset(0);
    }];
    
    [_distanceTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_distanceCompoboxCustomView.mas_bottom).offset(0);
        make.centerX.equalTo(_distanceCompoboxCustomView);
        make.width.mas_equalTo(_distanceCompoboxCustomView.mas_width);
        make.height.mas_offset(0);
    }];
    
    UITapGestureRecognizer* singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    [singleFingerTap setCancelsTouchesInView:NO];
    [self addGestureRecognizer:singleFingerTap];
}

#pragma mark - startTextFieldDidChange

- (void)startTextFieldDidChange:(UITextField*)textField {
    
}

#pragma mark - getCurrentLocation

- (IBAction)getCurrentLocation:(id)sender {
    
}

#pragma mark - search

- (IBAction)search:(id)sender {
    
    if (_delegate) {
        
        NSString* distance = [_distanceCompoboxCustomView.valueLabel.text stringByReplacingOccurrencesOfString:@" Km" withString:@"000"];
        [_delegate searchWithPlace:_placeFindCompoboxCustomView.valueLabel.text andRadius:distance];
    }
}

#pragma mark - tapOnView

- (void)tapOnView:(UITapGestureRecognizer *)recognizer {

    if (_delegate) {
        
        [_delegate resetCompoboxCustomViewHeight];
    }
}

#pragma mark - tapOnCompoboxCustomView

- (void)tapOnCompoboxCustomView:(CompoboxType)type {
    
    if (type == CompoboxTypeRadius) {
        
        [_placeFindTableView mas_updateConstraints:^(MASConstraintMaker* make) {
            
            make.height.equalTo(@0);
        }];
        
        [_distanceTableView mas_updateConstraints:^(MASConstraintMaker* make) {
            
            make.height.equalTo(@100);
        }];
    } else {
        
        [_placeFindTableView mas_updateConstraints:^(MASConstraintMaker* make) {
            
            make.height.equalTo(@100);
        }];
        
        [_distanceTableView mas_updateConstraints:^(MASConstraintMaker* make) {
            
            make.height.equalTo(@0);
        }];
    }
    
    if (_delegate) {
        
        [_delegate updateCompoboxCustomViewHeight];
    }
}

#pragma mark - selectedData

- (void)selectedData:(NSString *)data withType:(CompoboxType)type {
    
    if (type == CompoboxTypeRadius) {
        
        _distanceCompoboxCustomView.valueLabel.text = data;
        [_distanceTableView mas_updateConstraints:^(MASConstraintMaker* make) {
            
            make.height.equalTo(@0);
        }];
    } else {
        
        _placeFindCompoboxCustomView.valueLabel.text = data;
        [_placeFindTableView mas_updateConstraints:^(MASConstraintMaker* make) {
            
            make.height.equalTo(@0);
        }];
    }
    
    if (_delegate) {
        
        [_delegate resetCompoboxCustomViewHeight];
    }
}

@end
