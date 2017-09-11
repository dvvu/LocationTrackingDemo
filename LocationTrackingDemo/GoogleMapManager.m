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
#import "Constants.h"

@interface GoogleMapManager () <CLLocationManagerDelegate>

@property (nonatomic) dispatch_queue_t drawDirectionPolylineQuue;
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
        _drawDirectionPolylineQuue = dispatch_queue_create("DIRECTION_QUEUE", DISPATCH_QUEUE_SERIAL);
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
        
        
        NSString* startString1 = [startString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* destinationString1 = [destinationString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString* directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
        NSString* directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving", directionsAPI, startString1, destinationString1];
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

#pragma mark - decodePolyLine

- (NSMutableArray *)decodePolyLine:(NSString *)encodedStr {
    
    NSMutableString* encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\" options:NSLiteralSearch range:NSMakeRange(0,[encoded length])];
   
    NSInteger index = 0;
    NSInteger lat = 0;
    NSInteger lng = 0;
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    while (index < [encoded length]) {
        
        NSInteger ascCharacter;
        NSInteger bitsShift = 0;
        NSInteger result = 0;
        
        do {
            ascCharacter = [encoded characterAtIndex:index++] - 63; // ascii
            result |= (ascCharacter & 0x1f) << bitsShift; //or and *2^shift
            bitsShift += 5;
        } while (ascCharacter >= 0x20); // 32 -> space
        
        // old get < 0 else
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        bitsShift = 0;
        result = 0;
     
        do {
            ascCharacter = [encoded characterAtIndex:index++] - 63;
            result |= (ascCharacter & 0x1f) << bitsShift;
            bitsShift += 5;
        } while (ascCharacter >= 0x20);
        
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        
        NSNumber* latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber* longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        
        CLLocation* location = [[CLLocation alloc] initWithLatitude: [latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:location];
    }
 
    return array;
}

@end
