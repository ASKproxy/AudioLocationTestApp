//
//  PamSurveyViewController.h
//  Location
//
//  Created by Student student on 2/10/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "Indicators.h"

@interface PamSurveyViewController : UIViewController

@property(strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) DataManager * dataManager;
@property(strong,nonatomic) Indicators *indicator;

- (IBAction)PamStressButton:(id)sender;

@end
