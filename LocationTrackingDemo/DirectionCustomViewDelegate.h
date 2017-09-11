//
//  DirectionCustomViewDelegate.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/6/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#ifndef DirectionCustomViewDelegate_h
#define DirectionCustomViewDelegate_h


#endif /* DirectionCustomViewDelegate_h */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol DirectionCustomViewDelegate <NSObject>

#pragma mark - drawDestination
- (void)drawDestinationWithPlaceName:(NSString *)startPlaceName andDestinationPlaceName:(NSString *)destinationPlaceName;

#pragma mark - getCurrentLocation
- (void)getCurrentLocation:(CGPoint)currentPoint;

#pragma mark - searchCompleteWithText
- (void)searchCompleteWithText:(NSString *)searchString resultsType:(SearchResultTableType)type forTable:(UITableView *)tableView;

@end
