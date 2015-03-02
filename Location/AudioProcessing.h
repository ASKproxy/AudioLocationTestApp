//
//  AudioProcessing.h
//  Location
//
//  Created by Arvind Chockalingam on 2/15/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "kiss_fftr.h"
#import "StudentLifeConstant.h"
#import "DataManager.h"
#import "EZAudio.h"



@interface AudioProcessing : NSObject


#pragma mark - Properties
/**
 A signleton object of EZMicrophone
 The project only keeps one EZMicrophone object
 */
@property (strong, nonatomic) EZMicrophone *ezMicrophone;

@property (strong,nonatomic) DataManager * dataManager;
@property(nonatomic) NSInteger consecutiveConCount;
@property(nonatomic) NSInteger consecutiveSilCount;
@property(nonatomic) BOOL previousState;
@property(nonatomic) BOOL isConversation;
@property(nonatomic) NSMutableArray* tempAudioClassification;
@property(nonatomic) NSMutableArray* tempAudioTimestamp;

@property(nonatomic) BOOL startTimer;



#pragma mark - singleton 
+(AudioProcessing*)sharedAudioProcessing;


-(void) normalizeData:(float *)buffer;

-(void) processAudio:(float *)frameBuffer;

-(void) initVoicedFeaturesFunction;


/**
 Return the ratio of total conversation duration in the past x hours
 */
+(double) conversationDuration;

/**
 Return the conversation frequency score in the past x hours
 */
+(double) conversationFreq;

@end
