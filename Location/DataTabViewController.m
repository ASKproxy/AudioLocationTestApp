//
//  DataTabViewController.h
//  StudentLife
//
//  Created by Aaron Jun Yang on 2/11/15.
//  Copyright (c) 2015 Location. All rights reserved.
//
//  The DataTabViewController is the tab bar view which contains four sub tab showing Stress, Sleep, Social, and Activity. It is the landing view of the app, and it also sets up sensor instances including GPS, Bluetooth, Microphone,Accelerameter, and other house keeping instances including Lock&Unlock state, database, server,and PAM study. It automatically starts all event in the background once the app is launched. The app continuously senses in the background and check each instance every certain time period. For audio input, the App does the realtime processing and only store the classifier results with are integer values. Every time when the user charges the phone, it pushes all the data to the cloud.

#import "DataTabViewController.h"

@interface DataTabViewController (){
    COMPLEX_SPLIT _A;
    FFTSetup      _FFTSetup;
    BOOL          _isFFTSetup;
    vDSP_Length   _log2n;
}

@end

@implementation DataTabViewController
@synthesize audioPlotFreq;
@synthesize audioPlotTime;
@synthesize microphone;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
