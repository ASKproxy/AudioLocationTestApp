//
//  StudentLifeBackgroundAudioRecorder.m
//  AudioTest
//
//  Created by Aaron Jun Yang, MS in CS at Dartmouth College, on Feb 2, 2015
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "StudentLifeBackgroundAudioRecorder.h"

@implementation StudentLifeBackgroundAudioRecorder


/*
 * Setup the AudioRecorder
 * including pathComponents, url, audio session, and basic settings
 */
- (void)setupAudioRecorder{
    // Set the audio file
    self.pathComponents = [NSArray arrayWithObjects:
                           [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                           @"MyAudioMemo.m4a",
                           nil];
    self.outputFileURL = [NSURL fileURLWithPathComponents:self.pathComponents];
    
    // Setup audio session
    self.session = [AVAudioSession sharedInstance];
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    // Define the recorder setting
    self.recordSetting = [[NSMutableDictionary alloc] init];
    
    [self.recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [self.recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [self.recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.outputFileURL settings:self.recordSetting error:NULL];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}

/*
 * Simply check the status of recorder
 * return TRUE is it's recording, FALSE if not
 */
- (BOOL)isRecording{
    return [self.recorder isRecording];
}

/*
 * Pause recording
 */
- (void)pause{
    [self.recorder pause];
}

/*
 * Stop recording
 */
- (void)stop{
    [self.recorder stop];
    [self.session setActive:NO error:nil];
}


/*
 * Start recording
 */
- (BOOL)record{
    [self.session setActive:YES error:nil];
    return [self.recorder record];
}

/*
 * Return the audio url for playing
 */
- (NSURL *)getUrl{
    return self.outputFileURL;
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
      NSLog(@"🔕audioRecorderDidFinishRecording called!🔕");
}

@end
