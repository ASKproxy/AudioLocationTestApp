//
//  MainViewController.m
//  StudentLife
//  
//  Created by Aaron Jun Yang
//  Copyright (c) 2014 Location. All rights reserved.
//
//  The MainViewController sets up sensor instances including GPS, Bluetooth, Microphone,
//  Accelerameter, and other house keeping instances including Lock&Unlock state, database, server,
//  and PAM study. It automatically starts all event in the background once the app is launched. The
//  app continuously senses in the background and check each instance every certain time period. For
//  audio input, the App does the realtime processing and only store the classifier results with are
//  integer values. Every time when the user charges the phone, it pushes all the data to the cloud.


#import "MainViewController.h"


@interface MainViewController (){
    COMPLEX_SPLIT _A;
    FFTSetup      _FFTSetup;
    BOOL          _isFFTSetup;
    vDSP_Length   _log2n;
}

@end


@implementation MainViewController
//@synthesize ezMicrophone;
@synthesize audioPlotFreq;
@synthesize audioPlotTime;
@synthesize microphone;


#pragma mark - Setup passive sensing
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    // Disable Stop/Play button when application launches
//    [self.stopButton setEnabled:YES];
//    [self.playButton setEnabled:YES];
//    
//    audioPlayer = [[StudentLifeBackgroundAudio alloc] init];
//    
//    // Setup recorder
//    audioRecorder = [[StudentLifeBackgroundAudioRecorder alloc]init];
////    [audioRecorder setupAudioSettings];
//    [audioRecorder setupAudioRecorder];
    
    NSLog(@"ViewDidLoad called! @LocationViewController");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    /*
     Customizing the audio plot's look
     */
    // Setup time domain audio plot
    self.audioPlotTime.backgroundColor = [UIColor colorWithRed: 0.569 green: 0.82 blue: 0.478 alpha: 1];
    self.audioPlotTime.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.audioPlotTime.shouldFill      = YES;
    self.audioPlotTime.shouldMirror    = YES;
    self.audioPlotTime.plotType        = EZPlotTypeRolling;
    
    // Setup frequency domain audio plot
    self.audioPlotFreq.backgroundColor = [UIColor colorWithRed: 0.984 green: 0.471 blue: 0.525 alpha: 1];
    self.audioPlotFreq.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.audioPlotFreq.shouldFill      = YES;
    self.audioPlotFreq.plotType        = EZPlotTypeBuffer;
    
    /*
     Start the microphone
     */
//      self.microphone = [EZMicrophone microphoneWithDelegate:self
//                                           startsImmediately:NO];

    /*
     Retrieve the signleton EZMicrophone object
     */
    self.microphone = [EZMicrophone sharedMicrophone];
//    [self.microphone initWithMicrophoneDelegate:self startsImmediately:NO];
    
//    NSLog(@"********Microphone is %i*****************", self.microphone.microphoneOn);
    

}



/**
 Callback method in ViewController
 */
- (void)appplicationIsActive:(NSNotification *)notification {
    NSLog(@"🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶Application Did Become Active🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶");
//    [self.microphone startFetchingAudio];
    NSLog(@"********Microphone is %i in ViewController*****************", self.microphone.microphoneOn);
}


/**
 Callback method in ViewController
 */
- (void)applicationEnteredForeground:(NSNotification *)notification {
    NSLog(@"🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶Application Entered Foreground🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶");
}

/*
 * Hide the statusbar
 */
- (BOOL)prefersStatusBarHidden
{
    return NO;
}


#pragma mark - FFT

/**
 Adapted from http://batmobile.blogs.ilrt.org/fourier-transforms-on-an-iphone/
 */
-(void)createFFTWithBufferSize:(float)bufferSize withAudioData:(float*)data {
    
    // Setup the length
    _log2n = log2f(bufferSize);
    
    // Calculate the weights array. This is a one-off operation.
    _FFTSetup = vDSP_create_fftsetup(_log2n, FFT_RADIX2);
    
    // For an FFT, numSamples must be a power of 2, i.e. is always even
    int nOver2 = bufferSize/2;
    
    // Populate *window with the values for a hamming window function
    float *window = (float *)malloc(sizeof(float)*bufferSize);
    vDSP_hamm_window(window, bufferSize, 0);
    // Window the samples
    vDSP_vmul(data, 1, window, 1, data, 1, bufferSize);
    free(window);
    
    // Define complex buffer
    _A.realp = (float *) malloc(nOver2*sizeof(float));
    _A.imagp = (float *) malloc(nOver2*sizeof(float));
    
}

-(void)updateFFTWithBufferSize:(float)bufferSize withAudioData:(float*)data {
    
    // For an FFT, numSamples must be a power of 2, i.e. is always even
    int nOver2 = bufferSize/2;
    
    // Pack samples:
    // C(re) -> A[n], C(im) -> A[n+1]
    vDSP_ctoz((COMPLEX*)data, 2, &_A, 1, nOver2);
    
    // Perform a forward FFT using fftSetup and A
    // Results are returned in A
    vDSP_fft_zrip(_FFTSetup, &_A, 1, _log2n, FFT_FORWARD);
    
    // Convert COMPLEX_SPLIT A result to magnitudes
    float amp[nOver2];
    float maxMag = 0;
    
    for(int i=0; i<nOver2; i++) {
        // Calculate the magnitude
        float mag = _A.realp[i]*_A.realp[i]+_A.imagp[i]*_A.imagp[i];
        maxMag = mag > maxMag ? mag : maxMag;
    }
    for(int i=0; i<nOver2; i++) {
        // Calculate the magnitude
        float mag = _A.realp[i]*_A.realp[i]+_A.imagp[i]*_A.imagp[i];
        // Bind the value to be less than 1.0 to fit in the graph
        amp[i] = [EZAudio MAP:mag leftMin:0.0 leftMax:maxMag rightMin:0.0 rightMax:1.0];
    }
    
    NSLog(@"amp length is : %lu", sizeof(amp)/sizeof(amp[0]));

    // Update the frequency domain plot
    [self.audioPlotFreq updateBuffer:amp
                      withBufferSize:nOver2];
    
}

#pragma mark - EZMicrophoneDelegate
-(void)    microphone:(EZMicrophone *)microphone
     hasAudioReceived:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Update time domain plot
        [self.audioPlotTime updateBuffer:buffer[0]
                          withBufferSize:bufferSize];
        
        // Setup the FFT if it's not already setup
        if( !_isFFTSetup ){
            [self createFFTWithBufferSize:bufferSize withAudioData:buffer[0]];
            _isFFTSetup = YES;
        }
        
        // Get the FFT data
        [self updateFFTWithBufferSize:bufferSize withAudioData:buffer[0]];
        
        NSLog(@"EZMicrophone Delegate got called in ViewController!");
        
//        if( !_isFFTSetup ){
//            [FormatFile createFFTWithBufferSize:bufferSize withAudioData:buffer[0]];
//            _isFFTSetup = YES;
//        }
//        
//        // Get the FFT data
//        [FormatFile updateFFTWithBufferSize:bufferSize withAudioData:buffer[0] inEZAudioPlot:self.audioPlotFreq];
//        
        
    });
}

//
//#pragma mark - Audio

/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
//- (void)setupAudioPlayer
//{
//    [audioPlayer initPlayerWithUrl:[audioRecorder getUrl] error:nil];
//    //init the Player to get file properties to set the time labels
//    self.currentTimeslider.maximumValue = [audioPlayer getAudioDuration];
//    
//    //init the current timedisplay and the labels. if a current time was stored
//    //for this player then take it and update the time display
//    self.timeElapsed.text = @"0:00";
//    
//    self.duration.text = [NSString stringWithFormat:@"-%@",
//                          [FormatFile timeFormat:[audioPlayer getAudioDuration]]];
//    
//    
//}


/*
 * RecordButton is pressed
 * record or pauses the recorder and sets
 * the record/pause Text of the Button
 */
//- (IBAction)recordPauseTapped:(id)sender {
//    // Stop the audio player before recording
//    if ([audioPlayer isPlaying]) {
//        [audioPlayer stopPlaying];
//    }
//    
//    if (![audioRecorder isRecording]) {
//        
//        // Start recording
//        [audioRecorder record];
//        [self.recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
//        
//    } else {
//        
//        // Pause recording
//        [audioRecorder pause];
//        [self.recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
//    }
//    
//    [self.stopButton setEnabled:YES];
//    [self.playButton setEnabled:NO];
//    
//    
//    NSLog(@"recordPauseTapped called! =%@", sender);
//}



/*
 * StopButton is pressed
 * stop recording audio
 */
//- (IBAction)stopTapped:(id)sender {
//    [audioRecorder stop];
//    NSLog(@"stopTapped called! =%@", sender);
//
//    [self.playButton setEnabled:YES];
//}


/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */
//- (IBAction)playTapped:(id)sender {
//    
//    [self.timer invalidate];
//   
////    if (!recorder.recording){
//    if (![audioRecorder isRecording]){
//        if (!self.isPaused) {
//            [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_pause.png"]
//                                       forState:UIControlStateNormal];
//            
//            //start a timer to update the time label display
//            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                          target:self
//                                                        selector:@selector(updateTime:)
//                                                        userInfo:nil
//                                                         repeats:YES];
//            [self setupAudioPlayer];
//            [audioPlayer playAudio];
//            self.isPaused = TRUE;
//        } else {
//            //player is paused and Button is pressed again
//            [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_play.png"]
//                                       forState:UIControlStateNormal];
//            
//            [audioPlayer pauseAudio];
//            self.isPaused = FALSE;
//        }
//    }
//}

/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
//- (void)updateTime:(NSTimer *)timer {
//    //to don't update every second. When scrubber is mouseDown the the slider will not set
//    if (!self.scrubbing) {
//        self.currentTimeslider.value = [audioPlayer getCurrentAudioTime];
//    }
//    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
//                             [FormatFile timeFormat:[audioPlayer getCurrentAudioTime]]];
//    
//    self.duration.text = [NSString stringWithFormat:@"-%@",
//                          [FormatFile timeFormat:[audioPlayer getAudioDuration] - [audioPlayer getCurrentAudioTime]]];
//    
//    //When resetted/ended reset the playButton
//    if (![audioPlayer isPlaying]) {
//        [self.playButton setBackgroundImage:[UIImage imageNamed:@"audioplayer_play.png"]
//                                   forState:UIControlStateNormal];
//        [audioPlayer pauseAudio];
//        self.isPaused = FALSE;
//    }
//}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
 */
//- (IBAction)setCurrentTime:(id)scrubber {
//    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
//    [NSTimer scheduledTimerWithTimeInterval:0.01
//                                     target:self
//                                   selector:@selector(updateTime:)
//                                   userInfo:nil
//                                    repeats:NO];
//    
//    [audioPlayer setCurrentAudioTime:self.currentTimeslider.value];
//    self.scrubbing = FALSE;
//}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */
//- (IBAction)userIsScrubbing:(id)sender {
//    self.scrubbing = TRUE;
//}


//- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
//    [self.recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
//    
//    [self.stopButton setEnabled:NO];
//    [self.playButton setEnabled:YES];
//    NSLog(@"🔕audioRecorderDidFinishRecording called!🔕");
//}
//
//- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Finish playing the recording!"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//    NSLog(@"audioPlayerDidFinishPlaying called!");
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
