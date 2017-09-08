//
//  SearchResultsTableViewDelegate.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/7/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#ifndef SearchResultsTableViewDelegate_h
#define SearchResultsTableViewDelegate_h


#endif /* SearchResultsTableViewDelegate_h */

#import <Foundation/Foundation.h>
#import "SearchResultEntity.h"
#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol SearchResultsTableViewDelegate <NSObject>

#pragma mark - updateTextField
- (void)updateTextField:(SearchResultEntity *)searchResultEntity withType:(SearchResultTableType)type;

@end
