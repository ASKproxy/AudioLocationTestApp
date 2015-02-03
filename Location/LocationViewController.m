//
//  LocationViewController.m
//  Location
//
//  Copyright (c) 2014 Location. All rights reserved.
//


#import "LocationViewController.h"

StudentLifeBackgroundAudio *audioPlayer;
StudentLifeBackgroundAudioRecorder *audioRecorder;

@interface LocationViewController ()

@end


@implementation LocationViewController


AVAudioSession *session;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Disable Stop/Play button when application launches
    [self.stopButton setEnabled:YES];
    [self.playButton setEnabled:YES];
    
    audioPlayer = [[StudentLifeBackgroundAudio alloc] init];
    
    // Setup recorder
    audioRecorder = [[StudentLifeBackgroundAudioRecorder alloc]init];
    [audioRecorder setupAudioSettings];
    [audioRecorder setupAudioRecorder];
    
    NSLog(@"ViewDidLoad called! @LocationViewController");
    
}


/*
 * Hide the statusbar
 */
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
- (void)setupAudioPlayer
{
    [audioPlayer initPlayerWithUrl:[audioRecorder getUrl] error:nil];
    //init the Player to get file properties to set the time labels
    self.currentTimeslider.maximumValue = [audioPlayer getAudioDuration];
    
    //init the current timedisplay and the labels. if a current time was stored
    //for this player then take it and update the time display
    self.timeElapsed.text = @"0:00";
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [FormatFile timeFormat:[audioPlayer getAudioDuration]]];
    
    
}


/*
 * RecordButton is pressed
 * record or pauses the recorder and sets
 * the record/pause Text of the Button
 */
- (IBAction)recordPauseTapped:(id)sender {
    // Stop the audio player before recording
    if ([audioPlayer isPlaying]) {
        [audioPlayer stopPlaying];
    }
    
    if (![audioRecorder isRecording]) {
        
        // Start recording
        [audioRecorder record];
        [self.recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [audioRecorder pause];
        [self.recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [self.stopButton setEnabled:YES];
    [self.playButton setEnabled:NO];
    
    
    NSLog(@"recordPauseTapped called! =%@", sender);
}



/*
 * StopButton is pressed
 * stop recording audio
 */
- (IBAction)stopTapped:(id)sender {
    [audioRecorder stop];
    NSLog(@"stopTapped called! =%@", sender);

    [self.playButton setEnabled:YES];
}


/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */
- (IBAction)playTapped:(id)sender {
    
    [self.timer invalidate];
   
//    if (!recorder.recording){
    if (![audioRecorder isRecording]){
        if (!self.isPaused) {
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_pause.png"]
                                       forState:UIControlStateNormal];
            
            //start a timer to update the time label display
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(updateTime:)
                                                        userInfo:nil
                                                         repeats:YES];
            [self setupAudioPlayer];
            [audioPlayer playAudio];
            self.isPaused = TRUE;
        } else {
            //player is paused and Button is pressed again
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_play.png"]
                                       forState:UIControlStateNormal];
            
            [audioPlayer pauseAudio];
            self.isPaused = FALSE;
        }
    }
}

/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing) {
        self.currentTimeslider.value = [audioPlayer getCurrentAudioTime];
    }
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [FormatFile timeFormat:[audioPlayer getCurrentAudioTime]]];
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [FormatFile timeFormat:[audioPlayer getAudioDuration] - [audioPlayer getCurrentAudioTime]]];
    
    //When resetted/ended reset the playButton
    if (![audioPlayer isPlaying]) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_play.png"]
                                   forState:UIControlStateNormal];
        [audioPlayer pauseAudio];
        self.isPaused = FALSE;
    }
}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
 */
- (IBAction)setCurrentTime:(id)scrubber {
    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [audioPlayer setCurrentAudioTime:self.currentTimeslider.value];
    self.scrubbing = FALSE;
}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */
- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = TRUE;
}


- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [self.recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
