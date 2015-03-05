//
//  StressJSON.m
//  Location
//
//  Created by Arvind Chockalingam on 3/4/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

/**
 
 This class is used to encapsulate the STRESS data stored in Core Data
 into a JSON object so that it can be sent to the server through a HTTP 
 request
 
 **/



#import "StressJSON.h"

@implementation StressJSON


@synthesize stress_level;
@synthesize userName;
@synthesize period;

-(id)initWithCode   :(int)stress_level_
             period :(int)period_
            userName:(NSString *)userName_
{
    self = [super init];
    if (self) {
        
        self.stress_level = [NSNumber numberWithInt:stress_level_];
        self.period=[NSNumber numberWithInt:period_];
        self.userName=userName_;
    }
    return self;
}

- (NSMutableDictionary *)toNSDictionary
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.stress_level forKey:@"stress_level"];
    [dictionary setValue:self.period forKey:@"period"];
    [dictionary setValue:self.userName forKey:@"userName"];
    return dictionary;
}


@end
