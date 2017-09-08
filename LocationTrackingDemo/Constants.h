//
//  Constants.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/6/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#endif /* Constants_h */

#define FONTSIZE_SCALE [[UIScreen mainScreen] bounds].size.height == 480 ? 1 : ([[UIScreen mainScreen] bounds].size.height == 568 ? 1.12 : ([[UIScreen mainScreen] bounds].size.width == 375 ? 1.21 : ([[UIScreen mainScreen] bounds].size.width == 414 ? 1.23 : 1.23)))

#define ADDRESS_LOCATION_URL "http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false"

#define AUTOCOMPLETE_ADDRESS_LOCATION_URL "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment|geocode&radius=500&language=en&key=%@"

#define SERVER_KEY "AIzaSyA8K9lEs2E6T6qBh5UAVRLWJJnGr9es0Rw"


typedef NS_ENUM(NSUInteger, SearchResultTableType) {
    
    ResultTableTypeStart,
    ResultTableTypeDestination,
};
