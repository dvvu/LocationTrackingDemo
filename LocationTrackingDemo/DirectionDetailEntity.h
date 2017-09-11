//
//  DirectionDetailEntity.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/8/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface DirectionDetailEntity : NSObject

@property (nonatomic) CLLocation* startLocation;
@property (nonatomic) GMSPolyline* polyline;
@property (nonatomic) NSString* distance;
@property (nonatomic) NSString* duration;

#pragma mark - initWithData
- (instancetype)initWithData:(NSDictionary *)jsonDictionary;

@end
