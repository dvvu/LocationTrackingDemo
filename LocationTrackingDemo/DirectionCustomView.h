//
//  DirectionCustomView.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/6/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "DirectionCustomViewDelegate.h"
#import <UIKit/UIKit.h>

@interface DirectionCustomView : UIView

@property (nonatomic) UITableView* destinationSearchResultsTableView;
@property (nonatomic) UITableView* startSearchResultsTableView;
@property (nonatomic) id<DirectionCustomViewDelegate> delegate;
@property (nonatomic) UITextField* startTextField;

#pragma mark - setSearchResultsForTable
- (void)setSearchResultsForTable:(NSArray *)searchResults with:(SearchResultTableType)type;

#pragma mark - hideKeyboard
- (void)hideKeyboard;

@end
