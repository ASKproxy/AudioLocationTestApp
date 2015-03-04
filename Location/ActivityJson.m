//
//  ActivityJson.m
//  Location
//
//  Created by Arvind Chockalingam on 3/4/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "ActivityJson.h"

@implementation ActivityJson

@synthesize activity;
@synthesize period;
@synthesize userName;

-(id)initWithCode   :(int)activity_
             period :(int)period_
            userName:(NSString *)userName_
{
    self = [super init];
    if (self) {
        
        self.activity = [NSNumber numberWithInt:activity_];
        self.period=[NSNumber numberWithInt:period_];
        self.userName=userName_;
    }
    return self;
}

- (NSMutableDictionary *)toNSDictionary
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.activity forKey:@"activity"];
    [dictionary setValue:self.period forKey:@"period"];
    [dictionary setValue:self.userName forKey:@"userName"];
    return dictionary;
}

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.activity = [decoder decodeObjectForKey:@"activity"];
        self.period = [decoder decodeObjectForKey:@"period"];
        self.userName=[decoder decodeObjectForKey:@"userName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:activity forKey:@"activity"];
    [encoder encodeObject:period forKey:@"period"];
    [encoder encodeObject:userName forKey:@"userName"];
}


@end
