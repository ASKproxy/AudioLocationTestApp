//
//  LocationAppDelegate.h
//  StudentLife
//
//  Created by Aaron Jun Yang
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LocationTracker.h"
#import <AVFoundation/AVFoundation.h>
#import "EZMicrophone.h"
#import "SetupSensors.h"
#import "DataManager.h"
#import "Server.h"
#import "SetupTimers.h"


/**
LOCK  & UNLOCK
 When lock is pressed, it is store along with a timestamp in database. 
 When unlock is pressed, the last entry in database is retrieved. If it 
 is a lock, then the unlock timestamp is added to the that entry. 
 
 

**/

NSInteger gLockComplete, gLockState;
//EZMicrophone *ezMicrophone;
SetupSensors *setupSensors;
SetupTimers *setupTimers;
DataManager * dataManager;



@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NSInteger gLockComplete, gLockState;
//@property LocationTracker * locationTracker;
@property (strong,nonatomic) Server *server;



@end

