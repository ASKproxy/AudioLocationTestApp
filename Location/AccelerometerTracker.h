//
//  AccelerometerTracker.h
//  Location
//
//  Created by Arvind Chockalingam on 2/8/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "DataManager.h"

@interface AccelerometerTracker : NSObject

@property (strong,nonatomic) CMMotionManager * coreMotionManager;
@property (strong,nonatomic) DataManager * dataManager;

- (void)startAccelerometerTracking;

@end
