//
//  PamSurveyViewController.m
//  Location
//
//  Created by Student student on 2/10/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "PamSurveyViewController.h"
#import "MainViewController.h"


@interface PamSurveyViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *PamStressButtons;

@end

@implementation PamSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)PamStressButton:(id)sender {
    
    int stressLevel = [self.PamStressButtons indexOfObject:sender];
    
    NSLog(@"The idx of stress is %i", stressLevel);
    
    
    //Do something to store the selected stressLevel to the database
    //and get back to first landing page
    
    
    
    
//    //My_specificViewController
//    MainViewController *mainViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//    [self.window setRootViewController:mainViewController];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];

}



@end
