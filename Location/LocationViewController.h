//
//  LocationViewController.h
//  Location
//
//  Copyright (c) 2014 Location. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

IBOutlet UIButton *recordPauseButton;
IBOutlet UIButton *stopButton;
IBOutlet UIButton *playButton;

extern AVAudioRecorder *recorder;
extern AVAudioPlayer *player;



@interface LocationViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>{
//     NSInteger LockComplete, LockState;
}




@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;




@property (strong, nonatomic) NSTimer *timer;

-(IBAction)recordPauseTapped:(id)sender;
-(IBAction)stopTapped:(id)sender;
-(IBAction)playTapped:(id)sender;



@end
