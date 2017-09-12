//
//  SearchNearbyEntity.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/11/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface SearchNearbyEntity : NSObject

@property (nonatomic) NSString* placeName;
@property (nonatomic) NSString* placeID;
@property (nonatomic) CLLocation* location;

#pragma mark - initWithData
- (instancetype)initWithData:(NSDictionary *)data;

@end
