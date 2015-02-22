//
//  PAM.m
//  Location
//
//  Created by Arvind Chockalingam on 2/19/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "PAM.h"

@implementation PAM

int i;
int week1_sum=0,week2_sum=0,week3_sum=0,week4_sum=0,week5_sum=0,week6_sum=0,week7_sum=0;
int week1_count=0,week2_count=0,week3_count=0,week4_count=0,week5_count=0,week6_count=0,week7_count=0;
double week1_avg=0,week2_avg=0,week3_avg=0,week4_avg=0,week5_avg=0,week6_avg=0,week7_avg=0;
int deadlineCounter=0;


#define DEADLINE "29-03-2013"
-(id) init
{
    
    if(self== [super init])
    {
        _dailyDictionary = [NSMutableDictionary new];
        _userDictionary = [NSMutableDictionary new];
        _userWeeklyDictionary = [NSMutableDictionary new];
    }
    return self;
}


-(void) startParsingPAM
{
    //use two loops to run through 00 to 59
    
    int i,j;
    for(i=0;i<5;i++)
    {
        for(j=0;j<10;j++)
        {
            NSString *fileName = [NSString stringWithFormat:@"PAM_u%d%d",i,j];
            NSString *pathAndFileName = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
            
            NSData* jsonData = [NSData dataWithContentsOfFile: pathAndFileName];
            if(jsonData==nil)
            {
                //                NSLog(@"its nil!!");
            }
            else
            {
                NSError *jsonError = nil;
                id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
                
                if ([jsonObject isKindOfClass:[NSArray class]]) {
                    //                    NSLog(@"its an array!");
                    NSArray *jsonArray = (NSArray *)jsonObject;
                    deadlineCounter+=[self processUser:jsonArray];
                    
                    //store daily dictionary in user dictionary and then reset the daily dictionary for the next user
                    [self.userDictionary setValue:[NSMutableDictionary dictionaryWithDictionary:self.dailyDictionary] forKey:fileName];
                    [self.dailyDictionary removeAllObjects];
                    
                    
                }
                else {
                    NSLog(@"its probably a dictionary");
                    NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
                    NSLog(@"jsonDictionary - %@",jsonDictionary);
                }
            }
        }
    }
    if(deadlineCounter==59)
        NSLog(@"deadline present!!");
}



#pragma mark - User
/**
 Go through each user and average the scores for each week
 **/
-(int) processUser:(NSArray *)user
{
    int deadlineDataCollected=0,flag=0;
    for(NSDictionary *entry in user)
    {
        
        deadlineDataCollected=[self storeDailyData:entry];
        //        if(deadlineDataCollected==1)
        flag=1;
    }
    return flag;
    
}

-(void) computeUserWeekly
{
    
    NSString *week;
    float average;
    int sum,count;
    
    for(NSString* key in self.userDictionary)
    {
        NSMutableDictionary *daily=[self.userDictionary valueForKey:key];
        for(NSString* day in daily)
        {
            week=[self determineWeek:day];
            if([self.userWeeklyDictionary objectForKey:week])
            {
                NSMutableDictionary *weeklyStats=[NSMutableDictionary new];
                weeklyStats=[self.userWeeklyDictionary valueForKey:week];
                sum=[[weeklyStats valueForKey:@"sum"] integerValue];
                count=[[weeklyStats valueForKey:@"count"] integerValue];

                count+=1;
                [weeklyStats setValue:[NSNumber numberWithInt:count] forKey:@"count"];

                sum+=[[daily valueForKey:@"average"] floatValue];
                [weeklyStats setValue:[NSNumber numberWithInt:sum] forKey:@"sum"];

                
                average=sum/count;
                [weeklyStats setValue:[NSNumber numberWithFloat:average] forKey:@"average"];
                
                [self.userWeeklyDictionary setValue:weeklyStats forKey:week];
            }
            else
            {
                NSMutableDictionary *weeklyStats=[NSMutableDictionary new];
                //find the average of all the daily averages
                [weeklyStats setValue:[daily valueForKey:@"average"] forKey:@"sum"];
                [weeklyStats setValue:[NSNumber numberWithInt:1] forKey:@"count"];
                [weeklyStats setValue:[daily valueForKey:@"average"] forKey:@"average"];
                [self.userWeeklyDictionary setValue:weeklyStats forKey:week];
            }
            
        }
    }
}


#pragma mark - Daily
/**
 Store the daily data
 **/

-(int) storeDailyData:(NSObject *)entry
{
    int count=0,sum=0;
    int flag=0;
    float average=0;
    
    NSTimeInterval epoch = [[entry valueForKey:@"resp_time"] doubleValue];
    NSDate *bar =[NSDate dateWithTimeIntervalSince1970:epoch];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [dateFormatter stringFromDate: bar];
    
    NSDate *userDate = [dateFormatter dateFromString:strDate];
    NSDate *deadlineDate = [dateFormatter dateFromString:@DEADLINE];
    
    
    if([userDate compare:deadlineDate]==NSOrderedSame)
    {
        //        NSLog(@"deadline date!!");
        flag=1;
    }
    
    if([self.dailyDictionary objectForKey:strDate]) //if entry exists then edit it
    {
        NSMutableDictionary *inner = [self.dailyDictionary objectForKey:strDate];
        //increment count
        count=[[inner valueForKey:@"count"] integerValue];
        count=count+1;
        [inner setValue:[NSNumber numberWithInt:count] forKey:@"count"];
        
        //update sum and average
        sum=[[inner valueForKey:@"sum"] integerValue];
        sum+=[[entry valueForKey:@"picture_idx"] integerValue];
        [inner setValue:[NSNumber numberWithInt:sum] forKey:@"sum"];
        
        average=sum/count;
        [inner setValue:[NSNumber numberWithFloat:average] forKey:@"average"];
        [self.dailyDictionary setValue:inner forKey:strDate];
    }
    else //if entry doesnt exist, create the inner dictionary and add it to the daily dictionary
    {
        float stressValue = [[entry valueForKey:@"picture_idx"] floatValue];
        NSMutableDictionary * inner =[NSMutableDictionary new];
        [inner setValue:[NSNumber numberWithFloat:stressValue] forKey:@"average"];
        [inner setValue:[NSNumber numberWithInt:stressValue] forKey:@"sum"];
        [inner setValue:[NSNumber numberWithInt:1] forKey:@"count"];
        [self.dailyDictionary setValue:inner forKey:strDate];
        
    }
    
    return flag;
}



#pragma mark - Campus

/**
 compute the daily stress all over the campus
 **/
-(float) computeCampusDaily
{
    int campusCount=0,campusSum=0;
    float campusAverage=0;
    
    //get the values for the specific day for all the users
    for(NSString* key in self.userDictionary)
    {
        NSMutableDictionary *inner= [[self.userDictionary valueForKey:key] valueForKey:@DEADLINE];
        campusCount++;
        campusSum+=[[inner valueForKey:@"average"]integerValue];
    }
    campusAverage=campusSum/campusCount;
    return campusAverage;
    
}

//-(float) computeCampusWeekly
//{
//    
//    
//}

#pragma mark - Weekly

-(NSString *) determineWeek:(NSString *)timestamp
{
    
    NSTimeInterval epoch = [timestamp doubleValue];
    NSDate *bar =[NSDate dateWithTimeIntervalSince1970:epoch];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate: bar];
    
    NSDate *userDate = [dateFormatter dateFromString:strDate];
    
    NSDate *week1_start = [dateFormatter dateFromString:@"2013-03-24"];
    NSDate *week1_end = [dateFormatter dateFromString:@"2013-03-30"];
    
    NSDate *week2_start = [dateFormatter dateFromString:@"2013-03-31"];
    NSDate *week2_end = [dateFormatter dateFromString:@"2013-04-06"];
    
    NSDate *week3_start = [dateFormatter dateFromString:@"2013-04-07"];
    NSDate *week3_end = [dateFormatter dateFromString:@"2013-04-13"];
    
    NSDate *week4_start = [dateFormatter dateFromString:@"2013-04-14"];
    NSDate *week4_end = [dateFormatter dateFromString:@"2013-04-20"];
    
    NSDate *week5_start = [dateFormatter dateFromString:@"2013-04-21"];
    NSDate *week5_end = [dateFormatter dateFromString:@"2013-04-27"];
    
    NSDate *week6_start = [dateFormatter dateFromString:@"2013-04-28"];
    NSDate *week6_end = [dateFormatter dateFromString:@"2013-05-04"];
    
    NSDate *week7_start = [dateFormatter dateFromString:@"2013-05-05"];
    NSDate *week7_end = [dateFormatter dateFromString:@"2013-05-11"];
    
    
    
    if (([week1_start compare:userDate] == NSOrderedAscending) && ([week1_end compare:userDate] == NSOrderedDescending))
    {
        return @"1";
    }
    else if (([week2_start compare:userDate] == NSOrderedAscending) && ([week2_end compare:userDate] == NSOrderedDescending))
    {
        return @"2";
    }
    else if (([week3_start compare:userDate] == NSOrderedAscending) && ([week3_end compare:userDate] == NSOrderedDescending))
    {
        return @"3";
    }
    else if (([week4_start compare:userDate] == NSOrderedAscending) && ([week4_end compare:userDate] == NSOrderedDescending))
    {
        return @"4";
    }
    else if (([week5_start compare:userDate] == NSOrderedAscending) && ([week5_end compare:userDate] == NSOrderedDescending))
    {
        return @"5";
    }
    else if (([week6_start compare:userDate] == NSOrderedAscending) && ([week6_end compare:userDate] == NSOrderedDescending))
    {
        return @"6";
    }
    else if (([week7_start compare:userDate] == NSOrderedAscending) && ([week7_end compare:userDate] == NSOrderedDescending))
    {
        return @"7";
    }
    else
        return @"0";
    
    
}
@end
