//
//  SocialViewController.h
//  Location
//
//  Created by Student student on 2/17/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTracker.h"
#import "JBBaseChartViewController.h"
#import "StudentLifeConstant.h"
#import "DeviceOrientation.h"




@interface SocialViewController : JBBaseChartViewController
@property (strong, nonatomic) IBOutlet UILabel *GPSLat;
@property (strong, nonatomic) IBOutlet UILabel *GPSLon;
@property (strong, nonatomic) DeviceOrientation *deviceOrientation;
@property (weak, nonatomic) IBOutlet UITabBarItem *SocialButton;


@end
