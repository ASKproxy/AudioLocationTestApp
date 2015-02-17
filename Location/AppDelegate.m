//
//  LocationAppDelegate.m
//  StudentLife
//
//  Created by Aaron Jun Yang
//  Copyright (c) 2014 Location. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "PamSurveyViewController.h"


@implementation AppDelegate
//@synthesize gLockComplete, gLockState;

/*
 * Call back function to print log for lock event
 */
static void displayStatusChanged(CFNotificationCenterRef center,
                                 void *observer,
                                 CFStringRef name,
                                 const void *object,
                                 CFDictionaryRef userInfo) {
    
    // Lock state change
    //"com.apple.springboard.lockcomplete" notification will always come after the "com.apple.springboard.lockstate"
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisplayStatusLocked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Change the corresponding state variables everytime receving a new notification
    if(name== CFSTR("com.apple.springboard.lockstate")){
        gLockState = 1;
    }else if(name== CFSTR("com.apple.springboard.lockcomplete")){
        gLockComplete = 1;
    }
    
    // When lockState and lockComplete are both 1, that is when the phone is locked, then start recording
    // Otherwise stop recording
    if(gLockComplete && gLockState){
        NSLog(@"🔔*****Start recording!*****🔔");
        
        [setupSensors.ezMicrophone startFetchingAudio];
        NSLog(@"******************Microphone is %i******************* in appdelegate", setupSensors.ezMicrophone.microphoneOn);

        NSLog(@"📀LockState: %li, LockComplete: %li📀", (long)gLockState, (long)gLockComplete);

        // Restore states value
        gLockComplete = 0;
        gLockState = 0;
        
    }else if(!gLockComplete && gLockState){
        NSLog(@"🔕Phone wake up, ready to stop recording!🔕");
        
        [setupSensors.ezMicrophone stopFetchingAudio];
        NSLog(@"******************Microphone is %i******************* in appdelegate", setupSensors.ezMicrophone.microphoneOn);
        
        NSLog(@"📀LockState: %li, LockComplete: %li📀", (long)gLockState, (long)gLockComplete);
        
        // Restore states value
        gLockState = 0;
    }
    
    
    if (userInfo != nil) {
        CFShow(userInfo);
    }
    
}

/*
 * Add notification observer to listen for system notification of 
 * "lockstate" : when lock or unlock phone, system sends out the notification
 * "lockcomplete" : when lock phone, system sends out the notification
 * "hasBlankedScreen" : when screen is black, system sends out the notification
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    //---------------------------------------
    // Setup sensors
    setupSensors = [SetupSensors sharedSetupSensors];
    //---------------------------------------
    
    //---------------------------------------
    // Initial value to indicate lock status
    gLockComplete = 0;
    gLockState=0;
    //---------------------------------------
    
    
    //---------------------------------------
    // Handle launching from a notification
    UILocalNotification *localNotification =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
        
        //Direct to PAM survey view
        PamSurveyViewController *PamViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"PamSurveyViewController"];
        [self.window setRootViewController:PamViewController];
        //        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    //---------------------------------------

    
    // Add lockstate notification observer
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    displayStatusChanged,
                                    CFSTR("com.apple.springboard.lockstate"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    // Add lockcomplete notification observer
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    displayStatusChanged,
                                    CFSTR("com.apple.springboard.lockcomplete"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    displayStatusChanged,
                                    CFSTR("com.apple.springboard.hasBlankedScreen"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisplayStatusLocked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
//    NSLog(@"application has become active again!! @didFinishLaunchingWithOptions");
    
    return YES;

}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [setupSensors.ezMicrophone stopFetchingAudio];
    NSLog(@"********Microphone is %i in applicationWillResignActive*****************", setupSensors.ezMicrophone.microphoneOn);

    NSLog(@"locked! @applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{    
    NSLog(@"application entered background @applicationDidEnterBackground!");

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisplayStatusLocked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"application has entered foreground again! @pplicationWillEnterForeground");    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"application has become active again!! @applicationDidBecomeActive");
    

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"application will terminate! @applicationWillTerminate:");
}

/**
 Handling a local notification when an app is already running
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //My_specificViewController
    PamSurveyViewController *PamViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"PamSurveyViewController"];
    [self.window setRootViewController:PamViewController];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


@end