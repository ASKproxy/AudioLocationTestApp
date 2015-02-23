//
//  PAM.h
//  Location
//
//  Created by Arvind Chockalingam on 2/19/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface PAM : NSObject


@property NSMutableDictionary *dailyDictionary;
@property NSMutableDictionary *userDictionary;
@property NSMutableDictionary *userWeeklyDictionary;

-(void) startParsingPAM;
-(float) computeCampusDaily;
-(float) computeCampusWeekly;
-(void) computeUserWeekly;

@end
