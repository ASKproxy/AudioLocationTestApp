//
//  Server.m
//  Location
//
//  Created by Arvind Chockalingam on 2/27/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "Server.h"

#define safeSet(d,k,v) if (v) d[k] = v;

static NSString* const serverURL = @"http://192.168.1.102:3000/";
static NSString* const userName = @"arvind";
static NSString* const collectionName = @"act_level";
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
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd"];
    NSString *strDate=[df stringFromDate:[NSDate date]];
    
    NSString* parameters=[NSString stringWithFormat:@"campus_activity?date=%@",strDate];
    NSString* requestUrl=[serverURL stringByAppendingString:parameters];
    NSURL* url = [NSURL URLWithString:requestUrl]; //1
    
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
    for (NSObject* item in locations) {

        NSLog(@"average : %@",item);
//        NSMutableDictionary *locations = [NSMutableDictionary new];
//        [locations setValue:item[@"longitude"] forKey:@"longitude"];
//        NSLog(@"longitude : %@",locations);
    }
    
}


-(void) storeDummyData
{
   
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd"];
    
    //create the entity over here
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:self.dataManager.managedObjectContext];
    
    NSManagedObject *latestValue;
    
    for(int i=1;i<8;i++)
    {
        latestValue = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.dataManager.managedObjectContext];
        [latestValue setValue:[NSNumber numberWithInt:i*5] forKey:@"activity"];
        [latestValue setValue:[df stringFromDate:[NSDate date]] forKey:@"timestamp"];
        [latestValue setValue:[NSNumber numberWithInt:i] forKey:@"period"];
    
        NSError *saveError = nil;
    
        if (![latestValue.managedObjectContext save:&saveError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", saveError, saveError.localizedDescription);
        }
    
    }
    
    
    
}






#pragma mark - RESTFUL API


-(void) getCampusAverageActivity
{
    
    NSString* destination = [serverURL stringByAppendingPathComponent:@"campus_activity"];
    NSURL *url= [NSURL URLWithString:destination];

    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd"];
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setValue:[df stringFromDate:[NSDate date]] forKey:@"timestamp"];
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dictionary
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    
    if ([jsonData length] > 0 &&
        error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON String = %@", jsonString);
    }
    else if ([jsonData length] == 0 &&
             error == nil){
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil){
        NSLog(@"An error happened = %@", error);
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
//Used to send the daily averages to the server
-(void) httpPostRequestAverage:(double)average to:(NSURL *)url
{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd"];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setValue:[NSNumber numberWithDouble:average] forKey:@"average"];
    [dictionary setValue:[df stringFromDate:[NSDate date]] forKey:@"timestamp"];
    [dictionary setValue:@"arvind" forKey:@"user"];
 
    NSError *error = nil;

    
    //its because of the dictionary object we have to create differently that we have two different post methods
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dictionary
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    
    if ([jsonData length] > 0 &&
        error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON String = %@", jsonString);
    }
    else if ([jsonData length] == 0 &&
             error == nil){
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil){
        NSLog(@"An error happened = %@", error);
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



// Create the NSData from the Wrapper object and send the POST request to the server. Used to send all the logs to the server
-(void) httpPostRequestLogs:(WrapperJson *)jsonObject to:(NSURL *)url
{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:[jsonObject toNSDictionary]
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    
    if ([jsonData length] > 0 &&
        error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON String = %@", jsonString);
    }
    else if ([jsonData length] == 0 &&
             error == nil){
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil){
        NSLog(@"An error happened = %@", error);
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


#pragma mark - Sleep

-(void) pushSleepAverage:(int) average
{
    
    NSString* destination = [serverURL stringByAppendingPathComponent:@"sleep_average"];
    NSURL *url= [NSURL URLWithString:destination];
    [self httpPostRequestAverage:average to:url];
    
}


#pragma mark - Stress

-(void) pushStress:(NSArray *)records
{
    NSString* destination = [serverURL stringByAppendingPathComponent:@"stress_level"];
    NSURL *url= [NSURL URLWithString:destination];

    //make sure this is the same as the format in which the
    //the timestamp was stored in core data
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd"];
    
    WrapperJson *jsonObject=[self customJSONforStress:records];
    
    //setup POST request
    [self httpPostRequestLogs:jsonObject to:url];
}


-(WrapperJson *) customJSONforStress:(NSArray *)records
{
  
    int i=1;
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString = [df stringFromDate:[NSDate date]];
    
    
    NSMutableArray *dataList = [[NSMutableArray alloc]init];
    
    for(NSObject* entry in records)
    {
        StressJSON *stress=[[StressJSON alloc]initWithCode:[[entry valueForKey:@"stress_level"]intValue] period:i userName:@"arvind"];
        
        [dataList addObject:stress];
    }
    
    WrapperJson* wrapper=[[WrapperJson alloc]init];
    wrapper.timestamp=dateString;
    wrapper.dataList=dataList;
    
    return wrapper;
    
}


#pragma mark - Activity

-(void) pushActivityAverage:(double) average
{
    
    NSString* destination = [serverURL stringByAppendingPathComponent:@"activity_average"];
    NSURL *url= [NSURL URLWithString:destination];
    [self httpPostRequestAverage:average to:url];

}

-(void) persist
{
    
    NSString* destination = [serverURL stringByAppendingPathComponent:@"act_level"];
    NSURL *url= [NSURL URLWithString:destination];
    
    //make sure this is the same as the format in which the
    //the timestamp was stored in core data
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd"];
    
    
    WrapperJson *jsonObject=[self customJSONforActivity];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:[jsonObject toNSDictionary]
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    

    if ([jsonData length] > 0 &&
        error == nil){
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData
//                                                     encoding:NSUTF8StringEncoding];
//        NSLog(@"JSON String = %@", jsonString);
    }
    else if ([jsonData length] == 0 &&
             error == nil){
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil){
        NSLog(@"An error happened = %@", error);
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



/**
 CustomJSON
Creates a customized JSON object to send to the server. The built in 
NSJSONSERIALIZATION class created a JSON that wasn't readable by 
 the nodejs script. This class converts the dictionary to a readable
 json object. 
 
 The method for creating this JSON element is referenced from :
 http://www.mysamplecode.com/2013/04/convert-custom-ios-object-to-json-string.html
 
 */

-(WrapperJson *) customJSONforActivity
{
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString = [df stringFromDate:[NSDate date]];

    
    NSMutableArray *dataList = [[NSMutableArray alloc]init];
    NSArray *result = [DataManager retrieveFromLocal:@"Activity" withManager:self.dataManager];
    
    for(NSObject* entry in result)
    {
        
        ActivityJson* activity=[[ActivityJson alloc]initWithCode:[[entry valueForKey:@"activity"]intValue] period:[[entry valueForKey:@"period"]intValue] userName:@"xyz"];
        
        [dataList addObject:activity];
    }
    
    WrapperJson* wrapper=[[WrapperJson alloc]init];
    wrapper.timestamp=dateString;
    wrapper.dataList=dataList;
    
    return wrapper;
    
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
