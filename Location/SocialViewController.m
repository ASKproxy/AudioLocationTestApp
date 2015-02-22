//
//  SocialViewController.m
//  Location
//
//  Created by Student student on 2/17/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "SocialViewController.h"

@interface SocialViewController ()

@end

@implementation SocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.GPSLat.text = @"haha";
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLabelValue:) name:@"sendLocationDataUpdateUI" object:nil];
    
    
    
    //Add Swipe gesture recognizer
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    

}

/**
 Callback action of swipe gesture
 */
- (void)didSwipe: (UISwipeGestureRecognizer *) sender{
    
    UISwipeGestureRecognizerDirection direction = sender.direction;
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            [self.tabBarController setSelectedIndex:selectedIndex + 1];
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            [self.tabBarController setSelectedIndex:selectedIndex - 1];
            break;
    }
}

//-(void)changeLabelValue(NSNotification *)iRecognizer {
//    
//    UITextField *myTextField = iRecognizer object];
//    
//    //Here You can change the value of label
//}


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
