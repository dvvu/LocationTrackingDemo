//
//  GoogleMapManager.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/7/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThreadSafeForMutableArray.h"

@interface GoogleMapManager : NSObject

#pragma mark - drawDiectionWithStartLocation
- (void)drawDiectionWithStartLocation:(CLLocation *)startLocation andDestinationLocation:(CLLocation *)destinationLocation completion:(void (^)(DirectionDetailEntity *))completion;

#pragma mark - drawDiectionWithPlaceName
- (void)drawDiectionWithPlaceName:(NSString *)startString andDestinationName:(NSString *)destinationString completion:(void (^)(DirectionDetailEntity *))completion;

#pragma mark - searchAtLocation

- (void)searchAtLocation:(CLLocation *)currentLocation withPlaceName:(NSString *)placeaName andRadius:(NSString *)radius completion:(void (^)(ThreadSafeForMutableArray *))completion;

#pragma mark - getAddressFromLocation
- (void)getAddressFromLocation:(CLLocation *)loaction withCompletion:(void (^)(NSString* placeName, NSError *error))completion;

#pragma mark - autoCompleteSearchWithKey
- (void)autoCompleteSearchWithKey:(NSString *)searchKey withCompletion:(void (^)(NSArray* results, NSError *error))completion;

#pragma mark - getAddressFromLocation
- (instancetype)initWithMapView:(GMSMapView *)mapView andLocationManager:(CLLocationManager *)locationManager;

#pragma mark - getCurrentLocation
- (CLLocation *)getCurrentLocation;

@end
