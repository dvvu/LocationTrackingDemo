//
//  SearchResultTableViewCell.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/7/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "SearchResultTableViewCell.h"
#import "Constants.h"
#import "Masonry.h"

@implementation SearchResultTableViewCell

#pragma mark - initWithStyle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupLayoutForCell];
    }
    
    return self;
}

#pragma mark - setupLayoutForCell

- (void)setupLayoutForCell {
    
    CGFloat scale = FONTSIZE_SCALE;
    
    _placeName = [[UILabel alloc] init];
    _placeName.text = @"result";
    [_placeName setTextColor:[UIColor whiteColor]];
    [_placeName setFont:[UIFont boldSystemFontOfSize:12 * scale]];
    [self addSubview:_placeName];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"ic_greenUser"];
    [self addSubview:_iconImageView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.left.equalTo(self).offset(8);
        make.centerY.equalTo(self);
        make.width.and.height.equalTo(@20);
    }];
    
    [_placeName mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.right.equalTo(self).offset(-8);
        make.centerY.equalTo(self);
        make.height.equalTo(@20);
    }];
}

@end
