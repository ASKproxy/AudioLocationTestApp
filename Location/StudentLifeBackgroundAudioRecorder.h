//
//  StudentLifeBackgroundAudioRecorder.h
//  AudioTest
//
//  Created by Aaron Jun Yang, MS in CS at Dartmouth College, on Feb 2, 2015
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <CoreAudio/CoreAudioTypes.h>


@interface StudentLifeBackgroundAudioRecorder : NSObject <AVAudioRecorderDelegate>

@property (strong, nonatomic) AVAudioRecorder *recorder;

@property (strong, nonatomic) NSArray *pathComponents;
@property (strong, nonatomic) NSURL *outputFileURL;
@property (strong, nonatomic) NSMutableDictionary *recordSetting;
@property (strong, nonatomic) AVAudioSession *session;
@property (readonly) NSURL *url;

- (void)setupAudioRecorder;
- (BOOL)isRecording;
- (NSURL *)getUrl;
- (void)pause;
- (void)stop;
- (BOOL)record;

    
@end
