//
//  DataManager.m
//  Location
//
//  Created by Arvind Chockalingam on 2/5/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

// DataManager.m
#import "DataManager.h"


@interface DataManager ()

@end

@implementation DataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (DataManager*)sharedInstance {
    static dispatch_once_t pred;
    static DataManager *sharedInstance = nil;
    
    dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

-(id)init{
    if (self = [super init]) {
        NSLog(@"initializing the data manager");
    }
    return self;
}

-(void)save
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//-(void) saveDataToDatabase:(id)unknownTypeParameter {
//    if( [unknownTypeParameter isKindOfClass:[CMAccelerometerData class]]) {
//        CMAcceleration *acceleration = (__bridge CMAcceleration*) unknownTypeParameter;
//        
//        //create the entity over here and save it
//        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Accelerometer" inManagedObjectContext:self.managedObjectContext];
//        
//        NSManagedObject *latestAccelerometer = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
//        [latestAccelerometer setValue:[NSNumber numberWithDouble:acceleration->x] forKey:@"x_axis"];
//        [latestAccelerometer setValue:[NSNumber numberWithDouble:acceleration->y] forKey:@"y_axis"];
//        [latestAccelerometer setValue:[NSNumber numberWithDouble:acceleration->z] forKey:@"z_axis"];
//        
//        NSError *error1 = nil;
//        
//        if (![latestAccelerometer.managedObjectContext save:&error1]) {
//            NSLog(@"Unable to save managed object context.");
//            NSLog(@"%@, %@", error1, error1.localizedDescription);
//        }
//        
//        NSLog(@"Stored the accelerometer data");
//        
//        
//        //retreive the data and print it in the log
//        NSError *error = nil;
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accelerometer" inManagedObjectContext:self.managedObjectContext];
//        [fetchRequest setEntity:entity];
//        
//        NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//        
//        if (error) {
//            NSLog(@"Unable to execute fetch request.");
//            NSLog(@"%@, %@", error, error.localizedDescription);
//            
//        } else {
//            if(result.count > 0 )
//            {
//                
//                NSManagedObject *r = (NSManagedObject *)[result objectAtIndex:result.count - 1];
//                
//                NSLog(@"x-axis : %@", [r valueForKey:@"x_axis"]);
//                
//                //            NSLog(@"result count : %lu  LATITUDE : %@", (unsigned long)[result count],[r valueForKey:@"latitude"]);
//            }
//        }
//
//   
//    }
//}
//

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LocalData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSLog(@"the url is : %@",modelURL);
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ProjectName.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end