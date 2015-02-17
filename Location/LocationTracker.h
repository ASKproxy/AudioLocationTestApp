//
//  LocationTracker.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"
#import "DataManager.h"
#import "SocialViewController.h"

@interface LocationTracker : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (strong,nonatomic) NSString * accountStatus;
@property (strong,nonatomic) NSString * authKey;
@property (strong,nonatomic) NSString * device;
@property (strong,nonatomic) NSString * name;
@property (strong,nonatomic) NSString * profilePicURL;
@property (strong,nonatomic) NSNumber * userid;
@property (strong, nonatomic) UIWindow *window;


@property (strong,nonatomic) LocationShareModel * shareModel;
@property (strong,nonatomic) DataManager * dataManager;

@property (nonatomic) CLLocationCoordinate2D myLocation;

@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
- (void)stopLocationTracking;

//Core Data properties
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end
