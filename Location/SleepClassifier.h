//
//  SleepClassifier.h
//  Location
//
//  Created by Student student on 3/5/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "StudentLifeConstant.h"
#import "Indicators.h"

@interface SleepClassifier : NSObject

#pragma mark - Property
@property (strong,nonatomic) DataManager * dataManager;
@property Indicators *indicators;


#pragma mark - Shared Instance;
+(SleepClassifier *) sharedSleepClassifier;

-(int) checkLockRecords:(NSDate *)startInterval upUntil:(NSDate *)endInterval inTimeInterval:(int)intervalCounter;

@end
