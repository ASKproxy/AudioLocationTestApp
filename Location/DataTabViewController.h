//
//  DataTabViewController.h
//  StudentLife
//
//  Created by Aaron Jun Yang on 2/11/15.
//  Copyright (c) 2015 Location. All rights reserved.
//
//  The DataTabViewController is the tab bar view which contains four sub tab showing Stress, Sleep, Social, and Activity. It is the landing view of the app, and it also sets up sensor instances including GPS, Bluetooth, Microphone,Accelerameter, and other house keeping instances including Lock&Unlock state, database, server,and PAM study. It automatically starts all event in the background once the app is launched. The app continuously senses in the background and check each instance every certain time period. For audio input, the App does the realtime processing and only store the classifier results with are integer values. Every time when the user charges the phone, it pushes all the data to the cloud.

#import <UIKit/UIKit.h>
#import "FormatFile.h"
#import "EZAudio.h"
#import <Accelerate/Accelerate.h>
#import "SetupSensors.h"

@interface DataTabViewController : UITabBarController<EZMicrophoneDelegate>

#pragma mark - Components
/**
 EZAudioPlot for frequency plot
 */
//@property (nonatomic,weak) IBOutlet EZAudioPlot *audioPlotFreq;
@property (weak, nonatomic) IBOutlet EZAudioPlot *audioPlotFreq;

/**
 EZAudioPlot for time plot
 */
//@property (nonatomic,weak) IBOutlet EZAudioPlotGL *audioPlotTime;
@property (weak, nonatomic) IBOutlet EZAudioPlotGL *audioPlotTime;

/**
 Microphone
 */
@property (nonatomic,strong) EZMicrophone *microphone;

/**
 SetupSensors
 */
@property (strong, nonatomic) SetupSensors *setupSensors;
@end
