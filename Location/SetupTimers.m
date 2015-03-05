//
//  SetupTimers.m
//  Location
//
//  Created by Student student on 3/5/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "SetupTimers.h"
#define FRAME_LENGTH 256
#define ONE_MINUTE 60
#define ONE_HOUR 3600
#define INTERVAL_LENGTH 10800 // 3 hours : 3600 seconds*3=10800
#define LOCKTIME_THRESHOLD 7200 //2 hours : 120 minutes*60=2400 seconds
#define LOCKCOUNT_THRESHOLD 3



@implementation SetupTimers


static int sleepIndicator=0;
static int _NotificationFireTimeOfDay[] = {12};
static int _NotificationFireMinOfDay[] = {38, 40};
float frame_buffer[FRAME_LENGTH];

static int intervalCounter=0;

#pragma mark - Main Method
-(id)init {
    self = [super init];
    NSLog(@"sharedSetupTimers initialized!");
    return self;
}


/**
 Setup methond which calls all the individual helper
 method to initialize sensors
 */
+ (SetupTimers *)sharedSetupTimers{
    static SetupTimers *_setupTimers = nil;
    
    //New thread for SetupSensors object
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _setupTimers = [[SetupTimers alloc] init];
        
        
        //setup
        [_setupTimers setupActivityClassifier];
        [_setupTimers shortTimer];
        [_setupTimers dailyTimer];
    });
    
    
    return _setupTimers;
}

#pragma mark - Short Timer

//timer is called every 3 hours
-(void) shortTimer
{
    // Define the timer object
    NSTimer *timer;
    // Create the timer object
    timer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL_LENGTH target:self
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
    NSDate *startInterval = [[NSDate alloc] initWithTimeInterval:-ONE_MINUTE*1
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
    
    [self.activityTracker getTrackingAcitivity];
    
    //------------------------------------------------
    //3. Social -
    
    
}


#pragma mark - 24-Hour Timer

/**
 Set up a 24 hour timer that will be used to compute the following :
 1. Sleep - every 24 hours, the 8 intervals that were labelled using the short timers are averaged
 to determine the level of sleep for the user. The data is also is sent to the server and
 the campus average is obtained from the server
 
 2. Activity - Campus average is obtained from the server. Local data is sent up to the server
 
 3. Social - Campus average is obtained from the server. Local data is sent up to the server
 
 4. Stress - Campus average is obtained from the server. Local data is sent up to the server
 
 **/

-(void) dailyTimer
{
    
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
        NSLog(DatabaseFetchError);
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
                
                
                NSDate *lock= [lockEntry valueForKey:DatabaseTimeStamp];
                NSDate *unlock = [unlockEntry valueForKey:DatabaseTimeStamp];
                
                lockedDuration+= [unlock timeIntervalSinceDate:lock] ;
                numberOfLocks++;
                
            }
            
            //check if phone has been locked for more than 2 hours
            //and if it has been unlocked less than 3 times
            //then the person is assumed to be asleep
            if(lockedDuration>1 && numberOfLocks<5)   // CHANGE BACK WHEN DONE TESTING
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
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
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
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
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
    self.activityTracker= [ActivityClassifier sharedActivityClassifier];
}

@end
