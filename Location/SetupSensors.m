//  SetupSensors.m
//  StudentLife
//
//  Created by Aaron Jun Yang on 2/8/15.
//  Copyright (c) 2015 Location. All rights reserved.
//
//  This class setup passive sensors and is called in
//  the AppDelegate during the period when the app is
//  launched. It will be called only once, and setup
//  singleton object for each sensor.

#import "SetupSensors.h"
#define FRAME_LENGTH 256


@interface SetupSensors(){
    COMPLEX_SPLIT _A;
    FFTSetup      _FFTSetup;
    BOOL          _isFFTSetup;
    vDSP_Length   _log2n;
}


@end


@implementation SetupSensors
@synthesize audioPlotFreq;
@synthesize audioPlotTime;


static int _NotificationFireTimeOfDay[] = {9, 16, 18};
static int _NotificationFireMinOfDay[] = {24, 28};
static int count=0;
float frame_buffer[FRAME_LENGTH];


-(id)init {
    self = [super init];
    NSLog(@"sharedSetupSensors initialized!");
    return self;
}

#pragma mark - Main Method
/**
 Setup methond which calls all the individual helper
 method to initialize sensors
 */
+ (SetupSensors *)sharedSetupSensors{
    static SetupSensors *_setupSensors = nil;
    
    //New thread for SetupSensors object
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _setupSensors = [[SetupSensors alloc] init];
    });
    
    [_setupSensors setupAudioMicrophone];
    [_setupSensors setupLocationGPS];
    [_setupSensors setupNotifications];
    [_setupSensors setupBluetooth];
    [_setupSensors setupAccelerometer];
    
    //set up hamming factors for the AudioProcessing
    //done here because it needs to be initialized only
    //once
//    [_setupSensors setUpHammingFactors];
    return _setupSensors;
}



-(void) setUpAudioProcessing
{

//    self.audioProcessing= [[AudioProcessing alloc]init];
    
}
#pragma mark - Setup Audio

/**
 Setup AudioMicrophone singleton object. This methond should be called only once in the AppDelegate
 */
- (void)setupAudioMicrophone{
    self.ezMicrophone = [EZMicrophone sharedMicrophone];
    [self.ezMicrophone initWithMicrophoneDelegate:self startsImmediately:YES];
    
//    NSLog(@"******************Microphone is %i in setupSensors*******************", self.ezMicrophone.microphoneOn);
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
    //    NSLog(@"amp value at position nOver2/2 is %f", amp[nOver2/2]);
    
    
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
    
//    NSLog(@"amp length is : %lu", sizeof(amp)/sizeof(amp[0]));
//    NSLog(@"amp value at position nOver2/2 is %f", amp[nOver2/2]);
    
    // Update the frequency domain plot
    [self.audioPlotFreq updateBuffer:amp
                      withBufferSize:nOver2];
    
}

#pragma mark - EZMicrophoneDelegates

/**
 Do signal processing converting from time domain to frequency domain
Input from the microphone is in the buffer array :

 BUFFER : an array of float values with the audio recieved.
          buffer[0] - value in left channel
          buffer[1] - value in right channel
 
 */
-(void)    microphone:(EZMicrophone *)microphone
     hasAudioReceived:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels {

    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
//        NSLog(@"BUFFER 0 IS: %f", (buffer[0])[0]);
//        NSLog(@"BUFFER 0 IS: %f", (buffer[1])[0]);
//        NSLog(@"BUFFER 1 IS: %f", (buffer[0])[1]);
//        NSLog(@"BUFFER 1 IS: %f", (buffer[1])[1]);
//        NSLog(@"BUFFER 2 IS: %f", (buffer[0])[2]);
//        NSLog(@"BUFFER 2 IS: %f", (buffer[1])[2]);
//        NSLog(@"BUFFER 3 IS: %f", (buffer[0])[3]);
//        NSLog(@"BUFFER 3 IS: %f", (buffer[1])[1000]);
//        NSLog(@"BUFFER size IS: %f", (buffer[0][1]));

      //every time we get 256 frames, process the frames immediately.
        if(count == FRAME_LENGTH)
        {
            NSLog(@"reached here!!!");
            AudioProcessing *new =[[AudioProcessing alloc]init];
            [new processAudio:frame_buffer];
            count=0;
        }
        else if(count < FRAME_LENGTH)
        {
            frame_buffer[count++]=*buffer[0];
//            NSLog(@"reached here!!!");

        }
        

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
        
    });
}


/**
 Contains AudioBufferlist from which we will take out 256 frames at a time so that we can feed it into the classifer.
 */
- (void)microphone:(EZMicrophone *)microphone hasBufferList:(AudioBufferList *)bufferList withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels
{
    
    

}

#pragma mark - Setup LocationGPS

/**
 Setup LocationTracker singleton object
 */
- (void)setupLocationGPS{
    self.locationTracker = [[LocationTracker alloc]init];
    [self.locationTracker startLocationTracking];
}


/**
 Setup LocationTracker singleton object
 */
- (void)setupAccelerometer{
    self.accelerometerTracker = [[AccelerometerTracker alloc]init];
    [self.accelerometerTracker startAccelerometerTracking];
}


/**
 Setup LocationTracker singleton object
 */
- (void)setupBluetooth{
    self.bluetoothTracker = [[BluetoothTracker alloc]init];
    [self.bluetoothTracker startBluetoothTracking: self.bluetoothTracker.centralManager];
}
#pragma mark - Setup Local Notifications


/**
 This method sets up local notifications by calling all the helper methods below
 */
- (void)setupNotifications{
//    [self registerNotificationType];
    
    //Schedule all notifications according to the time in the array of _NotificationFireTimeOfDay
//    for (NSInteger i = 0; i < sizeof(_NotificationFireTimeOfDay)/sizeof(int); i++){
//        [self scheduleNotificationWithItem:_NotificationFireTimeOfDay[i]];
//    }

    for (NSInteger i = 0; i < sizeof(_NotificationFireTimeOfDay)/sizeof(int); i++){
        for(int j = 0; j < sizeof(_NotificationFireMinOfDay)/sizeof(int); j++){
            [self scheduleNotificationWithItem:_NotificationFireTimeOfDay[i] min:_NotificationFireMinOfDay[j]];
        }
    }
}

/**
 Registering notification types to have badge number, playing alert sound, and banner alert. Adopted from Apple Developer Document: https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html
 */
- (void)registerNotificationType{
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    NSLog(@"Local Notification : registerNotificationType, got called!");
}

/**
 Schedule a notification. Code adopted from Apple Developer Document
 */
- (void)scheduleNotificationWithItem: (NSInteger)hour min: (NSInteger)min{
    
    //Notification fireDate
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitWeekOfYear) fromDate:today];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    
    [dateComps setDay:dateComponents.day];
    [dateComps setMonth:dateComponents.month];
    [dateComps setYear:dateComponents.year];
    
    [dateComps setHour: hour];
    [dateComps setMinute: min];
    [dateComps setSecond: 00];
    
    NSDate *fireDate = [calendar dateFromComponents:dateComps];
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = fireDate;
    if (localNotif == nil)
        return;
    
    //Notification repeat
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.repeatInterval = NSCalendarUnitDay;

    //Notification alert
    localNotif.alertBody = NSLocalizedString(@"StudentLife PAM Survey: Please pick a pufferfish", nil);
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);

    //Notification sound
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    //Notification badge
    localNotif.applicationIconBadgeNumber = 1;


//    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
//    localNotif.userInfo = infoDict;

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    NSLog(@"Local Notifications scheduled!");
}





@end