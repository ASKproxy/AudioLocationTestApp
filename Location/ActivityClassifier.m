//
//  ActivityClassifier.m
//  Location
//
//  Created by Arvind Chockalingam on 3/1/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "ActivityClassifier.h"

#define ONE_HOUR 60*60
#define ONE_DAY 24*60*60



@implementation ActivityClassifier


-(id) init
{
    if(self== [super init])
    {
        self.activitymanager=[[CMMotionActivityManager alloc]init];
        self.dataManager=[DataManager sharedInstance];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.previousActivity=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithFloat:0],@"sum",[NSNumber numberWithFloat:0],@"count",[NSNumber numberWithFloat:0],@"average", nil];
            
        });    }
    return self;
}

+(ActivityClassifier *) sharedActivityClassifier
{
    ActivityClassifier* n= [[ActivityClassifier alloc]init];
    return n;
}


/**
Function is called every 3 hours and the average activty value is computed. 
 **/
-(void)getTrackingAcitivity
{
    if([CMMotionActivityManager isActivityAvailable])
    {
        [self.activitymanager queryActivityStartingFromDate:[NSDate dateWithTimeIntervalSinceNow:-3 * ONE_HOUR]
                                        toDate:[NSDate new]
                                       toQueue:[NSOperationQueue new]
                                   withHandler:^(NSArray *activities, NSError *error) {
                                       
                                       int activeCount=0;
                                       int inactiveCount=0;
                                       float sum=0,count=0,average=0;
                                       
                                       
                                       NSDateFormatter* df = [[NSDateFormatter alloc]init];
                                       [df setDateFormat:@"yyyy/MM/dd"];
                                       
                                       
                                       
                                       for(int i=0;i<activities.count-1;i++)
                                       {
                                           CMMotionActivity *activity = [activities objectAtIndex:i];
                                           if(activity.stationary)
                                               inactiveCount++;
                                           else
                                               activeCount++;
                                       }
                                       //retrieve old value and compute the new average
                                       sum=[[self.previousActivity valueForKey:@"sum"] floatValue];
                                       count=[[self.previousActivity valueForKey:@"count"]floatValue];
                                       average=[[self.previousActivity valueForKey:@"average"]floatValue];
                                       sum+=activeCount;
                                       count+=activities.count;
                                       average=sum/count;
                                       [self.previousActivity setValue:[NSNumber numberWithFloat:sum] forKey:@"sum"];
                                       [self.previousActivity setValue:[NSNumber numberWithFloat:count] forKey:@"count"];
                                       [self.previousActivity setValue:[NSNumber numberWithFloat:average] forKey:@"average"];
                                       
                                       //create the entity over here
                                       NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"TabIndicators" inManagedObjectContext:self.dataManager.managedObjectContext];
                                       
                                       NSManagedObject *latestValue = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.dataManager.managedObjectContext];

                                       
                                       [latestValue setValue:[self.previousActivity valueForKey:@"average"] forKey:@"activity"];
                                       [latestValue setValue:[df stringFromDate:[NSDate date]] forKey:@"timestamp"];
                                       
                                       NSError *saveError = nil;
                                       
                                       if (![latestValue.managedObjectContext save:&saveError]) {
                                           NSLog(DatabaseSaveError);
                                           NSLog(@"%@, %@", saveError, saveError.localizedDescription);
                                       }

                                       
                                   }];
    }
    else
    {
        NSLog(@"M7 Motion chip is not available on this phone!!");
    }
}


@end
