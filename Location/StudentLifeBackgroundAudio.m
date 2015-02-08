//
//  StudentLifeBackgroundAudio.m
//  AudioTest
//
//  Created by Aaron Jun Yang, MS in CS at Dartmouth College, on Feb 2, 2015
//  Part of the code was adopted from Thomas Zinnbauer's Githup open source repo
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "StudentLifeBackgroundAudio.h"


@implementation StudentLifeBackgroundAudio

/*
 * Init the Player with Filename and FileExtension
 */
- (void)initPlayer:(NSString*) audioFile fileExtension:(NSString*)fileExtension
{
    NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:audioFile withExtension:fileExtension];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
//    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];

}

/*
 * Init the Player with Filename and FileExtension
 */
- (void)initPlayerWithUrl:(NSURL *)url error:(NSError *)outError
{
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&outError];
//    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:outError];

}

/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
- (void)setupAudioPlayer:(NSString*)fileName slider:(UISlider *)currentTimeslider timeElapsed: (UILabel *) timeEplapsed timeDuration: (UILabel *) timeDuration
{
    //insert Filename & FileExtension
    NSString *fileExtension = @"mp3";
    
    //init the Player to get file properties to set the time labels
    [self initPlayer:fileName fileExtension:fileExtension];
    //    self.audioPlayer = [[StudentLifeBackgroundAudio alloc] init];
    //    [self.audioPlayer initPlayerWithUrl:recorder.url error:nil];
    currentTimeslider.maximumValue = [self getAudioDuration];
    
    //init the current timedisplay and the labels. if a current time was stored
    //for this player then take it and update the time display
    timeEplapsed.text = @"00:00:00";
    
    timeDuration.text = [NSString stringWithFormat:@"-%@",
                          [self timeFormat:[self getAudioDuration]]];
    
}

/*
 * Simply fire the play Event
 */
- (void)playAudio {
    [self.audioPlayer setDelegate:self];
    [self.audioPlayer play];
//    [audioPlayer setDelegate:self];
//    [audioPlayer play];

}

/*
 * Simply fire the pause Event
 */
- (void)pauseAudio {
    [self.audioPlayer pause];
//    [audioPlayer pause];

}

- (void)stopPlaying {
    [self.audioPlayer stop];
}

/*
 * get playingState
 */
- (BOOL)isPlaying {
    return [self.audioPlayer isPlaying];
}

/*
 * Format the float time values like duration
 * to format with minutes and seconds
 */
-(NSString*)timeFormat:(float)value{
    
    float hours = floor(lroundf(value)/3600);
    float minutes = floor((lroundf(value) - hours * 3600)/60); //floor(lroundf(value)/60);
    float seconds = lroundf(value) - (hours * 3600) - (minutes * 60);
    
    int roundedHours = lroundf(hours);
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%02d:%02d:%02d", roundedHours,
                      roundedMinutes, roundedSeconds];
    return time;
}

/*
 * To set the current Position of the
 * playing audio File
 */
- (void)setCurrentAudioTime:(float)value {
    [self.audioPlayer setCurrentTime:value];
//    [audioPlayer setCurrentTime:value];

}

/*
 * Get the time where audio is playing right now
 */
- (NSTimeInterval)getCurrentAudioTime {
    return [self.audioPlayer currentTime];
//    return [audioPlayer currentTime];

}

/*
 * Get the whole length of the audio file
 */
- (float)getAudioDuration {
    return [self.audioPlayer duration];
//    return [audioPlayer duration];

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


@end
