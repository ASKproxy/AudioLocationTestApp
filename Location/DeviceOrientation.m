//
//  DeviceOrientation.m
//  Location
//
//  Created by Aaron Jun Yang on 2/24/15.
//  Copyright (c) 2015 Location. All rights reserved.
//
//  To create a deviceOrientation singleton object that shared
//  among Stress, Sleep, Activity, Social tab bars

#import "DeviceOrientation.h"



@implementation DeviceOrientation
@synthesize orientation = _orientation;


#pragma mark - Main Method
-(id)init {
    self = [super init];
    
    _orientation = [UIDevice currentDevice].orientation;
    
    return self;
}


/**
 Setup methond which calls all the individual helper
 method to initialize sensors
 */
+ (DeviceOrientation *)sharedDeviceOrientation{
    static DeviceOrientation *_DeviceOrientation = nil;
    
    if (!_DeviceOrientation) {
        //New thread for SetupSensors object
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _DeviceOrientation = [[DeviceOrientation alloc] init];
            
        });
    }

    return _DeviceOrientation;
}


#pragma mark - Setter
/**
 Setup device orientation
 When the device orientation is unknown, faceup or facedown,
 do nothing and use the previous device orientation value.
 */
-(void)setOrientation:(UIDeviceOrientation)orientation{
    
    
    switch (orientation) {
        case UIDeviceOrientationUnknown:
            
            break;
        
        case UIDeviceOrientationPortrait:
            _orientation = orientation;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            _orientation = orientation;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            _orientation = orientation;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            _orientation = orientation;
            break;
        case UIDeviceOrientationFaceUp:
            
            break;
        case UIDeviceOrientationFaceDown:
            
            break;
        default:
            break;
    }
}

//typedef NS_ENUM(NSInteger, UIDeviceOrientation) {
//    UIDeviceOrientationUnknown,
//    UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
//    UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
//    UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
//    UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
//    UIDeviceOrientationFaceUp,              // Device oriented flat, face up
//    UIDeviceOrientationFaceDown             // Device oriented flat, face down
//};

#pragma mark - Getter

/**
 Return device orientation
 */
-(UIDeviceOrientation)getOrientation{
    
    return _orientation;
}



@end
