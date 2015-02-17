//
//  BluetoothTracker.h
//  Location
//
//  Created by Arvind Chockalingam on 2/8/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DataManager.h"

@interface BluetoothTracker : NSObject<CBCentralManagerDelegate>


@property (strong,nonatomic) DataManager * dataManager;
@property (strong,nonatomic) CBCentralManager *centralManager;
@property (strong,nonatomic) NSMutableArray *devicesList;

//used to store the number of times each device was seen
@property (strong,nonatomic) NSMutableDictionary *numberOfOccurrences;


-(void) startBluetoothTracking:(CBCentralManager *) central;
-(void) updateDatabase:(NSDictionary *)dict;

@end
