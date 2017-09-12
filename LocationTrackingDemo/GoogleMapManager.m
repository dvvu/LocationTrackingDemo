//
//  GoogleMapManager.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/7/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DirectionDetailEntity.h"
#import "GoogleMapManager.h"
#import "SearchNearbyEntity.h"
#import "Constants.h"

@interface GoogleMapManager () <CLLocationManagerDelegate>

@property (nonatomic) ThreadSafeForMutableArray* searchNearbyResults;
@property (nonatomic) dispatch_queue_t drawDirectionPolylineQuue;
@property (nonatomic) dispatch_queue_t autoCompleteSearchQuue;
@property (nonatomic) dispatch_queue_t currentLocationQuue;
@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) dispatch_queue_t nearbySearchQuue;
@property (nonatomic) CLLocation* currentLocation;
@property (nonatomic) GMSMapView* mapView;

@end

@implementation GoogleMapManager

#pragma mark - initWithMapView

- (instancetype)initWithMapView:(GMSMapView *)mapView andLocationManager:(CLLocationManager *)locationManager {
    
    self = [super init];
    
    if (self) {
    
        _mapView = mapView;
        _locationManager = locationManager;
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.distanceFilter = 500;
        [_locationManager requestAlwaysAuthorization];
        [_locationManager startUpdatingLocation];
        
        _currentLocationQuue = dispatch_queue_create("CURRENT_LOCATION_QUEUE", DISPATCH_QUEUE_SERIAL);
        _autoCompleteSearchQuue = dispatch_queue_create("AUTOCOMPLETE_SEARCH_QUEUE", DISPATCH_QUEUE_SERIAL);
        _drawDirectionPolylineQuue = dispatch_queue_create("DIRECTION_QUEUE", DISPATCH_QUEUE_SERIAL);
        _nearbySearchQuue = dispatch_queue_create("NEARBY_SEARH_QUEUE", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

#pragma mark - getAddressFromLocation

- (void)getAddressFromLocation:(CLLocation *)loaction withCompletion:(void (^)(NSString* placeName, NSError *error))completion {
    
    dispatch_async(_currentLocationQuue, ^ {
        
        NSString* urlString = [NSString stringWithFormat:@ADDRESS_LOCATION_URL,loaction.coordinate.latitude, loaction.coordinate.longitude];
        
        NSURL* url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
            
            if (!data) {
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    
                    completion(nil, error);
                });
                return;
            }
            
            NSDictionary* jSONresult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];;
            
            if (error || [jSONresult[@"status"] isEqualToString:@"NOT_FOUND"] || [jSONresult[@"status"] isEqualToString:@"REQUEST_DENIED"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    
                    completion(nil, error);
                });
                return;
            } else {
              
                NSArray* results = [jSONresult valueForKey:@"results"];
              
                if (results.count > 0) {
                    
                    NSArray* result = [results objectAtIndex:0];
                    
                    if (result) {
                        
                        NSString* placeName = [result valueForKey:@"formatted_address"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            
                            completion(placeName, nil);
                        });
                    }
                } else {
                    
                    return;
                }
            }
        }];
        
        [task resume];
    });
}

#pragma mark - locationManager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (fabs(howRecent) < 15.0) {
        
        _currentLocation = location;
    }
}

#pragma mark - getCurrentLocation

- (CLLocation *)getCurrentLocation {
    
    return _currentLocation;
}

#pragma mark - autoCompleteSearchWithKey

- (void)autoCompleteSearchWithKey:(NSString *)searchKey withCompletion:(void (^)(NSArray* results, NSError *error))completion {
    
    dispatch_async(_autoCompleteSearchQuue, ^ {
        
        if (searchKey.length > 0) {
            
            NSString* urlString = [NSString stringWithFormat:@AUTOCOMPLETE_ADDRESS_LOCATION_URL,searchKey.lowercaseString,@SERVER_KEY];
            
            NSURL* url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
            
            NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSURLRequest* request = [NSURLRequest requestWithURL:url];
            NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
                
                if (!data) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        
                        completion(nil, error);
                    });
                    return;
                }
                
                NSDictionary* jSONresult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];;
                
                if (error || [jSONresult[@"status"] isEqualToString:@"NOT_FOUND"] || [jSONresult[@"status"] isEqualToString:@"REQUEST_DENIED"]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        
                        completion(nil, error);
                    });
                    return;
                } else {
                    
                    NSArray* results = [jSONresult valueForKey:@"predictions"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        
                        completion(results, nil);
                    });
                    return;
                }
            }];
            
            [task resume];
        }
    });
}

#pragma mark - drawDiectionWithStartLocation

- (void)drawDiectionWithStartLocation:(CLLocation *)startLocation andDestinationLocation:(CLLocation *)destinationLocation completion:(void (^)(DirectionDetailEntity* directionDetailEntity))completion {
    
    NSString* startString = [NSString stringWithFormat:@"%f,%f", startLocation.coordinate.latitude, startLocation.coordinate.longitude];
    NSString* destinationString = [NSString stringWithFormat:@"%f,%f", destinationLocation.coordinate.latitude, destinationLocation.coordinate.longitude];
    
    [self drawDiectionWithPlaceName:startString andDestinationName:destinationString completion:^(DirectionDetailEntity* directionDetailEntity) {
        
        if (directionDetailEntity) {
            
            completion(directionDetailEntity);
        }
    }];
}

#pragma mark - drawDiectionWithPlaceName

- (void)drawDiectionWithPlaceName:(NSString *)startString andDestinationName:(NSString *)destinationString completion:(void (^)(DirectionDetailEntity *))completion {
    
    dispatch_async(_currentLocationQuue, ^ {
        
        NSString* newStartString = [startString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* newDestinationString = [destinationString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString* directionsUrlString = [NSString stringWithFormat:@DIRECTION_URL, newStartString, newDestinationString];
        NSURL* directionsUrl = [NSURL URLWithString:directionsUrlString];
        
        NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler: ^(NSData* data, NSURLResponse* response, NSError* error) {
            
            NSDictionary* jSONresult = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error) {
                
                if (completion) {
                    
                    completion(nil);
                }
                return;
            }
            
            DirectionDetailEntity* directionDetailEntity;
            NSArray* routesArray = [jSONresult objectForKey:@"routes"];
            
            if ([routesArray count] > 0) {
                
                NSDictionary* routeDict = [routesArray objectAtIndex:0];
                directionDetailEntity = [[DirectionDetailEntity alloc] initWithData:routeDict];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if(completion)
                    
                    completion(directionDetailEntity);
            });
        }];
        
        [task resume];
    });
}

#pragma mark - searchAtLocation

- (void)searchAtLocation:(CLLocation *)currentLocation withPlaceName:(NSString *)placeaName andRadius:(NSString *)radius completion:(void (^)(ThreadSafeForMutableArray *))completion {
    
    dispatch_async(_nearbySearchQuue, ^ {
        
        NSString* searchPlace = [placeaName stringByReplacingOccurrencesOfString:@" " withString:@"_"].lowercaseString;
        NSString* locationString = [NSString stringWithFormat:@"%f,%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
        NSString* directionsUrlString = [NSString stringWithFormat:@NEARBY_SEARCH_URL, locationString,radius,searchPlace,@SERVER_KEY];
        NSURL* directionsUrl = [NSURL URLWithString:directionsUrlString];
        
        NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler: ^(NSData* data, NSURLResponse* response, NSError* error) {
            
            NSDictionary* jSONresult = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            if (error || [jSONresult[@"status"] isEqualToString:@"NOT_FOUND"] || [jSONresult[@"status"] isEqualToString:@"REQUEST_DENIED"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    
                    completion(nil);
                });
                return;
            }
            
            id addressIPError = [jSONresult valueForKey:@"error_message"];
           
            if (addressIPError) {
                
                NSLog(@"Error : %@", addressIPError);
            }
            
            if (error || !jSONresult) {
                
                if (completion) {
                    
                    completion(nil);
                }
                return;
            }
            
            // get location and placeID
            id results = [jSONresult valueForKey:@"results"];
            
            if (results) {
                
                _searchNearbyResults = [[ThreadSafeForMutableArray alloc] init];
                
                for (NSDictionary* result in results) {
                    
                    SearchNearbyEntity* searchNearbyEntity = [[SearchNearbyEntity alloc] initWithData:result];
                    [_searchNearbyResults addObject:searchNearbyEntity];
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    if(completion)
                        
                        completion(_searchNearbyResults);
                });
            } else {
                
                if (completion) {
                    
                    completion(nil);
                }
            }
        }];
        
        [task resume];
    });
}

@end
