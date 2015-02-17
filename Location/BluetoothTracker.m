//
//  BluetoothTracker.m
//  Location
//
//  Created by Arvind Chockalingam on 2/8/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "BluetoothTracker.h"


@implementation BluetoothTracker

-(id) init{
    
    if(self==[super init])
    {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        self.devicesList = [[NSMutableArray alloc]init];
        self.numberOfOccurrences=[[NSMutableDictionary alloc]init];
        
        
    }
    return self;
}

#pragma mark - Start Tracking
-(void) startBluetoothTracking:(CBCentralManager *)central
{
    [central scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"180D"]] options:nil];
    
}


#pragma mark - Checking if central manager is on
-(BOOL) checkBLE:(CBCentralManager *)central
{
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
            NSLog(@"The platform/hardware doesn't support Bluetooth Low Energy.");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"The app is not authorized to use Bluetooth Low Energy.");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog( @"Bluetooth is currently powered off.");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"Bluetooth is currently powered on.");
            return TRUE;
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"Bluetooth state is unknown");
            break;
        default:
            break;
    }
    return FALSE;
}


#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSMutableArray *peripherals = [self devicesList];
    
    if(![peripherals containsObject:peripheral])
    {
        [peripherals addObject:peripheral];
        NSInteger count=1;
        [[self numberOfOccurrences] setValue:[NSNumber numberWithInteger:count]  forKey:[peripheral name]];
    }
    else
    {
        //increment the count of the device by one in the dictionary
        NSInteger inc = ((NSInteger)[[self numberOfOccurrences] valueForKey:[peripheral name]] )+1;
        [[self numberOfOccurrences] setValue:[NSNumber numberWithInteger:inc]  forKey:[peripheral name]];
    }
    [self updateDatabase:[self numberOfOccurrences]];
    
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if([self checkBLE:central])
    {
        [self startBluetoothTracking:central];
    }
}

#pragma mark - Core Data

-(void) updateDatabase:(NSMutableDictionary *)dict
{
    //create the entity over here
    for(id key in dict)
    {
        //check if the device is already in the database.
        //if yes, update or else create a new one.
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bluetooth" inManagedObjectContext:self.dataManager.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSUInteger count = [self.dataManager.managedObjectContext countForFetchRequest: fetchRequest error: &error];
        if(error){
            NSLog(@"Unable to execute fetch request.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        if(count==0)
        {
            //            [self addNewDevice:dict :key];
            NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Bluetooth" inManagedObjectContext:self.dataManager.managedObjectContext];
            
            NSManagedObject *latestReading = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.dataManager.managedObjectContext];
            
            [latestReading setValue:[dict valueForKey:key] forKey:@"name"];
            [latestReading setValue:[NSNumber numberWithInteger:1] forKey:@"count"];
            
            
            NSError *err = nil;
            if (![latestReading.managedObjectContext save:&err]) {
                NSLog(@"Unable to save managed object context.");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
            
        }
        else
        {
//            [self updateDeviceInformation];
            NSError *error2 = nil;
            NSArray *result = [self.dataManager.managedObjectContext executeFetchRequest:fetchRequest error:&error2];
            
            
            if (error)
            {
                NSLog(@"Unable to execute fetch request.");
                NSLog(@"%@, %@", error2, error2.localizedDescription);
                
            }
            else
            {
                if(result.count > 0 )
                {
                    NSManagedObject *r = (NSManagedObject *)[result objectAtIndex:0];
                    NSLog(@"name %@",[r valueForKey:@"name"]);
                }
            }
        }
    }
}

-(void) addNewDevice:(NSMutableDictionary *)dict withKey:(id)key
{
    
}

-(void) updateDeviceInformation
{
    
}
@end
