//
//  SearchResultsTableViewSource.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/7/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "SearchResultsTableViewDelegate.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SearchResultsTableViewSource : NSObject

@property (nonatomic) id<SearchResultsTableViewDelegate>delegate;

#pragma mark - initWithTableView
- (instancetype)initWithTableView:(UITableView *)tableView;

#pragma mark - setSearchResultData
- (void)setSearchResultData:(NSArray *)results withType:(SearchResultTableType)type;

@end
