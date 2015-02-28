//
//  StressViewController.m
//  Location
//
//  Created by Student student on 2/21/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "StressViewController.h"

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
CGFloat const kJBLineChartViewControllerChartPortraitHeight = 100.0f;
CGFloat const kJBLineChartViewControllerChartLandScapeHeight = 250.0f;

CGFloat const kJBLineChartViewControllerChartPadding = 10.0f;

CGFloat const kJBLineChartViewControllerChartHeaderHeight = 75.0f;
CGFloat const kJBLineChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBLineChartViewControllerChartFooterHeight = 20.0f;
CGFloat const kJBLineChartViewControllerChartSolidLineWidth = 6.0f;
CGFloat const kJBLineChartViewControllerChartDashedLineWidth = 2.0f;
//NSInteger const kJBLineChartViewControllerMaxNumChartPoints = 7;
NSInteger const kJBLineChartViewControllerPortraitMaxNumChartPoints = 13;
NSInteger const kJBLineChartViewControllerLandscapeMaxNumChartPoints = 7;


// Strings
NSString * const kJBLineChartViewControllerNavButtonViewKey = @"view";

@interface StressViewController ()<JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic, strong) JBLineChartView *lineChartView;
@property (nonatomic, strong) JBChartInformationView *informationView;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *daysOfWeek;



// Buttons
- (void)chartToggleButtonPressed:(id)sender;

// Helpers
- (void)initFakeData;
- (NSArray *)largestLineData; // largest collection of fake line data


@end

@implementation StressViewController



static int mutableChartData_1 = {1, 2, 3, 4, 5, 6, 7};

static int mutableChartData_2 = {7, 6, 5, 4, 3, 2, 1};

static int mutableChartData_3[] = {1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1};


#pragma mark - Alloc/Init

- (id)init
{
    
    self = [super init];
    if (self)
    {
//        [self initFakeData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
//        [self initFakeData];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
//        [self initFakeData];
    }
    return self;
}

#pragma mark - Data

- (void)initFakeData
{
    NSMutableArray *mutableLineCharts = [NSMutableArray array];
//    for (int lineIndex=0; lineIndex<JBLineChartLineCount; lineIndex++)
//    {
//        NSMutableArray *mutableChartData = [NSMutableArray array];
//        for (int i=0; i<kJBLineChartViewControllerMaxNumChartPoints; i++)
//        {
//            [mutableChartData addObject:[NSNumber numberWithFloat:((double)arc4random() / ARC4RANDOM_MAX)]]; // random number between 0 and 1
//        }
//        [mutableLineCharts addObject:mutableChartData];
//    }
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation))
    {
        for (int lineIndex=0; lineIndex<JBLineChartLineCount; lineIndex++)
                {
                    NSMutableArray *mutableChartData = [NSMutableArray array];
                    for (int i=0; i<kJBLineChartViewControllerLandscapeMaxNumChartPoints; i++)
                    {
                        [mutableChartData addObject:[NSNumber numberWithFloat:((double)arc4random() / ARC4RANDOM_MAX)]]; // random number between 0 and 1
                    }
                    [mutableLineCharts addObject:mutableChartData];
                }
    }
    else
    {
        
        for (int lineIndex=0; lineIndex<1; lineIndex++)
        {
            NSMutableArray *mutableChartData = [NSMutableArray array];
            for (int i=0; i<kJBLineChartViewControllerPortraitMaxNumChartPoints; i++)
            {
                [mutableChartData addObject:[NSNumber numberWithInt:mutableChartData_3[i]]]; // random number between 0 and 1
            }
            
            [mutableLineCharts addObject:mutableChartData];
        }
        

    }



    
    _chartData = [NSArray arrayWithArray:mutableLineCharts];
//    _daysOfWeek = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    // By default populate portrait view
    self.lineChartView = [[JBLineChartView alloc] init];

    [self populatePortraitView];
 

//    [self addSwipeGestureRecognizer];

}

- (void)addSwipeGestureRecognizer{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
}

- (void)populatePortraitView{
    self.view.backgroundColor = kJBColorLineChartControllerBackground;
    self.navigationItem.rightBarButtonItem = [self chartToggleButtonWithTarget:self action:@selector(chartToggleButtonPressed:)];
    
    
//    self.lineChartView = [[JBLineChartView alloc] init];
    [self initFakeData];

    self.lineChartView.frame = CGRectMake(kJBLineChartViewControllerChartPadding, kJBLineChartViewControllerChartPadding+200, self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartPortraitHeight);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = kJBLineChartViewControllerChartHeaderPadding;
    self.lineChartView.backgroundColor = kJBColorLineChartBackground;
    
    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBLineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartHeaderHeight)];

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
    
//    self.lineChartView = [[JBLineChartView alloc] init];
    [self initFakeData];
    self.lineChartView.frame = CGRectMake(kJBLineChartViewControllerChartPadding, kJBLineChartViewControllerChartPadding, self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartLandScapeHeight);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = kJBLineChartViewControllerChartHeaderPadding;
    self.lineChartView.backgroundColor = kJBColorLineChartBackground;
    
    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBLineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartHeaderHeight)];
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
    
    JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(kJBLineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartFooterHeight)];
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


- (void)addAnimalImage{
//    UIImage *image = [[UIImage alloc] init];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(150, 50, 150, 150)];
    [iv setImage:[UIImage imageNamed:@"Stressed3"]];
    [self.view addSubview:iv];
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
        [self populateLandscapeView];
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation))
    {

        [self populatePortraitView];
    }
    
}


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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.lineChartView setState:JBChartViewStateExpanded];
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
    return (lineIndex == JBLineChartLineSolid) ? kJBLineChartViewControllerChartSolidLineWidth: kJBLineChartViewControllerChartDashedLineWidth;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSolid) ? 0.0: (kJBLineChartViewControllerChartDashedLineWidth * 4);
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
    UIView *buttonImageView = [self.navigationItem.rightBarButtonItem valueForKey:kJBLineChartViewControllerNavButtonViewKey];
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