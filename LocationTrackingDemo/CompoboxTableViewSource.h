//
//  CompoboxTableViewSource.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/11/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol CompoboxTableViewSourceDelegate <NSObject>

#pragma mark - selectedData
- (void)selectedData:(NSString *)data withType:(CompoboxType)type;

@end

@interface CompoboxTableViewSource : NSObject

#pragma mark - initWithTableView
- (instancetype)initWithTableView:(UITableView *)tableView andType:(CompoboxType)type;
@property (nonatomic) id<CompoboxTableViewSourceDelegate>delegate;
@end
