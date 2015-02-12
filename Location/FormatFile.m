//
//  FormatFile.m
//  StudentLife
//
//  Created by Aaron Jun Yang on 2/3/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "FormatFile.h"

@implementation FormatFile

/*
 * Format the float time values like duration
 * to format with minutes and seconds
 */
+(NSString*)timeFormat:(float)value{
    
    float hours = floor(lroundf(value)/3600);
    float minutes = floor((lroundf(value) - hours * 3600)/60); //floor(lroundf(value)/60);
    float seconds = lroundf(value) - (hours * 3600) - (minutes * 60);
    
    int roundedHours = (int)lroundf(hours);
    int roundedSeconds = (int)lroundf(seconds);
    int roundedMinutes = (int)lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%02d:%02d:%02d", roundedHours,
                      roundedMinutes, roundedSeconds];
    return time;
}


@end
