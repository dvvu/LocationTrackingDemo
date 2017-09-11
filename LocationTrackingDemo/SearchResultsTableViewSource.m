//
//  SearchResultsTableViewSource.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/7/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "ThreadSafeForMutableArray.h"
#import "SearchResultsTableViewSource.h"
#import "SearchResultTableViewCell.h"
#import "SearchResultEntity.h"

@interface SearchResultsTableViewSource () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) ThreadSafeForMutableArray* resultEntiries;
@property (nonatomic) dispatch_queue_t searchResultQueue;
@property (nonatomic) SearchResultTableType type;
@property (nonatomic) UITableView* tableView;

@end

@implementation SearchResultsTableViewSource

#pragma mark - initWithTableView

- (instancetype)initWithTableView:(UITableView *)tableView {
    
    if (self = [super init]) {
        
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _searchResultQueue = dispatch_queue_create("SEARCH_RESULT_QUEUE", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

#pragma mark - setSearchResultData

- (void)setSearchResultData:(NSArray *)results withType:(SearchResultTableType)type {
    
    dispatch_async(_searchResultQueue, ^ {
        
        _resultEntiries = [ThreadSafeForMutableArray new];
        _type = type;
        if (results.count == 0) {
            
            SearchResultEntity* searchResultEntity = [[SearchResultEntity alloc] init];
            searchResultEntity.placeName = @"No result for searching";
            [_resultEntiries addObject:searchResultEntity];
        } else {
            
            for (NSDictionary* jsonDictionary in results) {
                
                SearchResultEntity* searchResultEntity = [[SearchResultEntity alloc] initWithData:jsonDictionary];
                [_resultEntiries addObject:searchResultEntity];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            [_tableView reloadData];
        });
    });
}

#pragma mark - numberOfSectionsInTableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

#pragma mark - numberOfRowsInSection

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _resultEntiries.count;
}

#pragma mark - cellForRowAtIndexPath

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    
    if (cell == nil) {
        
        cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    SearchResultEntity* searchResultEntity = [_resultEntiries objectAtIndex:indexPath.row];
    cell.placeName.text = searchResultEntity.placeName;
    
    return cell;
}

#pragma mark - heightForRowAtIndexPath

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate) {
        
        [_delegate updateTextField:[_resultEntiries objectAtIndex:indexPath.row] withType:_type];
    }
    
    [UIView animateWithDuration:0.05 animations: ^ {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
}

@end
