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

//#import <Foundation/Foundation.h>
//#import "StudentLifeBackgroundAudio.h"
//#import "StudentLifeBackgroundAudioRecorder.h"
//#import "EZMicrophone.h"
//#import <CoreAudio/CoreAudioTypes.h>

//extern EZMicrophone *ezMicrophone;

@interface SetupSensors : NSObject<EZMicrophoneDelegate, UIApplicationDelegate>

#pragma mark - Components
/**
 A signleton object of EZMicrophone
 The project only keeps one EZMicrophone object
 */
@property (strong, nonatomic) EZMicrophone *ezMicrophone;

/**
 EZAudioPlot for frequency plot
 */
@property (nonatomic,weak) IBOutlet EZAudioPlot *audioPlotFreq;

/**
 EZAudioPlot for time plot
 */
@property (nonatomic,weak) IBOutlet EZAudioPlotGL *audioPlotTime;


/**
 A signleton object of EZMicrophone
 The project only keeps one EZMicrophone object
 */
@property LocationTracker * locationTracker;
@property AudioProcessing *audioProcessing;
@property AccelerometerTracker *accelerometerTracker;
@property BluetoothTracker *bluetoothTracker;




+ (SetupSensors *)sharedSetupSensors;


@end
