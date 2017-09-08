//
//  SearchResultEntity.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/7/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultEntity : NSObject

@property (nonatomic) NSString* placeName;

#pragma mark - initWithJSONData
- (instancetype)initWithJSONData:(NSDictionary *)jsonDictionary;

@end
