//
//  AccelerometerTracker.m
//  Location
//
//  Created by Arvind Chockalingam on 2/8/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "AccelerometerTracker.h"

// The accelerometer is updating every 1 second

@implementation AccelerometerTracker

#pragma mark - Setting up CoreMotion
-(id) init
{
    if(self== [super init])
    {
        self.coreMotionManager=[[CMMotionManager alloc] init];
        self.dataManager=[DataManager sharedInstance];        
    }
    return self;
}

-(void) startAccelerometerTracking
{
    NSLog(@"setting up parameters for CoreMotion");
    //set the update interval in seconds
    self.coreMotionManager.accelerometerUpdateInterval = 10;
    self.coreMotionManager.gyroUpdateInterval = .2;
    [self.coreMotionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self storeAccelerationData:accelerometerData.acceleration];
                                                 if(error){
                                                     NSLog(@"%@", error);
                                                 }}];
}

#pragma mark - storing the acceleration data

-(void) storeAccelerationData:(CMAcceleration)acceleration
{
    //create the entity over here
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Accelerometer" inManagedObjectContext:self.dataManager.managedObjectContext];
    
    NSManagedObject *latestAccelerometer = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.dataManager.managedObjectContext];
    [latestAccelerometer setValue:[NSNumber numberWithDouble:acceleration.x] forKey:@"x_axis"];
    [latestAccelerometer setValue:[NSNumber numberWithDouble:acceleration.y] forKey:@"y_axis"];
    [latestAccelerometer setValue:[NSNumber numberWithDouble:acceleration.z] forKey:@"z_axis"];
    
    NSLog(@"Stored the accelerometer data");
    
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accelerometer" inManagedObjectContext:self.dataManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *result = [self.dataManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
   
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        if(result.count > 0 )
        {
            
            NSManagedObject *r = (NSManagedObject *)[result objectAtIndex:result.count - 1];
            
            NSLog(@"x-axis : %@", [r valueForKey:@"x_axis"]);
            
//            NSLog(@"result count : %lu  LATITUDE : %@", (unsigned long)[result count],[r valueForKey:@"latitude"]);
        }
    }
    
    
    
    
    
    
}
@end


