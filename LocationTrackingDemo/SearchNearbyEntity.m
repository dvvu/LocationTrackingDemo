//
//  SearchNearbyEntity.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/11/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "SearchNearbyEntity.h"

@interface SearchNearbyEntity () 

@property (nonatomic) NSDictionary* data;

@end

@implementation SearchNearbyEntity

#pragma mark - initWithData

- (instancetype)initWithData:(NSDictionary *)data {
    
    self = [super init];
    
    if (self) {
        
        _data = data;
        [self setupValue];
    }
    return self;
}

#pragma mark - Properties

- (void)setupValue {
    
    _placeID = [_data objectForKey:@"place_id"];
    id geometry = [_data valueForKey:@"geometry"];
    id loactionString = [geometry valueForKey:@"location"];

    NSNumber* lat = [loactionString valueForKey:@"lat"];
    NSNumber* lng = [loactionString valueForKey:@"lng"];
    _location = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lng.doubleValue];
}

@end
