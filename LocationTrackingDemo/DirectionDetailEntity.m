//
//  DirectionDetailEntity.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/8/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "DirectionDetailEntity.h"

@implementation DirectionDetailEntity

#pragma mark - initWithData

- (instancetype)initWithData:(NSDictionary *)jsonDictionary {
    
    self = [super init];
    
    if (self) {
        
        NSDictionary* routeOverviewPolyline = [jsonDictionary objectForKey:@"overview_polyline"];
        NSDictionary* leg = [[jsonDictionary objectForKey:@"legs"] objectAtIndex:0];
        NSString* points = [routeOverviewPolyline objectForKey:@"points"];
      
        _path = [GMSMutablePath pathFromEncodedPath:points];
        _distance = [[leg objectForKey:@"distance"] objectForKey:@"value"];
        _duration = [[leg objectForKey:@"duration"] objectForKey:@"text"];
        _startLocation = [[CLLocation alloc] initWithLatitude:[_path coordinateAtIndex:0].latitude longitude:[_path coordinateAtIndex:0].longitude];
        _endLocation = [[CLLocation alloc] initWithLatitude:[_path coordinateAtIndex:_path.count-1].latitude longitude:[_path coordinateAtIndex:_path.count-1].longitude];
        dispatch_sync(dispatch_get_main_queue(), ^{
         
             _polyline = [GMSPolyline polylineWithPath:_path];
         });
    }
    
    return self;
}

@end
