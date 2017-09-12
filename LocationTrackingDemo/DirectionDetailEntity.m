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
      
        _path = [GMSPath pathFromEncodedPath:points];
        _distance = [[leg objectForKey:@"distance"] objectForKey:@"text"];
        _duration = [[leg objectForKey:@"duration"] objectForKey:@"text"];
        _startLocation = [[CLLocation alloc] initWithLatitude:[_path coordinateAtIndex:0].latitude longitude:[_path coordinateAtIndex:0].longitude];
        _endLocation = [[CLLocation alloc] initWithLatitude:[_path coordinateAtIndex:_path.count-1].latitude longitude:[_path coordinateAtIndex:_path.count-1].longitude];
        dispatch_sync(dispatch_get_main_queue(), ^{
         
             _polyline = [GMSPolyline polylineWithPath:_path];
         });
    }
    
    return self;
}

//#pragma mark - decodePolyLine
//
//- (ThreadSafeForMutableArray *)decodePolyLine:(NSString *)encodedStr {
//
//    _locationPoints = [[ThreadSafeForMutableArray alloc] init];
//
//    NSMutableString* encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
//    [encoded appendString:encodedStr];
//    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\" options:NSLiteralSearch range:NSMakeRange(0,[encoded length])];
//
//    NSInteger index = 0;
//    NSInteger lat = 0;
//    NSInteger lng = 0;
//
//    while (index < [encoded length]) {
//
//        NSInteger ascCharacter;
//        NSInteger bitShift = 0;
//        NSInteger result = 0;
//
//        do {
//            ascCharacter = [encoded characterAtIndex:index++] - 63; // ascii
//            result |= (ascCharacter & 0x1f) << bitShift; //or and *2^shift
//            bitShift += 5;
//        } while (ascCharacter >= 0x20); // 32 -> space
//
//        // old get < 0 else
//        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
//        lat += dlat;
//        bitShift = 0;
//        result = 0;
//
//        do {
//            ascCharacter = [encoded characterAtIndex:index++] - 63;
//            result |= (ascCharacter & 0x1f) << bitShift;
//            bitShift += 5;
//        } while (ascCharacter >= 0x20);
//
//        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
//        lng += dlng;
//
//        NSNumber* latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
//        NSNumber* longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
//
//        CLLocation* location = [[CLLocation alloc] initWithLatitude: [latitude floatValue] longitude:[longitude floatValue]];
//        [_locationPoints addObject:location];
//    }
//
//    return _locationPoints;
//}

@end
