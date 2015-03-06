//
//  Indicators.m
//  Location
//
//  Created by Aaron Jun Yang on 3/3/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "Indicators.h"

@implementation Indicators
@synthesize stressLevel = _stressLevel;
@synthesize sleepLevel = _sleepLevel;
@synthesize socialLevel = _socialLevel;
@synthesize activityLevel = _activityLevel;
@synthesize screenHeight = _screenHeight;
@synthesize screenWidth = _screenWidth;
@synthesize campusActivity = _campusActivity;
@synthesize campusSleep = _campusSleep;
@synthesize campusSocial = _campusSocial;
@synthesize campusStress = _campusStress;

#pragma mark - Init
+ (Indicators*)sharedInstance {
    static dispatch_once_t pred;
    static Indicators *sharedInstance = nil;
    
    dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

-(id)init{
    if (self = [super init]) {
        
        _activityLevel = [NSNumber numberWithInt:0];
        _sleepLevel = [NSNumber numberWithInt:0];
        _socialLevel = [NSNumber numberWithInt:0];
        _stressLevel = [NSNumber numberWithInt:0];
        
        _campusStress = [NSNumber numberWithInt:0];
        _campusSleep = [NSNumber numberWithInt:0];
        _campusSocial = [NSNumber numberWithInt:0];
        _campusActivity = [NSNumber numberWithInt:0];
        
        
        self.screenRect = [[UIScreen mainScreen] bounds];
        self.screenWidth = self.screenRect.size.width;
        self.screenHeight = self.screenRect.size.height;
        
        NSLog(@"initializing the Indicators");
    }
    return self;
}


#pragma mark - Getter and Setter


-(CGFloat) getScreenWidth{
    return _screenWidth;
}

-(void) setScreenWidth:(CGFloat)screenWidth{
    _screenWidth = screenWidth;
}

-(CGFloat) getScreenHeight{
    return _screenHeight;
}

-(void) setScreenHeight:(CGFloat)screenHeight{
    _screenHeight = screenHeight;
}


-(NSInteger ) getStressLevel
{
    NSInteger result = [_stressLevel integerValue];
    return result;
}


-(void) setStressLevel:(NSNumber *)stressLevel{
    _stressLevel = stressLevel;
}


-(NSInteger) getSleepLevel
{
    NSInteger result = [_sleepLevel integerValue];
    return result;
}

-(void) setSleepLevel:(NSNumber *)sleepLevel{
    _sleepLevel = sleepLevel;
}

-(NSInteger) getSocialLevel
{
    NSInteger result = [_socialLevel integerValue];
    return result;
}

-(void) setSocialLevel:(NSNumber *)socialLevel{
    _socialLevel = socialLevel;
}

-(NSInteger) getActivityLevel
{
    NSInteger result = [_activityLevel integerValue];
    return result;
}

-(void) setActivityLevel:(NSNumber *)activityLevel{
    _activityLevel = activityLevel;
}


-(NSInteger) getCampusActivity{
    NSInteger result = [_campusActivity integerValue];
    return result;
}

-(void) setCampusActivity:(NSNumber *)campusActivity{
    _campusActivity = campusActivity;
}


-(NSInteger) getCampusSleep{
    NSInteger result = [_campusSleep integerValue];
    return result;
}

-(void) setCampusSleep:(NSNumber *)campusSleep{
    _campusSleep = campusSleep;
}


-(NSInteger) getCampusSocial{
    NSInteger result = [_campusSocial integerValue];
    return result;
}

-(void) setCampusSocial:(NSNumber *)campusSocial{
    _campusSocial = campusSocial;
}

-(NSInteger) getCampusStress{
    NSInteger result = [_campusStress integerValue];
    return result;
}

-(void) setCampusStress:(NSNumber *)campusStress{
    _campusStress = campusStress;
}


@end
