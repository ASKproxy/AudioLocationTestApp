//
//  DataTabViewController.h
//  StudentLife
//
//  Created by Aaron Jun Yang on 2/11/15.
//  Copyright (c) 2015 Location. All rights reserved.
//
//  The DataTabViewController is the tab bar view which contains four sub tab showing Stress, Sleep, Social, and Activity. It is the landing view of the app, and it also sets up sensor instances including GPS, Bluetooth, Microphone,Accelerameter, and other house keeping instances including Lock&Unlock state, database, server,and PAM study. It automatically starts all event in the background once the app is launched. The app continuously senses in the background and check each instance every certain time period. For audio input, the App does the realtime processing and only store the classifier results with are integer values. Every time when the user charges the phone, it pushes all the data to the cloud.

#import "DataTabViewController.h"

@interface DataTabViewController (){

}

@end

@implementation DataTabViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"ViewDidLoad called! @LocationViewController");
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
//    CGRect tabFrame =  self.tabBar.frame;
//    tabFrame.size.height = 20;
//    self.tabBar.frame = tabFrame;

  
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self.tabBarController.viewControllers objectAtIndex:2];
   
}

/**
 Callback method in ViewController
 */
- (void)appplicationIsActive:(NSNotification *)notification {
    NSLog(@"🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶Application Did Become Active🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶");
}


/**
 Callback method in ViewController
 */
- (void)applicationEnteredForeground:(NSNotification *)notification {
    NSLog(@"🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶Application Entered Foreground🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶");
}

/*
 * Hide the statusbar
 */
- (BOOL)prefersStatusBarHidden
{
    return NO;
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



@end
