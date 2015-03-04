//
//  StressViewController.h
//  Location
//
//  Created by Student student on 2/21/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "JBBaseChartViewController.h"
#import "StudentLifeConstant.h"
#import "DeviceOrientation.h"
#import "DataManager.h"

@interface StressViewController : JBBaseChartViewController
@property (strong, nonatomic) DeviceOrientation *deviceOrientation;
@property (weak, nonatomic) IBOutlet UITabBarItem *StressButton;
@property (strong,nonatomic) DataManager * dataManager;

//extern NSInteger MYGlobalVariable;

- (NSInteger) getStressHeight;


@end
