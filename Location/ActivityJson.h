//
//  ActivityJson.h
//  Location
//
//  Created by Arvind Chockalingam on 3/4/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityJson : NSObject<NSCoding>

@property NSNumber *activity;
@property NSNumber *period;
@property NSString *userName;

-(id)initWithCode   :(int )activity_
             period :(int )period_
           userName : (NSString *)userName_;
- (NSMutableDictionary *)toNSDictionary;


@end
