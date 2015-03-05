//
//  SetupTimers.h
//  Location
//
//  Created by Aaron Jun Yang on 3/5/15.
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
@property Indicators *indicators;

#pragma mark -
/**
 Class method to setup all signelton objects to setup timers
 */
+ (SetupTimers *)sharedSetupTimers;


@end
