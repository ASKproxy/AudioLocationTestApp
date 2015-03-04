//
//  Indicators.h
//  Location
//
//  Created by Arvind Chockalingam on 3/3/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Indicators : NSObject

@property NSNumber *activityLevel;
@property NSNumber *sleepLevel;
@property NSNumber *socialLevel;
@property NSNumber *stressLevel;

+ (Indicators*)sharedInstance;


@end
