//
//  SetupTimers.h
//  Location
//
//  Created by Student student on 3/5/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "ActivityClassifier.h"
#import "StudentLifeConstant.h"
#import "Indicators.h"


@interface SetupTimers : NSObject


#pragma mark - Property
@property ActivityClassifier *activityTracker;

@property DataManager *dataManager;


#pragma mark -
/**
 Class method to setup all signelton objects to setup timers
 */
+ (SetupTimers *)sharedSetupTimers;


@end
