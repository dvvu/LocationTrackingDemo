//
//  CompoboxDelegate.h
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/11/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#ifndef CompoboxDelegate_h
#define CompoboxDelegate_h


#endif /* CompoboxDelegate_h */
#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol CompoboxCustomViewDelegate <NSObject>

#pragma mark - tapOnCompoboxCustomView
- (void)tapOnCompoboxCustomView:(CompoboxType)type;

@end
