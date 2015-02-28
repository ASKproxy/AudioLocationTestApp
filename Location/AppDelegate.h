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


NSInteger gLockComplete, gLockState;
//EZMicrophone *ezMicrophone;
SetupSensors *setupSensors;
DataManager * dataManager;



@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NSInteger gLockComplete, gLockState;
//@property LocationTracker * locationTracker;
@property (strong,nonatomic) Server *server;



@end

