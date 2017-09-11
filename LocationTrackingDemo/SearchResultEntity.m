//
//  SearchResultEntity.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/7/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "SearchResultEntity.h"

@interface SearchResultEntity ()

@property (nonatomic) NSDictionary* jsonDictionary;

@end

@implementation SearchResultEntity

#pragma mark - initWithData

- (instancetype)initWithData:(NSDictionary *)jsonDictionary {
    
    self = [super init];
   
    if (self) {
        
        _jsonDictionary = jsonDictionary;
        [self setupValue];
    }
    return self;
}

#pragma mark - Properties

- (void)setupValue {
    
    if (_jsonDictionary[@"description"] != [NSNull null]) {

        _placeName = _jsonDictionary[@"description"];
    }
    
    if (_jsonDictionary[@"place_id"] != [NSNull null]) {
        
        _placeID = _jsonDictionary[@"place_id"];
    }
}


//#pragma mark - Properties
//
//- (NSString *)name {
//
//    NSString* name = [NSString new];
//
//    if ([_jsonDictionary[@"terms"] objectAtIndex:0][@"value"] != [NSNull null]) {
//
//        name = [_jsonDictionary[@"terms"] objectAtIndex:0][@"value"];
//    }
//
//    return name;
//}
//
//- (NSString *)description {
//
//    NSString *description = [NSString new];
//
//    if (_jsonDictionary[@"description"] != [NSNull null]) {
//
//        description = _jsonDictionary[@"description"];
//    }
//    return description;
//}
//
//- (NSString *)placeID {
//
//    NSString *placeID = [NSString new];
//
//    if (_jsonDictionary[@"place_id"] != [NSNull null]) {
//
//        placeID = _jsonDictionary[@"place_id"];
//    }
//    return placeID;
//}

@end
