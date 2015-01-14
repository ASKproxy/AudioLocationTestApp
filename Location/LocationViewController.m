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
    AVAudioSession *session = [AVAudioSession sharedInstance];
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
    
//    
//        // Add lockstate notification observer
//        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
//                                        NULL,
//                                        displayStatusChanged,
//                                        CFSTR("com.apple.springboard.lockstate"),
//                                        NULL,
//                                        CFNotificationSuspensionBehaviorDeliverImmediately);
//    
//        // Add lockcomplete notification observer
//        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
//                                        NULL,
//                                        displayStatusChanged,
//                                        CFSTR("com.apple.springboard.lockcomplete"),
//                                        NULL,
//                                        CFNotificationSuspensionBehaviorDeliverImmediately);
//
//    
//    LockComplete = 0;
//    LockState=0;
    NSLog(@"ViewDidLoad called!");
}



//
////Call back function to print log for lock event
//static void displayStatusChanged(CFNotificationCenterRef center,
//                                 void *observer,
//                                 CFStringRef name,
//                                 const void *object,
//                                 CFDictionaryRef userInfo) {
//
//    // Lock state change
//    //"com.apple.springboard.lockcomplete" notification will always come after the "com.apple.springboard.lockstate"
//    
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisplayStatusLocked"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSLog(@"event received! loctStateChanged = %@", name);
//    // you might try inspecting the `userInfo` dictionary, to see
//    //  if it contains any useful info
//    
//    // Increment the corresponding state variables everytime receving a new notification
//    if(name== CFSTR("com.apple.springboard.lockstate")){
//        LockState = 1;
//        NSLog(@"LockState: %i", LockState);
//        
//    }else if(name== CFSTR("com.apple.springboard.lockcomplete")){
//        LockComplete = 1;
//        NSLog(@"LockComplete: %i", LockComplete);
//    }
//    
//    // Decide recording or stop recording
//    if(LockComplete && LockState){
//        NSLog(@"Start recording!");
//        
//        // Start recording
//        AVAudioSession *callBackSession = [AVAudioSession sharedInstance];
//        [callBackSession setActive:YES error:nil];
//        
//        //        // Set the audio file
//        //        NSArray *pathComponents = [NSArray arrayWithObjects:
//        //                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//        //                                   @"MyAudioMemo.m4a",
//        //                                   nil];
//        //        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
//        //
//        //        // Setup audio session
//        //        AVAudioSession *session = [AVAudioSession sharedInstance];
//        //        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//        //
//        //        // Define the recorder setting
//        //        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
//        //
//        //        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
//        //        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
//        //        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
//        //
//        //        // Initiate and prepare the recorder
//        //        recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
//        //        recorder.meteringEnabled = YES;
//        //        [recorder prepareToRecord];
//        
//        [recorder record];
//        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
//        [stopButton setEnabled:YES];
//        
//        NSLog(@"playButton label status: %@", recordPauseButton.titleLabel);
//        NSLog(@"Started recording after lock the phone");
//        
//        NSLog(@"LockState: %i, LockComplete: %i", LockState, LockComplete);
//        if(recorder.recording){
//            NSLog(@"***************************It's recording!");
//            
//        }else{
//            NSLog(@"*************************It's not recording!");
//        }
//        
//        // Restore states value
//        LockComplete = 0;
//        LockState = 0;
//        
//    }else if(!LockComplete && LockState){
//        
//        if(recorder.recording){
//            NSLog(@"***************************It's recording!");
//        }else{
//            NSLog(@"*************************It's not recording!");
//        }
//        NSLog(@"Stop recording!");
//        
//        sleep(2);
//        //Stop recording
//        [recorder stop];//System will call audioRecorderDidFinishRecording method
//        
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        [audioSession setActive:NO error:nil];
//        
//        NSLog(@"LockState: %i, LockComplete: %i", LockState, LockComplete);
//        // Restore states value
//        LockState = 0;
//        
//        //        [player play];
//        //        [self playSoundFile];
//        
//    }
//    
//    
//    if (userInfo != nil) {
//        CFShow(userInfo);
//    }
//    
//}
//
//

// Call back function to print log for lock event
-(void) displayStatusChanged:(CFNotificationCenterRef)center withobserver:(void *)observer withname:(CFStringRef)name withobject:(const void *)object withuserinfor:(CFDictionaryRef)userInfo{
    // Lock state change
    if(name==CFSTR("com.apple.springboard.lockstate")){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisplayStatusLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"event received! @lockState");
        // Start recording

        [recorder record];
        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];

        // you might try inspecting the `userInfo` dictionary, to see
        //  if it contains any useful info
        if (userInfo != nil) {
            CFShow(userInfo);
        }
    }


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
    NSLog(@"audioRecorderDidFinishRecording called!");
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
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
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
