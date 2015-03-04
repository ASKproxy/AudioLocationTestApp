//
//  Server.h
//  Location
//
//  Created by Arvind Chockalingam on 2/27/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface Server : NSObject


@property NSMutableArray *objects;
@property (strong,nonatomic) DataManager * dataManager;


+ (Server *)setupServer;


- (void)import;
- (void) persist;

-(void) parseAndAddLocations:(NSArray *)responseArray toArray:(NSMutableArray*)objects;

@end