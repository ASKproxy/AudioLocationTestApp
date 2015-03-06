//
//  Indicators.h
//  Location
//
//  Created by Aaron Jun Yang on 3/3/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Indicators : NSObject

#pragma mark - Property
@property (strong,nonatomic)NSNumber *activityLevel;
@property (strong,nonatomic)NSNumber *sleepLevel;
@property (strong,nonatomic)NSNumber *socialLevel;
@property (strong,nonatomic)NSNumber *stressLevel;

@property (strong,nonatomic)NSNumber *campusActivity;
@property (strong,nonatomic)NSNumber *campusSleep;
@property (strong,nonatomic)NSNumber *campusSocial;
@property (strong,nonatomic)NSNumber *campusStress;

@property (nonatomic)CGRect screenRect;
@property (nonatomic)CGFloat screenWidth;
@property (nonatomic)CGFloat screenHeight;

#pragma mark - Shared instance
+ (Indicators*)sharedInstance;


#pragma mark - Setter and Getter
/**
 Return current device screen width
 */
-(CGFloat) getScreenWidth;

-(void) setScreenWidth:(CGFloat)screenWidth;

/**
 Return current device screen height
 */
-(CGFloat) getScreenHeight;

-(void) setScreenHeight:(CGFloat)screenHeight;


/**
 Get stress level for ploting puffer fish in the portrait view
 return NSInteger
 */
-(NSInteger) getStressLevel;

/**
 Set stress level, this method gets called in the PamSurveyViewController
 when the user picks a puffer fish indicating the user's current mood
 */
-(void) setStressLevel:(NSNumber *)stressLevel;

/**
 Get sleep level for ploting sea horse in the portrait view
 return NSInteger
 */
-(NSInteger) getSleepLevel;

/**
 Set sleep level
 */
-(void) setSleepLevel:(NSNumber *)sleepLevel;

/**
 Get social level for ploting whale in the portrait view
 return NSInteger
 */
-(NSInteger) getSocialLevel;

/**
 Set social level
 */
-(void) setSocialLevel:(NSNumber *)socialLevel;

/**
 Get activity level for ploting squid in the portrait view
 return NSInteger
 */
-(NSInteger) getActivityLevel;

/**
 Set activity level
 */
-(void) setActivityLevel:(NSNumber *)activityLevel;


/**
 Get campus activity average
 return NSInteger
 */
-(NSInteger) getCampusActivity;

/**
 Set campus activity average
 */
-(void) setCampusActivity:(NSNumber *)campusActivity;


/**
 Get campus sleep average
 return NSInteger
 */
-(NSInteger) getCampusSleep;

/**
 Set campus sleep average
 */
-(void) setCampusSleep:(NSNumber *)campusSleep;

/**
 Get campus social average
 return NSInteger
 */
-(NSInteger) getCampusSocial;

/**
 Set campus social average
 */
-(void) setCampusSocial:(NSNumber *)campusSocial;


/**
 Get campus stress average
 return NSInteger
 */
-(NSInteger) getCampusStress;

/**
 Set campus stress average
 */
-(void) setCampusStress:(NSNumber *)campusStress;

@end
