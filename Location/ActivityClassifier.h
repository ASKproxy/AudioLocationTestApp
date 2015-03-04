//
//  ActivityClassifier.h
//  Location
//
//  Created by Arvind Chockalingam on 3/1/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "DataManager.h"


@interface ActivityClassifier : NSObject

@property (strong, nonatomic) CMMotionActivityManager *activitymanager;
@property (strong,nonatomic) DataManager * dataManager;

@property (strong, nonatomic) NSMutableDictionary *previousActivity;

+(ActivityClassifier *) setup;
-(void)getTrackingAcitivity;



@end
