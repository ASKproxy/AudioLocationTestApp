//
//  AudioProcessing.h
//  Location
//
//  Created by Arvind Chockalingam on 2/15/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "kiss_fftr.h"



@interface AudioProcessing : NSObject


#pragma mark - singleton 
+(AudioProcessing*)sharedAudioProcessing;


-(void) normalizeData:(float *)buffer;

-(void) processAudio:(float *)frameBuffer;

-(void) initVoicedFeaturesFunction;
@end
