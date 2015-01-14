//
//  LocationAppDelegate.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTracker.h"
#import <AVFoundation/AVFoundation.h>

NSInteger gLockComplete, gLockState;

@interface LocationAppDelegate : UIResponder <UIApplicationDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NSInteger gLockComplete, gLockState;
@property LocationTracker * locationTracker;

@end

