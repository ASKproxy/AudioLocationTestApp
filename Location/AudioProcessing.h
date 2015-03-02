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




@interface AudioProcessing : NSObject

@property (strong,nonatomic) DataManager * dataManager;
@property(nonatomic) NSInteger consecutiveConCount;
@property(nonatomic) NSInteger consecutiveSilCount;
@property(nonatomic) BOOL previousState;
@property(nonatomic) BOOL isConversation;


#pragma mark - singleton 
+(AudioProcessing*)sharedAudioProcessing;


-(void) normalizeData:(float *)buffer;

-(void) processAudio:(float *)frameBuffer;

-(void) initVoicedFeaturesFunction;

+(double) conversationDuration;

+(double) conversationFreq;

@end
