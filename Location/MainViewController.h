//
//  MainViewController.h
//  StudentLife
//
//  Created by Aaron Jun Yang
//  Copyright (c) 2014 Location. All rights reserved.
//
//  The MainViewController sets up sensor instances including GPS, Bluetooth, Microphone,
//  Accelerameter, and other house keeping instances including Lock&Unlock state, database, server,
//  and PAM study. It automatically starts all event in the background once the app is launched. The
//  app continuously senses in the background and check each instance every certain time period. For
//  audio input, the App does the realtime processing and only store the classifier results with are
//  integer values. Every time when the user charges the phone, it pushes all the data to the cloud.




#import <UIKit/UIKit.h>
#import "FormatFile.h"
#import "EZAudio.h"
#import <Accelerate/Accelerate.h>
#import "SetupSensors.h"

//#import <CoreAudio/CoreAudioTypes.h>
//#import "StudentLifeBackgroundAudio.h"
//#import "StudentLifeBackgroundAudioRecorder.h"
//#import "EZMicrophone.h"


/**
 The FFTViewController demonstrates how to use the Accelerate framework to calculate the real-time FFT of audio data provided by an EZAudioMicrophone.
 */
@interface MainViewController : UIViewController <EZMicrophoneDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>

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



//#pragma mark - Property
//
//@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
//@property (weak, nonatomic) IBOutlet UIButton *stopButton;
//@property (weak, nonatomic) IBOutlet UIButton *playButton;
//@property (weak, nonatomic) IBOutlet UILabel *duration;
//@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;
//@property (weak, nonatomic) IBOutlet UISlider *currentTimeslider;
//
//@property (strong, nonatomic) NSArray *pathComponents;
//@property (strong, nonatomic) NSURL *outputFileURL;
//@property (strong, nonatomic) NSMutableDictionary *recordSetting;
//
//@property (nonatomic,strong) EZMicrophone *ezMicrophone;
//
//
//@property BOOL isPaused;
//@property BOOL scrubbing;
//
//@property (strong, nonatomic) NSTimer *timer;
//
//
//#pragma mark - Audio
//
//-(IBAction)recordPauseTapped:(id)sender;
//-(IBAction)stopTapped:(id)sender;
//-(IBAction)playTapped:(id)sender;
//
//#pragma mark - GPS
//
//#pragma mark - Bluetooth
//
//#pragma mark - Accelerameter
//
//#pragma mark - Lock & Unlock
//
//#pragma mark - Pam
//
//#pragma mark - Database
//
//#pragma mark - Server

@end
