//
//  SearchPlacesCustomView.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/11/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CompoboxCustomViewHeightDelegate <NSObject>

#pragma mark - searchWithPlace
- (void)searchWithPlace:(NSString *)placeName andRadius:(NSString *)radius;

#pragma mark - updateCompoboxCustomViewHeight
- (void)updateCompoboxCustomViewHeight;

#pragma mark - resetCompoboxCustomViewHeight
- (void)resetCompoboxCustomViewHeight;

@end

@interface SearchPlacesCustomView : UIView

@property (nonatomic) id<CompoboxCustomViewHeightDelegate>delegate;

@end
