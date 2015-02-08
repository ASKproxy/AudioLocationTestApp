//
//  LocationViewController.h
//  Location
//
//  Copyright (c) 2014 Location. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "StudentLifeBackgroundAudio.h"
#import "StudentLifeBackgroundAudioRecorder.h"
#import "FormatFile.h"
#import "EZMicrophone.h"
#import "EZAudio.h"
#import <Accelerate/Accelerate.h>

extern StudentLifeBackgroundAudio *audioPlayer;
extern StudentLifeBackgroundAudioRecorder *audioRecorder;
extern EZMicrophone *ezMicrophone;

@interface LocationViewController : UIViewController <EZMicrophoneDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsed;
@property (weak, nonatomic) IBOutlet UISlider *currentTimeslider;

@property (strong, nonatomic) NSArray *pathComponents;
@property (strong, nonatomic) NSURL *outputFileURL;
@property (strong, nonatomic) NSMutableDictionary *recordSetting;

//@property (nonatomic,strong) EZMicrophone *ezMicrophone;


@property BOOL isPaused;
@property BOOL scrubbing;

@property (strong, nonatomic) NSTimer *timer;

-(IBAction)recordPauseTapped:(id)sender;
-(IBAction)stopTapped:(id)sender;
-(IBAction)playTapped:(id)sender;


@end
