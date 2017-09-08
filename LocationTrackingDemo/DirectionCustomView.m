//
//  DirectionCustomView.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/6/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "SearchResultsTableViewSource.h"
#import "DirectionCustomView.h"
#import "Constants.h"
#import "Masonry.h"

@interface DirectionCustomView () <UITextFieldDelegate, SearchResultsTableViewDelegate>

@property (nonatomic) SearchResultsTableViewSource* destinationSearchResultsTableViewSource;
@property (nonatomic) SearchResultsTableViewSource* startSearchResultsTableViewSource;
@property (nonatomic) UITextField* destinationTextField;
@property (nonatomic) UIButton* currentlocationButton;
@property (nonatomic) UIButton* drawDestinationButton;
@property (nonatomic) UILabel* destinationLabel;
@property (nonatomic) UILabel* startLabel;

@end

@implementation DirectionCustomView

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
     
    _startLabel = [[UILabel alloc] init];
    [_startLabel setTextColor:[UIColor whiteColor]];
    [_startLabel setFont:[UIFont boldSystemFontOfSize:12 * scale]];
    _startLabel.text = @"Enter start point";
    [self addSubview:_startLabel];
    
    _destinationLabel = [[UILabel alloc] init];
    [_destinationLabel setTextColor:[UIColor whiteColor]];
    [_destinationLabel setFont:[UIFont boldSystemFontOfSize:12 * scale]];
    _destinationLabel.text = @"Enter destination point";
    [self addSubview:_destinationLabel];
    
    _startTextField = [[UITextField alloc] init];
    _startTextField.placeholder = @"start point";
    [_startTextField setTextAlignment:NSTextAlignmentCenter];
    [_startTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_startTextField addTarget:self action:@selector(startTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_startTextField];
    
    _startSearchResultsTableView = [[UITableView alloc] init];
    _startSearchResultsTableViewSource = [[SearchResultsTableViewSource alloc] initWithTableView:_startSearchResultsTableView];
    _startSearchResultsTableViewSource.delegate = self;
    [_startSearchResultsTableView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_startSearchResultsTableView];
    
    _destinationTextField = [[UITextField alloc] init];
    _destinationTextField.placeholder = @"destination point";
    [_destinationTextField setTextAlignment:NSTextAlignmentCenter];
    [_destinationTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_destinationTextField addTarget:self action:@selector(destinationTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_destinationTextField];

    _drawDestinationButton = [[UIButton alloc] init];
    [_drawDestinationButton setImage:[UIImage imageNamed:@"ic_direction"] forState:UIControlStateNormal];
    [_drawDestinationButton addTarget:self action:@selector(drawDestination:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_drawDestinationButton];
    
    _currentlocationButton = [[UIButton alloc] init];
    [_currentlocationButton setImage:[UIImage imageNamed:@"ic_location"] forState:UIControlStateNormal];
    [_currentlocationButton addTarget:self action:@selector(getCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_currentlocationButton];
    
    _destinationSearchResultsTableView = [[UITableView alloc] init];
    _destinationSearchResultsTableViewSource = [[SearchResultsTableViewSource alloc] initWithTableView:_destinationSearchResultsTableView];
    _destinationSearchResultsTableViewSource.delegate = self;
    [_destinationSearchResultsTableView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_destinationSearchResultsTableView];
    
    [_startLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.mas_offset(30);
    }];
    
    [_startTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_startLabel.mas_bottom).offset(2);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(_currentlocationButton.mas_left).offset(-5);
        make.height.mas_offset(30);
    }];
    
    [_startSearchResultsTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_startTextField.mas_bottom).offset(0);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(_currentlocationButton.mas_left).offset(-5);
        make.height.mas_offset(0);
    }];
    
    [_currentlocationButton mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_startLabel.mas_bottom).offset(2);
        make.left.equalTo(_startTextField.mas_right).offset(5);
        make.right.equalTo(self).offset(-8);
        make.width.and.height.mas_offset(30);
    }];
    
    [_destinationLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_startSearchResultsTableView.mas_bottom).offset(5);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.mas_offset(30);
    }];
    
    [_destinationTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_destinationLabel.mas_bottom).offset(2);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(_drawDestinationButton.mas_left).offset(-5);
        make.height.mas_offset(30);
    }];
    
    [_drawDestinationButton mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_destinationLabel.mas_bottom).offset(2);
        make.right.equalTo(self).offset(-8);
        make.left.equalTo(_destinationTextField.mas_right).offset(5);
        make.width.and.height.mas_offset(30);
    }];
    
    [_destinationSearchResultsTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_destinationTextField.mas_bottom).offset(0);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(_drawDestinationButton.mas_left).offset(-5);
        make.height.mas_offset(0);
    }];
}

#pragma mark - drawDestination

- (IBAction)drawDestination:(id)sender {
    
    if (_delegate) {
        
        [_delegate drawDestination];
        [self hideKeyboard];
    }
}

#pragma mark - getCurrentLocation

- (IBAction)getCurrentLocation:(id)sender {
    
    if (_delegate) {
        
        [_delegate getCurrentLocation: [_currentlocationButton convertRect:self.bounds toView:nil].origin];
        
        if (_startSearchResultsTableView.frame.size.height > 0) {
            
            [_delegate searchCompleteWithText:@"" resultsType:ResultTableTypeStart forTable:_startSearchResultsTableView];
        }
        
        if (_destinationSearchResultsTableView.frame.size.height > 0) {
            
            [_delegate searchCompleteWithText:@"" resultsType:ResultTableTypeDestination forTable:_destinationSearchResultsTableView];
        }
    }
}

#pragma mark - hideKeyboard

- (void)hideKeyboard {
    
    [_startTextField resignFirstResponder];
    [_destinationTextField resignFirstResponder];
}

#pragma mark - textFieldDidChange

- (void)destinationTextFieldDidChange:(UITextField*)textField {
    
    if (_delegate) {
        
        [_delegate searchCompleteWithText:textField.text resultsType:ResultTableTypeDestination forTable:_destinationSearchResultsTableView];
 
        if (_startSearchResultsTableView.frame.size.height > 0) {
            
            [_delegate searchCompleteWithText:@"" resultsType:ResultTableTypeStart forTable:_startSearchResultsTableView];
        }
    }
}

#pragma mark - startTextFieldDidChange

- (void)startTextFieldDidChange:(UITextField*)textField {
    
    if (_delegate) {
        
        [_delegate searchCompleteWithText:textField.text resultsType:ResultTableTypeStart forTable:_startSearchResultsTableView];
        
        if (_destinationSearchResultsTableView.frame.size.height > 0) {
            
            [_delegate searchCompleteWithText:@"" resultsType:ResultTableTypeDestination forTable:_destinationSearchResultsTableView];
        }
    }
}

#pragma mark - setDestinationSearchResults

- (void)setSearchResultsForTable:(NSArray *)searchResults with:(SearchResultTableType)type {
    
    if (type == ResultTableTypeDestination) {
        
        [_destinationSearchResultsTableViewSource setSearchResultData:searchResults withType:type];
    } else {
        
        [_startSearchResultsTableViewSource setSearchResultData:searchResults withType:type];
    }
}

#pragma mark - updateTextField

- (void)updateTextField:(SearchResultEntity *)searchResultEntity withType:(SearchResultTableType)type {
    
    if (type == ResultTableTypeDestination) {
        
        if (searchResultEntity.placeName) {
            
            _destinationTextField.text = searchResultEntity.placeName;
        } else {
            
            _destinationTextField.text = @"";
        }
        [_delegate searchCompleteWithText:@"" resultsType:ResultTableTypeDestination forTable:_destinationSearchResultsTableView];
    } else {
        
        if (searchResultEntity.placeName) {
            
            _startTextField.text = searchResultEntity.placeName;
        } else {
            
            _startTextField.text = @"";
        }
        
        [_delegate searchCompleteWithText:@"" resultsType:ResultTableTypeStart forTable:_startSearchResultsTableView];
    }
}

@end
