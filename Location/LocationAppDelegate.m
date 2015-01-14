//
//  LocationAppDelegate.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import "LocationAppDelegate.h"
#import "LocationViewController.h"

//AVAudioRecorder *recorder;
//AVAudioPlayer *player;
//AVQueuePlayer *_player;

@implementation LocationAppDelegate


@synthesize gLockComplete, gLockState;

// Call back function to print log for lock event
static void displayStatusChanged(CFNotificationCenterRef center,
                                 void *observer,
                                 CFStringRef name,
                                 const void *object,
                                 CFDictionaryRef userInfo) {
    
    
    // Lock state change
    //"com.apple.springboard.lockcomplete" notification will always come after the "com.apple.springboard.lockstate"
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisplayStatusLocked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"event received! loctStateChanged = %@", name);
    // you might try inspecting the `userInfo` dictionary, to see
    //  if it contains any useful info
    
    // Increment the corresponding state variables everytime receving a new notification
    if(name== CFSTR("com.apple.springboard.lockstate")){
        gLockState = 1;
        NSLog(@"LockState: %i", gLockState);
        
    }else if(name== CFSTR("com.apple.springboard.lockcomplete")){
        gLockComplete = 1;
        NSLog(@"LockComplete: %i", gLockComplete);
    }
    
    // Decide recording or stop recording
    if(gLockComplete && gLockState){
        NSLog(@"Start recording!");
        
        // Start recording
        AVAudioSession *callBackSession = [AVAudioSession sharedInstance];
        [callBackSession setActive:YES error:nil];
        
//        // Set the audio file
//        NSArray *pathComponents = [NSArray arrayWithObjects:
//                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                                   @"MyAudioMemo.m4a",
//                                   nil];
//        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
//        
//        // Setup audio session
//        AVAudioSession *session = [AVAudioSession sharedInstance];
//        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//        
//        // Define the recorder setting
//        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
//        
//        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
//        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
//        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
//        
//        // Initiate and prepare the recorder
//        recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
//        recorder.meteringEnabled = YES;
//        [recorder prepareToRecord];

        [recorder record];
        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [stopButton setEnabled:YES];
        
        NSLog(@"playButton label status: %@", recordPauseButton.titleLabel);
        NSLog(@"Started recording after lock the phone");
        
        NSLog(@"LockState: %i, LockComplete: %i", gLockState, gLockComplete);
        if(recorder.recording){
            NSLog(@"***************************It's recording!");
            
        }else{
            NSLog(@"*************************It's not recording!");
        }

        // Restore states value
        gLockComplete = 0;
        gLockState = 0;
        
    }else if(!gLockComplete && gLockState){
        
        if(recorder.recording){
            NSLog(@"***************************It's recording!");
        }else{
            NSLog(@"*************************It's not recording!");
        }
        NSLog(@"Stop recording!");
        
        sleep(2);
        //Stop recording
        [recorder stop];//System will call audioRecorderDidFinishRecording method
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
        NSLog(@"LockState: %i, LockComplete: %i", gLockState, gLockComplete);
        // Restore states value
        gLockState = 0;
        
        //        [player play];
        //        [self playSoundFile];
        
    }
    
    
    if (userInfo != nil) {
        CFShow(userInfo);
    }
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    self.locationTracker = [[LocationTracker alloc]init];
    [self.locationTracker startLocationTracking];
    
    
    // Add lockstate notification observer
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    displayStatusChanged,
                                    CFSTR("com.apple.springboard.lockstate"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    // Add lockcomplete notification observer
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    displayStatusChanged,
                                    CFSTR("com.apple.springboard.lockcomplete"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisplayStatusLocked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"application has become active again!! @didFinishLaunchingWithOptions");
    
    gLockComplete = 0;
    gLockState=0;
    
    //    NSLog(@"Initial states: LockComplete: %li, LockState: %li", (long)gLockComplete, (long)gLockState);
    
    return YES;

}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    
    NSLog(@"locked! @applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateInactive) {
        NSLog(@"Sent to background by locking screen");
    } else if (state == UIApplicationStateBackground) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"kDisplayStatusLocked"]) {
            NSLog(@"Sent to background by home button/switching to other app! @applicationDidEnterBackground");
        } else {
            NSLog(@"Sent to background by locking screen while \t state == UIApplicationStateBackground! @applicationDidEnterBackground ");
        }
    }
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisplayStatusLocked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"\n application has entered foreground again! @pplicationWillEnterForeground");
    

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"application has become active again!! @applicationDidBecomeActive");
    

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"application will terminate! @applicationWillTerminate:");
}

- (void)playSoundFile {
    
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player play];
        
        //Once finished playing, system will call audioPlayerDidFinishPlaying method
    }
    
    NSLog(@"playing got called!");
}

@end
