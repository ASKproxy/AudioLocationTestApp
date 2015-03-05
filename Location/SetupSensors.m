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




/** Arvind C. Senthil Kumaran

The sleep data is stored in Core Data in the following format : 
 
 Date ====>  interval number ===> state & duration
 
 eg. 
 Day 1 ====>  1 ====> sleeping,40 min
              2 ====> not sleeping, 10 min
              ..
 Day 2 ====>  1 ====> not sleeping, 20 min
 
 and so on.
 
 **/




#import "SetupSensors.h"
#define FRAME_LENGTH 256
#define ONE_MINUTE 60
#define ONE_HOUR 3600
#define INTERVAL_LENGTH 10800 // 3 hours : 3600 seconds*3=10800
#define LOCKTIME_THRESHOLD 7200 //2 hours : 120 minutes*60=2400 seconds
#define LOCKCOUNT_THRESHOLD 3

@interface SetupSensors(){

}
@end


@implementation SetupSensors


static int _NotificationFireTimeOfDay[] = {14};
static int _NotificationFireMinOfDay[] = {15,16,17,18};
static int sleepIndicator=0;

static int intervalCounter=0;

#pragma mark - Main Method
-(id)init {
    self = [super init];
    NSLog(@"sharedSetupSensors initialized!");
    return self;
}


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
    
        
        //setup
        [_setupSensors setupCoreData];
        [_setupSensors setupServer];
        [_setupSensors setupAudioMicrophone];
        [_setupSensors setupLocationGPS];
        [_setupSensors setupNotifications];
        [_setupSensors setupBluetooth];
        [_setupSensors setupAccelerometer];
        [_setupSensors setupActivityClassifier];
        [_setupSensors shortTimer];
        [_setupSensors dailyTimer];

    });
    return _setupSensors;
}



#pragma Server

-(void) setupServer
{
    self.server = [Server setupServer];
}


#pragma mark - Short Timer

//timer is called every 3 hours
-(void) shortTimer
{
    // Define the timer object
    NSTimer *timer;
    // Create the timer object
    timer = [NSTimer scheduledTimerWithTimeInterval:ONE_HOUR*3 target:self    //  ***************************************************
                                           selector:@selector(updateActivityAndSocial:) userInfo:nil repeats:YES];
}



- (void) updateActivityAndSocial:(NSTimer *)incomingTimer
{

    //if day is over, then reset the interval counter to zero
    if(intervalCounter>8)
        intervalCounter=0;
    else
        intervalCounter++;
    
    NSLog(@"going to update classifiers");
    NSDate *startInterval = [[NSDate alloc] initWithTimeInterval:-ONE_HOUR*3   //  ***************************************************
                                                  sinceDate:[NSDate date]];
    NSDate *endInterval = [NSDate date];
    
    
    
    //retrieve data from all tables in Core Data using an NSPredicate.
    //Process them individually since the process can not be generalized due to
    //different attributes for each table.
    
    //------------------------------------------------
    //1. Sleep - Phone Lock & Unlock
  
    sleepIndicator+=[self checkLockRecords:startInterval upUntil:endInterval inTimeInterval:intervalCounter];
    //------------------------------------------------
    //2. Activity - Gets latest activity value and stores it into CoreData
    
//    [self.activityTracker getTrackingAcitivity];
    
    //------------------------------------------------
    //3. Social -
    
    
}


#pragma mark - 24-Hour Timer

/**
Set up a 24 hour timer that will be used to compute the following :
 
 1. Sleep - every 24 hours, the 8 intervals that were labelled using the short timers are averaged to determine the level of sleep for the user. The data is also is sent to the server and the campus average is obtained from the server
 
 2. Activity - Campus average is obtained from the server. Local data is sent up to the server
 
 3. Social - Campus average is obtained from the server. Local data is sent up to the server
 
 4. Stress - Campus average is obtained from the server. Local data is sent up to the server
 
 **/

-(void) dailyTimer
{
    NSTimer *timer;
    // Create the timer object
    timer = [NSTimer scheduledTimerWithTimeInterval:ONE_HOUR*24 target:self
                                           selector:@selector(dailyUpdates:) userInfo:nil repeats:YES];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:06];
    [comps setMonth:03];
    [comps setYear:2015];
    NSDate *d = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    NSTimer *t = [[NSTimer alloc] initWithFireDate: d
                                          interval: 24
                                            target: self
                                          selector:@selector(getCampusAverages:)
                                          userInfo:nil repeats:YES];
    
}


-(void) getCampusAverages:(NSTimer *)incomingTimer
{
    //gets campus activity average
    [self.server import];
    
    
}

- (void) dailyUpdates:(NSTimer *)incomingTimer
{
    [self pushStressRecords];
    [self sleepAverage];
    [self activityAverage];

}

#pragma mark - Averages

-(void) activityAverage
{
    double average= [[self.activityTracker.previousActivity valueForKey:@"average"] doubleValue];
    [self.server pushActivityAverage:average];
}

-(void) sleepAverage
{
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SleepLogs" inManagedObjectContext:self.dataManager.managedObjectContext];
    
//get today's records from SleepLog
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"date==%@",strDate]];
    NSError *error;
    
    NSArray * array = [self.dataManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (array == nil) {
        NSLog(@"Testing: No results found");
        
    }else {
        
        NSLog(@"Testing: %lu Results found.", (unsigned long)[array count]);
        
    }
    // NSData to NSDictionary
    NSData * data = [[array objectAtIndex:0] data];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableDictionary *dictionary = [unarchiver decodeObjectForKey:@"interval_dictionary"];
    [unarchiver finishDecoding];

    int duration=0;
    for(id key in dictionary)
    {
        NSMutableDictionary *inner=[NSMutableDictionary new];
        inner=dictionary[key];
        if([[inner valueForKey:@"state"] isEqual:@"sleeping"])
        {
            duration+=[[inner valueForKey:@"duration"] intValue];
        }
    }
    //duration is in seconds, remember to convert to minutes
    [self.server pushSleepAverage:(duration/60)];
    
}

#pragma mark - Records
-(void) pushStressRecords
{
    
    NSArray *results = [self fetchTodaysRecords:@"PAM"];
    [self.server pushStress:results];
    
}


//should move this to DataManager.m
-(NSArray *) fetchTodaysRecords:(NSString*)tableName
{
    
    NSDate *startInterval = [[NSDate alloc] initWithTimeInterval:-ONE_HOUR*24
                                                       sinceDate:[NSDate date]];
    NSDate *endInterval = [NSDate date];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(timestamp >= %@) AND (timestamp <= %@)", startInterval, endInterval];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:tableName inManagedObjectContext:self.dataManager.managedObjectContext]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    //results array has all the records stored in the last interval
    NSArray *results = [self.dataManager.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    else{
        return results;
    }

    return nil;
}

#pragma mark - Lock
-(int) checkLockRecords:(NSDate *)startInterval upUntil:(NSDate *)endInterval inTimeInterval:(int)intervalCounter
{
    
    int lockedDuration=0;
    int numberOfLocks=0;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(timestamp >= %@) AND (timestamp <= %@)", startInterval, endInterval];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Lock" inManagedObjectContext:self.dataManager.managedObjectContext]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    //results array has all the records stored in the last interval
    NSArray *results = [self.dataManager.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    else
    {
        if(results.count > 0)
        {
            int limit=(results.count%2)?results.count-1:results.count;
            for(int i=0;i<limit;i+=2)
            {
                NSManagedObject *lockEntry= (NSManagedObject *)[results objectAtIndex:i];  //using this instead of i and i-1 because the
                NSManagedObject *unlockEntry= (NSManagedObject *)[results objectAtIndex:i+1];    //loop will not work if there are only 2 locks in the results array. will get indexoutofbounds exceptions
                
                
                NSDate *lock= [lockEntry valueForKey:@"timestamp"];
                NSDate *unlock = [unlockEntry valueForKey:@"timestamp"];
                
                lockedDuration+= [unlock timeIntervalSinceDate:lock] ;
                numberOfLocks++;
                
            }
            
            //check if phone has been locked for more than 2 hours
            //and if it has been unlocked less than 3 times
            //then the person is assumed to be asleep
            if(lockedDuration>1 && numberOfLocks<5)   // CHANGE BACK WHEN DONE TESTING  ******************************************
            {
                [self storeIntoSleepLogs:intervalCounter withState:@"sleeping" forDuration:lockedDuration];
            }
            else
            {
                [self storeIntoSleepLogs:intervalCounter withState:@"awake" forDuration:lockedDuration];
            }
            
        }
        //if there are no entries, that probaly means that the user hasnt used the phone and can be assumed to
        // have slept for 180 minutes
        else if(results.count==0)
                [self storeIntoSleepLogs:intervalCounter withState:@"sleeping" forDuration:180];
        
    }
    
    
    return 0;
}


//store the values into core data in the necessary format
-(void) storeIntoSleepLogs:(int)intervalCounter withState:(NSString *)state forDuration:(double)duration
{
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SleepLogs" inManagedObjectContext:self.dataManager.managedObjectContext];
    
    NSManagedObject *latestValue = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.dataManager.managedObjectContext];

   
    //check if it is the first entry of the day and create a new Log
    if(intervalCounter==1)
    {

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        
        //first set the date for the object and then create the associated dictionary to store in Core Data
        //the date needs to have only the date and not the time since the time will change
        //before the next interval when we try to retrieve the dictionary
        [latestValue setValue:strDate forKey:@"date"];
        
        NSDictionary *interval_log = [[NSDictionary alloc]initWithObjectsAndKeys:state,@"state",[NSNumber numberWithDouble:duration],@"duration", nil];
        
        NSMutableDictionary *interval = [[NSMutableDictionary alloc]initWithObjectsAndKeys:interval_log,[@(intervalCounter) stringValue], nil];
        
        //NSDictionary to NSData
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:interval forKey:@"interval_dictionary"];
        [archiver finishEncoding];
        
        [latestValue setValue:data forKey:@"data"];

        NSError *saveError = nil;
        
        if (![latestValue.managedObjectContext save:&saveError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", saveError, saveError.localizedDescription);
        }

        
    }
    else // else update the logs of the date
    {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        
        NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
        
        [fetchRequest setEntity:entityDescription];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"date==%@",strDate]];
        NSError *error;
        
        NSArray * array = [self.dataManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if (array == nil) {
            NSLog(@"Testing: No results found");
            
        }else {
            
            NSLog(@"Testing: %lu Results found.", (unsigned long)[array count]);
        
        if([array count] > 0)
        {
        // NSData to NSDictionary
        NSData * data = [[array objectAtIndex:0] data];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSMutableDictionary *dictionary = [unarchiver decodeObjectForKey:@"interval_dictionary"];
        [unarchiver finishDecoding];
        //  dictionary is now ready to use
        

        NSDictionary *interval_log = [[NSDictionary alloc]initWithObjectsAndKeys:state,@"state",[NSNumber numberWithDouble:duration],@"duration", nil];
        
        
        [dictionary setValue:interval_log forKey:[@(intervalCounter) stringValue]];
        
        //store the dictionary back into the database
        NSManagedObject *latestValue = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.dataManager.managedObjectContext];
        
        //NSDictionary to NSData
        NSMutableData *modifiedData = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:modifiedData];
        [archiver encodeObject:dictionary forKey:@"interval_dictionary"];
        [archiver finishEncoding];
        
        [latestValue setValue:modifiedData forKey:@"data"];
        
        NSError *saveError = nil;
        
        if (![latestValue.managedObjectContext save:&saveError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", saveError, saveError.localizedDescription);
        }

        }
        }
    }
    
}

#pragma mark - Core Data
-(void) setupCoreData
{
    self.dataManager=[DataManager sharedInstance];
}


#pragma mark - Setup Activity Classifier
//we only need to initiate the activity manager here since CMMotionActivityManager
// allows us to read all the history of activity.
-(void)setupActivityClassifier
{
    self.activityTracker= [ActivityClassifier setup];
}


#pragma mark - Setup Audio

/**
 Setup AudioMicrophone singleton object. This methond should be called only once in the AppDelegate
 Setup AudioProcessing singleton object.
 */
- (void)setupAudioMicrophone{
    
    self.audioProcessing = [AudioProcessing sharedAudioProcessing];    
//    self.audioProcessing= [[AudioProcessing alloc]init];
   
    self.ezMicrophone = [EZMicrophone sharedMicrophone];
    [self.ezMicrophone initWithMicrophoneDelegate:self startsImmediately:YES];
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
        [self.audioProcessing processAudio:buffer[0]];
    });
    
}


#pragma mark - Setup LocationGPS
/**
 Setup LocationTracker singleton object
 */
- (void)setupLocationGPS{
    self.locationTracker = [[LocationTracker alloc]init];
    [self.locationTracker startLocationTracking];
}


#pragma mark - Setup Accelerometer
/**
 Setup AccelerometerTracker singleton object
 */
- (void)setupAccelerometer{
    self.accelerometerTracker = [[AccelerometerTracker alloc]init];
    [self.accelerometerTracker startAccelerometerTracking];
}


#pragma mark - Setup Bluetooth
/**
 Setup BluetoothTracker singleton object
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
