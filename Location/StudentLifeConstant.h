//
//  StudentLifeConstant.h
//  Location
//
//  Created by Aaron Jun Yang on 2/21/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "JBStringConstants.h"
#import "JBUIConstants.h"
#import "JBColorConstants.h"
#import "JBFontConstants.h"

//#ifndef Location_StudentLifeConstant_h
//#define Location_StudentLifeConstant_h
//
//#endif


//--------------------------------------------------
#pragma mark - TabBarViewControllerIndex
//--------------------------------------------------
#define SegueStressIndex 0
#define SegueSleepIndex 1
#define SegueActivityIndex 2
#define SegueSocialIndex 3

#define SegueStress @"SegueStress"
#define SegueSleep @"SegueSleep"
#define SegueActivity @"SegueActivity"
#define SegueSocial @"SegueSocial"


//--------------------------------------------------
#pragma mark - Conversation Count
//--------------------------------------------------
#define ConsecutiveConversationLength 10
#define ConsecutiveNonConversationLength 30


//--------------------------------------------------
#pragma mark - Database Attributes
//--------------------------------------------------
#define DatabaseTimeStamp @"timestamp"

#define AudioDataTable @"Audio"
#define AudioHasConversation @"has_conversation"
#define AudioClassificationTimeStamp @"timestamp"

#define ConversationDataTable @"Conversation"
#define ConversationStartTime @"start_time"
#define ConversationEndTime @"end_time"


//--------------------------------------------------
#pragma mark - Errors
//--------------------------------------------------
#define DatabaseSaveError @"Unable to save managed object context."
#define DatabaseFetchError @"Unable to fetch managed object context."


//--------------------------------------------------
#pragma mark - Social Classifier
//--------------------------------------------------
#define SocialConversationInterval 3*3600
#define SocialConversationFrequencyConstraint 10*60


//--------------------------------------------------
#pragma mark - Sleep Classifier
//--------------------------------------------------
#define SleepDetectionInterval 12*3600
#define SleepDurationHigh 10*3600
#define SleepDurationMed 8*3600
#define SleepDurationLow 6*3600
#define SleepLevelHigh 0
#define SleepLevelMed 1
#define SleepLevelLow 2


//--------------------------------------------------
#pragma mark - Stress Classifier
//--------------------------------------------------


//--------------------------------------------------
#pragma mark - Activity Classifier
//--------------------------------------------------


//--------------------------------------------------
#pragma mark - Image Name
//--------------------------------------------------
#define SocialHigh @"TabSocialHigh"
#define SocialMed @"TabSocialHigh"
#define SocialLow @"TabSocialHigh"

#define ActivityHigh @"TabActivityHigh"
#define ActivityMed @"TabActivityMed"
#define ActivityLow @"TabActivityLow"

#define Stress_0 @"Happy"
#define Stress_1 @"Neutral"
#define Stress_2 @"Stressed1"
#define Stress_3 @"Stressed2"
#define Stress_4 @"Stressed3"

#define SleepHigh @"TabSleepy"
#define SleepMed @"TabAsleep"
#define SleepLow @"TabAwake"




