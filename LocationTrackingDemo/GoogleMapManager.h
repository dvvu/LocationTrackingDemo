//
//  GoogleMapManager.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/7/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleMapManager : NSObject

#pragma mark - getAddressFromLocation
- (void)getAddressFromLocation:(CLLocation *)loaction withCompletion:(void (^)(NSString* placeName, NSError *error))completion;

#pragma mark - autoCompleteSearchWithKey
- (void)autoCompleteSearchWithKey:(NSString *)searchKey withCompletion:(void (^)(NSArray* results, NSError *error))completion;

#pragma mark - getAddressFromLocation
- (instancetype)initWithMapView:(GMSMapView *)mapView andLocationManager:(CLLocationManager *)locationManager;

#pragma mark - getCurrentLocation
- (CLLocation *)getCurrentLocation;

@end
