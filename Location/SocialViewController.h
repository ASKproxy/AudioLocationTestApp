//
//  SocialViewController.h
//  Location
//
//  Created by Student student on 2/17/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTracker.h"
#import "JBBaseChartViewController.h"
#import "StudentLifeConstant.h"


#pragma mark - EZMicrophoneDelegate
/**
 The delegate for the EZMicrophone provides a receiver for the incoming audio data events. When the microphone has been successfully internally configured it will try to send its delegate an AudioStreamBasicDescription describing the format of the incoming audio data.
 
 The audio data itself is sent back to the delegate in various forms:
 
 -`microphone:hasAudioReceived:withBufferSize:withNumberOfChannels:`
 Provides float arrays instead of the AudioBufferList structure to hold the audio data. There could be a number of float arrays depending on the number of channels (see the function description below). These are useful for doing any visualizations that would like to make use of the raw audio data.
 
 -`microphone:hasBufferList:withBufferSize:withNumberOfChannels:`
 Provides the AudioBufferList structures holding the audio data. These are the native structures Core Audio uses to hold the buffer information and useful for piping out directly to an output (see EZOutput).
 
 */
//@protocol SocialDelegate <NSObject>
//
//@optional
//
/////-----------------------------------------------------------
///// @name Social - Location Data Callbacks
/////-----------------------------------------------------------
//
///**
// Returns back a float array of the audio received. This occurs on the background thread so any drawing code must explicity perform its functions on the main thread.
// @param microphone       The instance of the EZMicrophone that triggered the event.
// @param buffer           The audio data as an array of float arrays. In a stereo signal buffer[0] represents the left channel while buffer[1] would represent the right channel.
// @param bufferSize       The size of each of the buffers (the length of each float array).
// @param numberOfChannels The number of channels for the incoming audio.
// @warning This function executes on a background thread to avoid blocking any audio operations. If operations should be performed on any other thread (like the main thread) it should be performed within a dispatch block like so: dispatch_async(dispatch_get_main_queue(), ^{ ...Your Code... })
// */
//-(void)    microphone:(EZMicrophone*)microphone
//     hasAudioReceived:(float**)buffer
//       withBufferSize:(UInt32)bufferSize
// withNumberOfChannels:(UInt32)numberOfChannels;
//
///**
// Returns back the buffer list containing the audio received. This occurs on the background thread so any drawing code must explicity perform its functions on the main thread.
// @param microphone       The instance of the EZMicrophone that triggered the event.
// @param bufferList       The AudioBufferList holding the audio data.
// @param bufferSize       The size of each of the buffers of the AudioBufferList.
// @param numberOfChannels The number of channels for the incoming audio.
// @warning This function executes on a background thread to avoid blocking any audio operations. If operations should be performed on any other thread (like the main thread) it should be performed within a dispatch block like so: dispatch_async(dispatch_get_main_queue(), ^{ ...Your Code... })
// */
//-(void)    microphone:(EZMicrophone*)microphone
//        hasBufferList:(AudioBufferList*)bufferList
//       withBufferSize:(UInt32)bufferSize
// withNumberOfChannels:(UInt32)numberOfChannels;
//
//@end
//


@interface SocialViewController : JBBaseChartViewController
@property (strong, nonatomic) IBOutlet UILabel *GPSLat;
@property (strong, nonatomic) IBOutlet UILabel *GPSLon;

@end
