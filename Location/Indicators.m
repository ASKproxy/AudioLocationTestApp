//
//  Indicators.m
//  Location
//
//  Created by Arvind Chockalingam on 3/3/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "Indicators.h"

@implementation Indicators



+ (Indicators*)sharedInstance {
    static dispatch_once_t pred;
    static Indicators *sharedInstance = nil;
    
    dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

-(id)init{
    if (self = [super init]) {
        
        self.activityLevel=[NSNumber numberWithInt:0];
        self.sleepLevel=[NSNumber numberWithInt:0];
        self.socialLevel=[NSNumber numberWithInt:0];
        self.stressLevel=[NSNumber numberWithInt:0];
        NSLog(@"initializing the Indicators");
    }
    return self;
}


-(NSNumber *) getStressLevel
{
    return self.stressLevel;
}


-(NSNumber *) getSleepLevel
{
    return self.sleepLevel;
}


-(NSNumber *) getSocialLevel
{
    return self.socialLevel;
}


-(NSNumber *) getActivityLevel
{
    return self.activityLevel;
}

@end
