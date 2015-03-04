//
//  WrapperJson.h
//  Location
//
//  Created by Arvind Chockalingam on 3/4/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityJson.h"

@interface WrapperJson : NSObject<NSCoding>


@property NSString* timestamp;
@property NSMutableArray *dataList;

- (NSMutableDictionary *)toNSDictionary;

@end
