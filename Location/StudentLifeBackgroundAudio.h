//
//  StudentLifeBackgroundAudio.h
//  AudioTest
//
//  Created by Aaron Jun Yang, MS in CS at Dartmouth College, on Feb 2, 2015
//  Part of the code was adopted from Thomas Zinnbauer's Githup open source repo
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

//extern AVAudioPlayer *audioPlayer;


@interface StudentLifeBackgroundAudio : NSObject<AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

// Public methods
- (void)initPlayer:(NSString*) audioFile fileExtension:(NSString*)fileExtension;
- (void)initPlayerWithUrl:(NSURL *)url error:(NSError *)outError;
- (void)setupAudioPlayer:(NSString*)fileName slider:(UISlider *)currentTimeslider timeElapsed: (UILabel *) timeEplapsed timeDuration: (UILabel *) timeDuration;
- (void)playAudio;
- (void)pauseAudio;
- (BOOL)isPlaying;
- (void)stopPlaying;
- (void)setCurrentAudioTime:(float)value;
- (float)getAudioDuration;

- (NSString*)timeFormat:(float)value;
- (NSTimeInterval)getCurrentAudioTime;

@property(assign) id<AVAudioPlayerDelegate> delegate; 


@end