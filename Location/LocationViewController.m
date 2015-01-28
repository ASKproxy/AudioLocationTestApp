//
//  LocationViewController.m
//  Location
//
//  Copyright (c) 2014 Location. All rights reserved.
//


#import "LocationViewController.h"

AVAudioRecorder *recorder;
AVAudioPlayer *player;
//NSTimer *timer;

//NSInteger LockComplete, LockState;

@implementation LocationViewController
@synthesize stopButton, playButton, recordPauseButton;


AVAudioSession *session;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Disable Stop/Play button when application launches
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    //AVAudioSession *session = [AVAudioSession sharedInstance];
    session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    NSLog(@"ViewDidLoad called! @LocationViewController");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
    NSLog(@"🔕audioRecorderDidFinishRecording called!🔕");
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"audioPlayerDidFinishPlaying called!");
}

- (IBAction)recordPauseTapped:(id)sender {
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [recorder pause];
        [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
 
    
    NSLog(@"recordPauseTapped called! =%@", sender);
}

- (IBAction)stopTapped:(id)sender {
    [recorder stop];//System will call audioRecorderDidFinishRecording method
    
    //AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //[audioSession setActive:NO error:nil];
    [session setActive:NO error:nil];
    NSLog(@"stopTapped called! =%@", sender);
}

- (IBAction)playTapped:(id)sender {
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
        
        
        NSLog(@"playTapped called! =%@", sender);
        //Once finished playing, system will call audioPlayerDidFinishPlaying method
    }
}



@end
