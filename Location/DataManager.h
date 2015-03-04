//
//  DataManager.h
//  Location
//
//  Created by Arvind Chockalingam on 2/5/15.
//  Copyright (c) 2015 Location. All rights reserved.
//


// DataManager.h
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreMotion/CoreMotion.h>


extern NSString * const DataManagerDidSaveNotification;
extern NSString * const DataManagerDidSaveFailedNotification;

@interface DataManager : NSObject {
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (DataManager*)sharedInstance;
- (void)save;
+(NSArray *)retrieveFromLocal:(NSString *)entityName withManager:(DataManager*)dataManager;
//-(void) saveLockData;



@end