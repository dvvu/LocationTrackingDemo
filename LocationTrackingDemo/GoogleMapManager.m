//
//  GoogleMapManager.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/7/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GoogleMapManager.h"
#import "Constants.h"

@interface GoogleMapManager () <CLLocationManagerDelegate>

@property (nonatomic) dispatch_queue_t autoCompleteSearchQuue;
@property (nonatomic) dispatch_queue_t currentLocationQuue;
@property (nonatomic) CLLocationManager* locationManager;
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
    }
    
    return self;
}

#pragma mark - getAddressFromLocation

- (void)getAddressFromLocation:(CLLocation *)loaction withCompletion:(void (^)(NSString* placeName, NSError *error))completion {
    
    dispatch_async(_currentLocationQuue, ^ {
        
        NSString* searchURL = [NSString stringWithFormat:@ADDRESS_LOCATION_URL,loaction.coordinate.latitude, loaction.coordinate.longitude];
        
        NSError* error;
        NSString* locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchURL] encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                
                completion(@"", error);
            });
        } else {
            
            NSData* data = [locationString dataUsingEncoding:NSUTF8StringEncoding];
            id jSONresult = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (jSONresult) {
    
                id result = [[jSONresult valueForKey:@"results"] objectAtIndex:0];
                
                if (result) {
                    
                    NSString* placeName = [result valueForKey:@"formatted_address"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        
                        completion(placeName, nil);
                    });
                }
            }
        }
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

@end
