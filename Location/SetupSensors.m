//
//  SetupSensors.m
//  Location
//
//  Created by Student student on 2/8/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "SetupSensors.h"

@implementation SetupSensors


-(id)init {
    self = [super init];
    return self;
}

+ (SetupSensors *)setup{
    static SetupSensors *_setupSensors = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _setupSensors = [[SetupSensors alloc] init];
    });

    [_setupSensors setupAudioMicrophone];
    [_setupSensors setupLocationGPS];
    
    return _setupSensors;
}


#pragma mark - Setup Audio
- (void)setupAudioMicrophone{
    self.ezMicrophone = [EZMicrophone sharedMicrophone];
    [self.ezMicrophone initWithMicrophoneDelegate:self startsImmediately:NO];
    
    NSLog(@"******************Microphone is %i*******************", self.ezMicrophone.microphoneOn);
}


#pragma mark - Setup LocationGPS
- (void)setupLocationGPS{
    self.locationTracker = [[LocationTracker alloc]init];
    [self.locationTracker startLocationTracking];
}

@end
