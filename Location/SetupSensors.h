//  SetupSensors.h
//  StudentLife
//
//  Created by Aaron Jun Yang on 2/8/15.
//  Copyright (c) 2015 Location. All rights reserved.
//
//  This class setup passive sensors and is called in
//  the AppDelegate during the period when the app is
//  launched. It will be called only once, and setup
//  singleton object for each sensor.

#import <UIKit/UIKit.h>
#import "FormatFile.h"
#import "EZAudio.h"
#import <Accelerate/Accelerate.h>
#import "LocationTracker.h"
#import "AudioProcessing.h"
#import "AccelerometerTracker.h"
#import "BluetoothTracker.h"

@interface SetupSensors : NSObject<EZMicrophoneDelegate, UIApplicationDelegate>

#pragma mark - Properties
/**
 A signleton object of EZMicrophone
 The project only keeps one EZMicrophone object
 */
@property (strong, nonatomic) EZMicrophone *ezMicrophone;

/**
 A signleton object of LocationTracker
 The project only keeps one LocationTracker object
 */
@property LocationTracker * locationTracker;

/**
 A signleton object of AudioProcessing classifier which
 continuously infer the audio class in the background
 0: no conversation. 1: conversation. 2: noise
 The project only keeps one AudioProcessing object
 */

@property (strong, nonatomic)AudioProcessing *audioProcessing;

/**
 A signleton object of AccelerometerTracker
 The project only keeps one AccelerometerTracker object
 */

@property AccelerometerTracker *accelerometerTracker;

/**
 A signleton object of BluetoothTracker
 The project only keeps one BluetoothTracker object
 */
@property BluetoothTracker *bluetoothTracker;


#pragma mark -
/**
 Class method to setup all signelton objects to perform
 background sensing
 */
+ (SetupSensors *)sharedSetupSensors;


@end
