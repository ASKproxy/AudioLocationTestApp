//
//  SocialViewController.m
//  Location
//
//  Created by Student student on 2/17/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "SocialViewController.h"

// Views
#import "JBLineChartView.h"
#import "JBChartHeaderView.h"
#import "JBLineChartFooterView.h"
#import "JBChartInformationView.h"

#define ARC4RANDOM_MAX 0x100000000

typedef NS_ENUM(NSInteger, JBLineChartLine){
    JBLineChartLineSolid,
    JBLineChartLineDashed,
    JBLineChartLineCount
};

// Numerics
//CGFloat const kJBLineChartViewControllerChartHeight = 250.0f;
CGFloat const kJBLineChartSocialViewControllerChartPortraitHeight = 100.0f;
CGFloat const kJBLineChartSocialViewControllerChartLandScapeHeight = 250.0f;

CGFloat const kJBLineChartSocialViewControllerChartPadding = 10.0f;

CGFloat const kJBLineChartSocialViewControllerChartHeaderHeight = 75.0f;
CGFloat const kJBLineChartSocialViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBLineChartSocialViewControllerChartFooterHeight = 20.0f;
CGFloat const kJBLineChartSocialViewControllerChartSolidLineWidth = 6.0f;
CGFloat const kJBLineChartSocialViewControllerChartDashedLineWidth = 2.0f;
//NSInteger const kJBLineChartViewControllerMaxNumChartPoints = 7;
NSInteger const kJBLineChartSocialViewControllerPortraitMaxNumChartPoints = 13;
NSInteger const kJBLineChartSocialViewControllerLandscapeMaxNumChartPoints = 7;


// Strings
NSString * const kJBLineChartSocialViewControllerNavButtonViewKey = @"view";






@interface SocialViewController ()<JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic, strong) JBLineChartView *lineChartView;
@property (nonatomic, strong) JBChartInformationView *informationView;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *daysOfWeek;
@property (nonatomic, strong) NSMutableArray *mutableLineChartsLandscape;
@property (nonatomic, strong) NSMutableArray *mutableLineChartsPortrait;



// Buttons
- (void)chartToggleButtonPressed:(id)sender;

// Helpers
- (void)initFakeData;
- (NSArray *)largestLineData; // largest collection of fake line data





@end

@implementation SocialViewController



static int mutableChartData_1 = {1, 2, 3, 4, 5, 6, 7};

static int mutableChartData_2 = {7, 6, 5, 4, 3, 2, 1};

//static int mutableChartData_3[] = {1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1};
static int mutableChartData_3[] = {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3};


#pragma mark - Alloc/Init

- (id)init
{
    
    self = [super init];
    if (self)
    {
                [self initFakeData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
                [self initFakeData];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
                [self initFakeData];
    }
    return self;
}

#pragma mark - Data

- (void)initFakeData
{
//    NSMutableArray *mutableLineCharts = [NSMutableArray array];
//    //    for (int lineIndex=0; lineIndex<JBLineChartLineCount; lineIndex++)
//    //    {
//    //        NSMutableArray *mutableChartData = [NSMutableArray array];
//    //        for (int i=0; i<kJBLineChartViewControllerMaxNumChartPoints; i++)
//    //        {
//    //            [mutableChartData addObject:[NSNumber numberWithFloat:((double)arc4random() / ARC4RANDOM_MAX)]]; // random number between 0 and 1
//    //        }
//    //        [mutableLineCharts addObject:mutableChartData];
//    //    }
//    
//    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//    self.deviceOrientation.orientation = deviceOrientation;
//
//    if (UIDeviceOrientationIsLandscape(deviceOrientation))
//    {
//        for (int lineIndex=0; lineIndex<JBLineChartLineCount; lineIndex++)
//        {
//            NSMutableArray *mutableChartData = [NSMutableArray array];
//            for (int i=0; i<kJBLineChartSocialViewControllerLandscapeMaxNumChartPoints; i++)
//            {
//                [mutableChartData addObject:[NSNumber numberWithFloat:((double)arc4random() / ARC4RANDOM_MAX)]]; // random number between 0 and 1
//            }
//            [mutableLineCharts addObject:mutableChartData];
//        }
//    }
//    else
//    {
//        
//        for (int lineIndex=0; lineIndex<1; lineIndex++)
//        {
//            NSMutableArray *mutableChartData = [NSMutableArray array];
//            for (int i=0; i<kJBLineChartSocialViewControllerPortraitMaxNumChartPoints; i++)
//            {
//                [mutableChartData addObject:[NSNumber numberWithInt:mutableChartData_3[i]]]; // random number between 0 and 1
//            }
//            
//            [mutableLineCharts addObject:mutableChartData];
//        }
//        
//        
//    }
//    
//    
//    
//    
//    _chartData = [NSArray arrayWithArray:mutableLineCharts];
//    //    _daysOfWeek = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
    
    _mutableLineChartsLandscape = [NSMutableArray array];
    _mutableLineChartsPortrait = [NSMutableArray array];
    
    // Init data for landscape
    for (int lineIndex=0; lineIndex<JBLineChartLineCount; lineIndex++)
    {
        NSMutableArray *mutableChartData = [NSMutableArray array];
        for (int i=0; i<kJBLineChartSocialViewControllerLandscapeMaxNumChartPoints; i++)
        {
            [mutableChartData addObject:[NSNumber numberWithFloat:((double)arc4random() / ARC4RANDOM_MAX)]]; // random number between 0 and 1
        }
        [_mutableLineChartsLandscape addObject:mutableChartData];
    }
    
    // Init data for portrait
    for (int lineIndex=0; lineIndex<1; lineIndex++)
    {
        NSMutableArray *mutableChartData = [NSMutableArray array];
        for (int i=0; i<kJBLineChartSocialViewControllerPortraitMaxNumChartPoints; i++)
        {
            [mutableChartData addObject:[NSNumber numberWithInt:mutableChartData_3[i]]]; // random number between 0 and 1
        }
        
        [_mutableLineChartsPortrait addObject:mutableChartData];
    }
    _daysOfWeek = [NSArray arrayWithObjects:@"Week 1", @"Week 2", @"Week 3", @"Week 4", @"Week 5", @"Week 6", @"Week 7", nil];
}

- (NSArray *)largestLineData
{
    NSArray *largestLineData = nil;
    for (NSArray *lineData in self.chartData)
    {
        if ([lineData count] > [largestLineData count])
        {
            largestLineData = lineData;
        }
    }
    return largestLineData;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_SocialButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"GillSans-Light" size:20.0f], UITextAttributeFont,
                                          [UIColor blackColor], UITextAttributeTextColor,
                                          [UIColor grayColor], UITextAttributeTextShadowColor,
                                          [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                          nil]
                                forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    // Singleton object
    self.deviceOrientation = [DeviceOrientation sharedDeviceOrientation];
    self.indicator = [Indicators sharedInstance];
//    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//    self.deviceOrientation.orientation = deviceOrientation;

    // By default populate portrait view
    self.lineChartView = [[JBLineChartView alloc] init];
    
    [self populatePortraitView];
    
    
    //    [self addSwipeGestureRecognizer];
    
}


/**
 Handle the device rotation action
 Portrait: only plot instant value
 Landscape: plot campus trailing values and user value
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation: fromInterfaceOrientation];
    
    
    //    [self.tabBarController.view removeFromSuperview];
    
    //    [self.view removeFromSuperview];
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation))
    {
        [self.deviceOrientation setOrientation:deviceOrientation];
        [self populateLandscapeView];
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation))
    {
        [self.deviceOrientation setOrientation:deviceOrientation];
        [self populatePortraitView];
    }
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(self.deviceOrientation.orientation)){
        
        [self populateLandscapeView];
    }else if (UIDeviceOrientationIsPortrait(self.deviceOrientation.orientation)){
        [self populatePortraitView];
        
    }
    
    [self.lineChartView setState:JBChartViewStateExpanded];
}


#pragma mark - Gesture
/**
 Callback action of swipe gesture
 */
- (void)didSwipe: (UISwipeGestureRecognizer *) sender{
    
    UISwipeGestureRecognizerDirection direction = sender.direction;
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            [self.tabBarController setSelectedIndex:selectedIndex + 1];
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            [self.tabBarController setSelectedIndex:selectedIndex - 1];
            break;
    }
}

- (void)addSwipeGestureRecognizer{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
}

#pragma mark - Populate View

- (void)populatePortraitView{
    self.view.backgroundColor = kJBColorLineChartControllerBackground;
    self.navigationItem.rightBarButtonItem = [self chartToggleButtonWithTarget:self action:@selector(chartToggleButtonPressed:)];
    
//    
//    //    self.lineChartView = [[JBLineChartView alloc] init];
//    [self initFakeData];
//    
//    
    
    // Data
    _chartData = [NSArray arrayWithArray:_mutableLineChartsPortrait];
    
    self.lineChartView.frame = CGRectMake(kJBLineChartSocialViewControllerChartPadding, kJBLineChartSocialViewControllerChartPadding+250, self.view.bounds.size.width - (kJBLineChartSocialViewControllerChartPadding * 2), kJBLineChartSocialViewControllerChartPortraitHeight);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = kJBLineChartSocialViewControllerChartHeaderPadding;
    self.lineChartView.backgroundColor = kJBColorLineChartBackground;
    
    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBLineChartSocialViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartSocialViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBLineChartSocialViewControllerChartPadding * 2), kJBLineChartSocialViewControllerChartHeaderHeight)];
    
    self.lineChartView.headerView = headerView;
    self.lineChartView.headerView = nil;
    
    self.lineChartView.footerView = nil;
    
    [self.view addSubview:self.lineChartView];
    
    
    
    [self.lineChartView reloadData];
    
    [self addAnimalImage];
    
}

- (void)populateLandscapeView{
    self.view.backgroundColor = kJBColorLineChartControllerBackground;
    self.navigationItem.rightBarButtonItem = [self chartToggleButtonWithTarget:self action:@selector(chartToggleButtonPressed:)];
    
//    //    self.lineChartView = [[JBLineChartView alloc] init];
//    [self initFakeData];
    
    
    
    // Data
    _chartData = [NSArray arrayWithArray:_mutableLineChartsLandscape];
    
    self.lineChartView.frame = CGRectMake(kJBLineChartSocialViewControllerChartPadding, kJBLineChartSocialViewControllerChartPadding, self.view.bounds.size.width - (kJBLineChartSocialViewControllerChartPadding * 2), kJBLineChartSocialViewControllerChartLandScapeHeight);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = kJBLineChartSocialViewControllerChartHeaderPadding;
    self.lineChartView.backgroundColor = kJBColorLineChartBackground;
    
    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBLineChartSocialViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartSocialViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBLineChartSocialViewControllerChartPadding * 2), kJBLineChartSocialViewControllerChartHeaderHeight)];
    headerView.titleLabel.text = [NSString stringWithFormat:@"%@ %@", [termWinter uppercaseString], year2015];
    headerView.titleLabel.textColor = kJBColorLineChartHeader;
    headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    //    headerView.subtitleLabel.text = kJBStringLabel2013;
    //    headerView.subtitleLabel.textColor = kJBColorLineChartHeader;
    //    headerView.subtitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    //    headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.separatorColor = kJBColorLineChartHeaderSeparatorColor;
    self.lineChartView.headerView = headerView;
    
    JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(kJBLineChartSocialViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartSocialViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kJBLineChartSocialViewControllerChartPadding * 2), kJBLineChartSocialViewControllerChartFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.text = [[self.daysOfWeek firstObject] uppercaseString];
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = [[self.daysOfWeek lastObject] uppercaseString];;
    footerView.rightLabel.textColor = [UIColor whiteColor];
    footerView.sectionCount = [[self largestLineData] count];
    self.lineChartView.footerView = footerView;
    
    
    [self.view addSubview:self.lineChartView];
    
    //    self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 9  ), kJBLineChartViewControllerChartPadding, kJBLineChartViewControllerChartPadding * 8, kJBLineChartViewControllerChartLandScapeHeight)];
    //    [self.informationView setValueAndUnitTextColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
    //    [self.informationView setTitleTextColor:kJBColorLineChartHeader];
    //    [self.informationView setTextShadowColor:nil];
    //    [self.informationView setSeparatorColor:kJBColorLineChartHeaderSeparatorColor];
    //    [self.view addSubview:self.informationView];
    
    [self.lineChartView reloadData];
    
}


//- (void)addAnimalImage{
//    //    UIImage *image = [[UIImage alloc] init];
//    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(100, 280, 250, 250)];
//    [iv setImage:[UIImage imageNamed:@"TabSocial"]];
//    [self.view addSubview:iv];
//}

- (void)addAnimalImage{
    //    UIImage *image = [[UIImage alloc] init];
    //    NSInteger level = [self getStressHeight];
    int level = (int)[self.indicator getSocialLevel];
    //UIImageView *iv;
    NSInteger temp = ((level+1)*self.indicator.screenHeight/7) - 50;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(150, temp, 150, 150)];
    //NSInteger height = (level+1)*screenHeight/
    
    switch (level) {
        case 0:
            //temp = ((5-level)*screenHeight/5)-50;
            //iv = [[UIImageView alloc] initWithFrame:CGRectMake(150, temp, 150, 150)];
            [iv setImage:[UIImage imageNamed:SocialHigh]];
            [self.view addSubview:iv];
            break;
            
        case 1:
            //iv = [[UIImageView alloc] initWithFrame:CGRectMake(150, 50, 150, 150)];
            [iv setImage:[UIImage imageNamed:SocialMed]];
            [self.view addSubview:iv];
            break;
            
        case 2:
            [iv setImage:[UIImage imageNamed:SocialMed]];
            [self.view addSubview:iv];
            break;
            
        case 3:
            [iv setImage:[UIImage imageNamed:SocialLow]];
            [self.view addSubview:iv];
            break;
            
        case 4:
            [iv setImage:[UIImage imageNamed:SocialLow]];
            [self.view addSubview:iv];
            break;
            
        default:
            break;
    }
    
    //    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(150, 50, 150, 150)];
    //    [iv setImage:[UIImage imageNamed:@"Stressed3"]];
    //    [self.view addSubview:iv];
}



#pragma mark - JBChartViewDataSource

- (BOOL)shouldExtendSelectionViewIntoHeaderPaddingForChartView:(JBChartView *)chartView
{
    return YES;
}

- (BOOL)shouldExtendSelectionViewIntoFooterPaddingForChartView:(JBChartView *)chartView
{
    return NO;
}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    
    //    NSLog(@"chartData length: %d", [self.chartData count]);
    return [self.chartData count];
    
    
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    
    //    NSLog(@"chartData at %d length: %d", lineIndex, [[self.chartData objectAtIndex: lineIndex ]count]);
    return [[self.chartData objectAtIndex:lineIndex] count];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return lineIndex == JBLineChartViewLineStyleDashed;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
    return lineIndex == JBLineChartViewLineStyleSolid;
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [[[self.chartData objectAtIndex:lineIndex] objectAtIndex:horizontalIndex] floatValue];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)){
        
        NSNumber *valueNumber = [[self.chartData objectAtIndex:lineIndex] objectAtIndex:horizontalIndex];
        [self.informationView setValueText:[NSString stringWithFormat:@"%.2f", [valueNumber floatValue]] unitText:kJBStringLabelMm];
        [self.informationView setTitleText:lineIndex == JBLineChartLineSolid ? kJBStringLabelMetropolitanAverage : kJBStringLabelNationalAverage];
        [self.informationView setHidden:NO animated:YES];
        [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
        [self.tooltipView setText:[[self.daysOfWeek objectAtIndex:horizontalIndex] uppercaseString]];
    }else if (UIDeviceOrientationIsPortrait(deviceOrientation)){
        [self.informationView setHidden:YES animated:NO];
        [self setTooltipVisible:NO animated:NO];
        
    }
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    [self.informationView setHidden:YES animated:YES];
    [self setTooltipVisible:NO animated:YES];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidLineColor: kJBColorLineChartDefaultDashedLineColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidLineColor: kJBColorLineChartDefaultDashedLineColor;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? kJBLineChartSocialViewControllerChartSolidLineWidth: kJBLineChartSocialViewControllerChartDashedLineWidth;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? 0.0: (kJBLineChartSocialViewControllerChartDashedLineWidth * 4);
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView verticalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidSelectedLineColor: kJBColorLineChartDefaultDashedSelectedLineColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidSelectedLineColor: kJBColorLineChartDefaultDashedSelectedLineColor;
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? JBLineChartViewLineStyleSolid : JBLineChartViewLineStyleDashed;
}

#pragma mark - Buttons

- (void)chartToggleButtonPressed:(id)sender
{
    UIView *buttonImageView = [self.navigationItem.rightBarButtonItem valueForKey:kJBLineChartSocialViewControllerNavButtonViewKey];
    buttonImageView.userInteractionEnabled = NO;
    
    CGAffineTransform transform = self.lineChartView.state == JBChartViewStateExpanded ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    buttonImageView.transform = transform;
    
    [self.lineChartView setState:self.lineChartView.state == JBChartViewStateExpanded ? JBChartViewStateCollapsed : JBChartViewStateExpanded animated:YES callback:^{
        buttonImageView.userInteractionEnabled = YES;
    }];
}

#pragma mark - Overrides

- (JBChartView *)chartView
{
    return self.lineChartView;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
