//
//  StressJSON.h
//  Location
//
//  Created by Arvind Chockalingam on 3/4/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StressJSON : NSObject

@property NSNumber *stress_level;
@property NSString *userName;
@property NSNumber *period;


-(id)initWithCode   :(int)stress_level_
             period :(int)period_
            userName:(NSString *)userName_;
@end
