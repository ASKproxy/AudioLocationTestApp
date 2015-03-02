//
//  ActivityViewController.h
//  Location
//
//  Created by Student student on 2/21/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "JBBaseChartViewController.h"
#import "StudentLifeConstant.h"
#import "DeviceOrientation.h"

@interface ActivityViewController : JBBaseChartViewController
@property (weak, nonatomic) IBOutlet UITabBarItem *ActivityButton;

@property (strong, nonatomic) DeviceOrientation *deviceOrientation;

@end
