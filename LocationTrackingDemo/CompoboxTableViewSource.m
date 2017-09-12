//
//  CompoboxTableViewSource.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/11/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "CompoboxTableViewSource.h"

@interface CompoboxTableViewSource () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView* tableView;
@property (nonatomic) CompoboxType type;
@property (nonatomic) NSArray* dataArray;

@end

@implementation CompoboxTableViewSource

#pragma mark - initWithTableView

- (instancetype)initWithTableView:(UITableView *)tableView andType:(CompoboxType)type {
    
    if (self = [super init]) {
        
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _dataArray = [[NSArray alloc] init];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        _tableView.contentInset = UIEdgeInsetsMake(0, -15, 0, 0);
        [self setupDataWithType:type];
    }
    
    return self;
}

#pragma mark - setupDataWithType

- (void)setupDataWithType:(CompoboxType)type {
    
    _type = type;
    
    if (type == CompoboxTypeFindPlace) {
        
        /*
         ATM
         Bank
         Bus station
         Cafe
         Fire Station
         Gas station
         Hospital
         Hotel
         Market
         Museum
         Police
         Post Office
         School
         Restaurant
         */
       
       _dataArray = @[@"ATM",@"Bank",@"Bus station",@"Cafe",@"Fire Station",@"Gas station",@"Hospital",@"Hotel",@"Market",@"Museum",@"Police",@"Post Office",@"School",@"Restaurant"];
    } else {
        
      _dataArray = @[@"1 Km",@"2 Km",@"5 Km",@"10 Km",@"20 Km",@"50 Km"];
    }
}

#pragma mark - numberOfSectionsInTableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

#pragma mark - numberOfRowsInSection

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

#pragma mark - cellForRowAtIndexPath

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text = _dataArray[indexPath.row];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
    return cell;
}

#pragma mark - heightForRowAtIndexPath

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 30;
}

#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate) {
        
        [_delegate selectedData:_dataArray[indexPath.row] withType:_type];
    }
    [UIView animateWithDuration:0.05 animations: ^ {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
}

@end
