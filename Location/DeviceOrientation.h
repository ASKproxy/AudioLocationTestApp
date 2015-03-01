//
//  DeviceOrientation.h
//  Location
//
//  Created by Student student on 2/24/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceOrientation : NSObject

@property (assign, nonatomic) UIDeviceOrientation orientation;

#pragma mark - Singleton
///-----------------------------------------------------------
/// @name Shared Instance
///-----------------------------------------------------------

/**
 A shared instance of device orientation which is used in Stress, Sleep, Activity, Social tab bars
 
 @return A shared instance of the `DeviceOrientation` component.
 */
+(DeviceOrientation*)sharedDeviceOrientation;


#pragma mark - Setter
-(void)setOrientation:(UIDeviceOrientation)orientation;


#pragma mark - Getter
-(UIDeviceOrientation)getOrientation;



@end
