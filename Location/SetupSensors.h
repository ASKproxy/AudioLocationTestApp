//
//  SetupSensors.h
//  Location
//
//  Created by Student student on 2/8/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "StudentLifeBackgroundAudio.h"
#import "StudentLifeBackgroundAudioRecorder.h"
#import "FormatFile.h"
#import "EZMicrophone.h"
#import "EZAudio.h"
#import <Accelerate/Accelerate.h>
#import "LocationTracker.h"
#import <Foundation/Foundation.h>

//extern EZMicrophone *ezMicrophone;

@interface SetupSensors : NSObject<EZMicrophoneDelegate>

@property (strong, nonatomic) EZMicrophone *ezMicrophone;
@property LocationTracker * locationTracker;


+ (SetupSensors *)setup;

@end
