//
//  WrapperJson.m
//  Location
//
//  Created by Arvind Chockalingam on 3/4/15.
//  Copyright (c) 2015 Location. All rights reserved.
//


/**
Generic Wrapper class that can encapsulate any type of data. Used to store a list of
 other jsons such as stress or activity.
 **/


#import "WrapperJson.h"

@implementation WrapperJson

@synthesize timestamp;
@synthesize dataList;

- (NSMutableDictionary *)toNSDictionary
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for(ActivityJson *activity in self.dataList){
        [data addObject:[activity toNSDictionary]];
    }
    
    [dictionary setValue:self.timestamp
                  forKey:@"timestamp"];
    [dictionary setValue:data
                  forKey:@"dataList"];
    
    return dictionary;
}




/**
 (might not be required - arvind )
 The following two functions are implemented as part of the
 NSCoding protocol. They are required to convert the 
 JSON we have created into NSData objects. The reason for this conversion 
 is that the setHTTPbody parameter of NSMUtableURL accepts only 
 NSData
 
 **/

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.timestamp = [decoder decodeObjectForKey:@"timestamp"];
        self.dataList = [decoder decodeObjectForKey:@"dataList"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:timestamp forKey:@"timestamp"];
    [encoder encodeObject:dataList forKey:@"dataList"];
}


@end
