//
//  PamSurveyViewController.m
//  Location
//
//  Created by Student student on 2/10/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "PamSurveyViewController.h"
#import "MainViewController.h"


@interface PamSurveyViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *PamStressButtons;

@end

@implementation PamSurveyViewController

#pragma mark - Setup View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PamBackground"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Only allow portrait view in this view
 */
-(BOOL)shouldAutorotate
{
    return NO;
}

/**
 Only allow portrait view in this view
 */
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - PamStudyToDatabase
/**
 Callback method of the PamStressButtons
 It records the idx of the button pressed and stores it to the database
 */
- (IBAction)PamStressButton:(id)sender {
    
    int stressLevel = (int)[self.PamStressButtons indexOfObject:sender];
    
    //Initiate Indicator singleton object
    self.indicator = [Indicators sharedInstance];
    [self.indicator setStressLevel:[NSNumber numberWithInt:stressLevel]];
    
    //Initiate the DataManager singleton object to store the data
    self.dataManager=[DataManager sharedInstance];
    [self storeToDatabase:stressLevel];
    
    NSLog(@"The idx of stress is %i", stressLevel);
}

/**
 Stores PAM survey result to the database
 */
- (void)storeToDatabase:(int)stressLevel{

    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd"];

    
    //create the entity over here and save it
    NSEntityDescription *entityDecription = [NSEntityDescription entityForName:@"PAM" inManagedObjectContext:self.dataManager.managedObjectContext];
    
    NSManagedObject *latestPam = [[NSManagedObject alloc] initWithEntity:entityDecription insertIntoManagedObjectContext:self.dataManager.managedObjectContext];
    [latestPam setValue:[NSNumber numberWithInt:stressLevel] forKey:@"stress_level"];
    
//    NSString *dateString = [df stringFromDate:[NSDate date]];
//    [latestPam setValue:dateString forKey:@"timestamp"];
    
    [latestPam setValue:[NSDate date] forKey:@"timestamp"];
    NSError *error1 = nil;
    
    if (![latestPam.managedObjectContext save:&error1]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error1, error1.localizedDescription);
    }
    
    NSLog(@"Stored the PAM data");
    
    
    //retreive the data and print it in the log
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAM" inManagedObjectContext:self.dataManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *result = [self.dataManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        if(result.count > 0 )
        {
            
            NSManagedObject *r = (NSManagedObject *)[result objectAtIndex:result.count - 1];
            NSLog(@"stress_level : %@", [r valueForKey:@"stress_level"]);
        }
    }

}



@end
