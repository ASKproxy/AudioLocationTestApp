//
//  Server.m
//  Location
//
//  Created by Arvind Chockalingam on 2/27/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "Server.h"

#define safeSet(d,k,v) if (v) d[k] = v;

static NSString* const serverURL = @"http://10.31.250.246:3000/";
static NSString* const userName = @"arvind";
static NSString* const collectionName = @"pam";
static NSString* const kFiles = @"files";


@implementation Server
- (NSDictionary*) toDictionary:(NSManagedObject*)object
{
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"name", [object valueForKey:@"stress_level"]);
    return jsonable;
}
-(id) init
{
    if(self == [super init])
    {
    _objects=[[NSMutableArray alloc] init];
    self.dataManager=[DataManager sharedInstance];
    }
    return self;
}

/**
 Setup methond which calls all the individual helper
 method to initialize sensors
 */
+ (Server *)setupServer{
    static Server *_server = nil;
    
    //New thread for SetupSensors object
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _server = [[Server alloc] init];
        
    });
    
    
    return _server;
}


- (void)import
{
    NSURL* url = [NSURL URLWithString:[serverURL stringByAppendingPathComponent:collectionName]]; //1
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET"; //2
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"]; //3
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration]; //4
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]; //6
            [self parseAndAddLocations:responseArray toArray:self.objects]; //7
        }
    }];
    
    [dataTask resume]; //8
}

-(void) parseAndAddLocations:(NSArray *)locations toArray:(NSMutableArray*)destinationArray
{
    for (NSDictionary* item in locations) {

        NSMutableDictionary *locations = [NSMutableDictionary new];
        [locations setValue:item[@"longitude"] forKey:@"longitude"];
        NSLog(@"longitude : %@",locations);
    }
    
}


-(void) persist
{
    
    NSString* destination = [serverURL stringByAppendingPathComponent:@"pam"];
//    destination = [destination stringByAppendingPathComponent:collectionName];
    
    
    NSURL *url= [NSURL URLWithString:destination];
    
    //make sure this is the same as the format in which the
    //the timestamp was stored in core data
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd"];
    
    
    
    NSArray *result = [DataManager retrieveFromLocal:@"PAM" withManager:self.dataManager];
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary new];

    for(NSDictionary* entry in result)
    {
        NSString *dateString = [df stringFromDate:[entry valueForKey:@"timestamp"]];
        [jsonDictionary setValue:[entry valueForKey:@"stress_level"] forKey:dateString];
    }
    
    
    NSData *jsonData ;
    NSString *jsonString;
    if([NSJSONSerialization isValidJSONObject:jsonDictionary])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];

    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (!error) {
            
            NSLog(@"pushed to %@",collectionName);
        }
    }];
    [dataTask resume];
    
}

// we dont need to worry about updating any of the
//records since we will only be posting and retrieving
//values
- (void) persistTest
{
    
    NSString* destination = [serverURL stringByAppendingPathComponent:collectionName];
    
    NSURL *url= [NSURL URLWithString:destination];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod =  @"POST";
    
    
    //create the entity over here and save it
    NSEntityDescription *entityDecription = [NSEntityDescription entityForName:@"PAM" inManagedObjectContext:self.dataManager.managedObjectContext];
    
    NSManagedObject *latestPam = [[NSManagedObject alloc] initWithEntity:entityDecription insertIntoManagedObjectContext:self.dataManager.managedObjectContext];
    [latestPam setValue:[NSNumber numberWithInt:1] forKey:@"stress_level"];
    
    NSError *error1 = nil;
    
    if (![latestPam.managedObjectContext save:&error1]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error1, error1.localizedDescription);
    }
    
    NSLog(@"Stored the PAM data");

    
    NSArray *result = [DataManager retrieveFromLocal:@"PAM" withManager:self.dataManager];
    NSManagedObject *r = (NSManagedObject *)[result objectAtIndex:result.count - 1];
    
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:[self toDictionary:r] options:0 error:NULL]; //3
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; //4
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (!error) {

            NSLog(@"pushed to %@",collectionName);
        }
    }];
    [dataTask resume];
}

@end
