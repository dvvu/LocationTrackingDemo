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
        GMSPath* path = [GMSPath pathFromEncodedPath:points];
        
        _distance = [[leg objectForKey:@"distance"] objectForKey:@"text"];
        _duration = [[leg objectForKey:@"duration"] objectForKey:@"text"];
        _startLocation = [[CLLocation alloc] initWithLatitude:[path coordinateAtIndex:0].latitude longitude:[path coordinateAtIndex:0].longitude];
   
        dispatch_sync(dispatch_get_main_queue(), ^{
         
             _polyline = [GMSPolyline polylineWithPath:path];
         });
    }
    
    return self;
}

@end
