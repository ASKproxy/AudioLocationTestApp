//
//  LandingViewController.m
//  Location
//
//  Created by Student student on 2/17/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "LandingViewController.h"


@interface LandingViewController ()

@end

@implementation LandingViewController


#pragma mark - Setup View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Landing"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation
/**
 Open Tab Bar according to the paticular button pressed
 constant strings and indecis are declared in StudentLifeConstant
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:SegueStress]){
        [[segue destinationViewController] setSelectedIndex:SegueStressIndex];
    }else if ([segue.identifier isEqualToString:SegueSleep]){
        [[segue destinationViewController] setSelectedIndex:SegueSleepIndex];
    }else if ([segue.identifier isEqualToString:SegueActivity]){
        [[segue destinationViewController] setSelectedIndex:SegueActivityIndex];
    }else if ([segue.identifier isEqualToString:SegueSocial]){
        [[segue destinationViewController] setSelectedIndex:SegueSocialIndex];
    }
    

}



@end
