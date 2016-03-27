//
//  CRAreaGraphViewController.m
//  CrowdResourcing
//
//  Created by Eiji Hayashi on 7/23/15.
//  Copyright (c) 2015 Eiji Hayashi. All rights reserved.
//

#import "GVAreaGraphViewController.h"
// Views
#import "JBLineChartView.h"
#import "JBChartHeaderView.h"
#import "JBLineChartFooterView.h"
#import "JBChartInformationView.h"
#import "JBConstants.h"
#import "NSDictionary+JSON.h"
#import "GVBuildingDepotManager.h"

#define ARC4RANDOM_MAX 0x100000000

typedef NS_ENUM(NSInteger, JBLineChartLine){
    JBLineChartLineSun,
    JBLineChartLineMoon,
    JBLineChartLineCount
};

// Numerics
CGFloat const kCRAreaGraphViewControllerChartHeight = 250.0f;
CGFloat const kCRAreaGraphViewControllerChartPadding = 10.0f;
CGFloat const kCRAreaGraphViewControllerChartHeaderHeight = 75.0f;
CGFloat const kCRAreaGraphViewControllerChartHeaderPadding = 20.0f;
CGFloat const kCRAreaGraphViewControllerChartFooterHeight = 20.0f;
CGFloat const kCRAreaGraphViewControllerChartLineWidth = 2.0f;
NSInteger const kCRAreaGraphViewControllerMaxNumChartPoints = 12;

NSInteger const kCRAreaGraphViewControllerSamplingRate = 3600;

// Strings
NSString * const kCRAreaGraphViewControllerNavButtonViewKey = @"view";

@interface GVAreaGraphViewController () <JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic, strong) JBLineChartView *lineChartView;
@property (nonatomic, strong) JBChartInformationView *informationView;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *xAxis;

// Buttons
- (void)chartToggleButtonPressed:(id)sender;

// Helpers
- (void)initFakeData;
- (NSArray *)largestLineData; // largest collection of fake line data

@end

@implementation GVAreaGraphViewController


#pragma mark - Data

- (void) refresh
{
    _chartData = [self fetchDataFor:_device.uuid];
    
    [self initXLabels:_chartData];
    [self.chartView reloadData];
}

- (NSArray*) fetchDataFor:(NSString*)uuid
{
    NSDate* now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval interval = [now timeIntervalSince1970];

    float startTime = (float)(interval - [[_graphSettings objectForKey:@"x_range"]integerValue]);
    float endTime = (float)interval;
    int resolution = [[_graphSettings objectForKey:@"resolution"]intValue];
    
    
    NSArray* data = [[GVBuildingDepotManager sharedInstance] fetchSensorReading:uuid :startTime :endTime :resolution ];
    
    return data;
}

- (void) initXLabels:(NSArray*) data
{
    NSDate * now = [NSDate date];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"h a"];
    
    NSMutableArray * xAxis = [[NSMutableArray alloc]init];
    for(NSInteger i=data.count-1; i>=0; i--){
        NSDate * date = [NSDate dateWithTimeInterval:-i*kCRAreaGraphViewControllerSamplingRate sinceDate:now];
        [xAxis addObject:[timeFormat stringFromDate:date]];
    }
    
    _xAxis = xAxis;
    [(JBLineChartFooterView*)(self.lineChartView.footerView) rightLabel].text =[[self.xAxis lastObject] uppercaseString];
    [(JBLineChartFooterView*)(self.lineChartView.footerView) leftLabel].text =[[self.xAxis firstObject] uppercaseString];
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

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = kJBColorLineChartControllerBackground;
    
    self.lineChartView = [[JBLineChartView alloc] init];
    self.lineChartView.frame = CGRectMake(kCRAreaGraphViewControllerChartPadding, kCRAreaGraphViewControllerChartPadding+65, self.view.bounds.size.width - (kCRAreaGraphViewControllerChartPadding * 2), kCRAreaGraphViewControllerChartHeight);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding =kCRAreaGraphViewControllerChartHeaderPadding;
    self.lineChartView.backgroundColor = kJBColorLineChartBackground;
    
    NSArray* yRange = [_graphSettings objectForKey:@"y_range"];
    self.lineChartView.minimumValue = [[yRange objectAtIndex:0] floatValue];
    self.lineChartView.maximumValue = [[yRange objectAtIndex:1] floatValue];
    
    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kCRAreaGraphViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kCRAreaGraphViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kCRAreaGraphViewControllerChartPadding * 2), kCRAreaGraphViewControllerChartHeaderHeight)];
    headerView.titleLabel.text = [self.device.name uppercaseString];
    headerView.subtitleLabel.text = [self todayString];
    headerView.titleLabel.textColor = kJBColorLineChartHeader;
    headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.subtitleLabel.textColor = kJBColorLineChartHeader;
    headerView.subtitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.separatorColor = kJBColorLineChartHeaderSeparatorColor;
    self.lineChartView.headerView = headerView;
    
    JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(kCRAreaGraphViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kCRAreaGraphViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kCRAreaGraphViewControllerChartPadding * 2), kCRAreaGraphViewControllerChartFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.textColor = [UIColor whiteColor];
    footerView.sectionCount = [[self chartData] count];
    self.lineChartView.footerView = footerView;
    
    [self.view addSubview:self.lineChartView];
    
    self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.lineChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.lineChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    [self.informationView setValueAndUnitTextColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
    [self.informationView setTitleTextColor:kJBColorLineChartHeader];
    [self.informationView setTextShadowColor:nil];
    [self.informationView setSeparatorColor:kJBColorLineChartHeaderSeparatorColor];
    [self.view addSubview:self.informationView];
    
    [self.lineChartView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _graphSettings = [self configureGraph:_device.type];
    [self refresh];
    
    if(_chartData.count == 0){
        NSLog(@"No Data");
    }else{
        [self configureInformationView];
        [self.lineChartView setState:JBChartViewStateExpanded];
        [NSTimer scheduledTimerWithTimeInterval:[[_graphSettings objectForKey:@"refresh_wait"] floatValue]
                                         target:self
                                       selector:@selector(refresh)
                                       userInfo:nil
                                        repeats:YES];
    }


}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [self.chartData count];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return NO;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [[self.chartData objectAtIndex:horizontalIndex] floatValue];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    NSNumber *valueNumber = [self.chartData objectAtIndex:horizontalIndex];
    NSString *unit = [_graphSettings objectForKey:@"unit"];
    [self.informationView setValueText:[NSString stringWithFormat:@"%.1f", [valueNumber floatValue]] unitText:unit];
    [self.informationView setTitleText:self.device.name];
    [self.informationView setHidden:NO animated:YES];
    //[self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    //[self.tooltipView setText:[[self.xAxis objectAtIndex:horizontalIndex] uppercaseString]];
}

- (void) configureInformationView
{
    NSNumber *valueNumber = [self.chartData objectAtIndex:[self.chartData count]-1];
    NSString *unit = [_graphSettings objectForKey:@"unit"];
    [self.informationView setValueText:[NSString stringWithFormat:@"%.1f", [valueNumber floatValue]] unitText:unit];
    [self.informationView setTitleText:self.device.name];
    [self.informationView setHidden:NO animated:YES];
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    [self configureInformationView];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSun) ? kJBColorAreaChartDefaultSunLineColor: kJBColorAreaChartDefaultMoonLineColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView fillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSun) ? kJBColorAreaChartDefaultSunAreaColor : kJBColorAreaChartDefaultMoonAreaColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSun) ? kJBColorAreaChartDefaultSunLineColor: kJBColorAreaChartDefaultMoonLineColor;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return kCRAreaGraphViewControllerChartLineWidth;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView verticalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSun) ? kJBColorAreaChartDefaultSunSelectedLineColor: kJBColorAreaChartDefaultMoonSelectedLineColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionFillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSun) ? kJBColorAreaChartDefaultSunSelectedAreaColor : kJBColorAreaChartDefaultMoonSelectedAreaColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == JBLineChartLineSun) ? kJBColorAreaChartDefaultSunSelectedLineColor: kJBColorAreaChartDefaultMoonSelectedLineColor;
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewLineStyleSolid;
}

#pragma mark - Buttons

- (void)chartToggleButtonPressed:(id)sender
{
    UIView *buttonImageView = [self.navigationItem.rightBarButtonItem valueForKey:kCRAreaGraphViewControllerNavButtonViewKey];
    buttonImageView.userInteractionEnabled = NO;
    
    CGAffineTransform transform = self.lineChartView.state == JBChartViewStateExpanded ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    buttonImageView.transform = transform;
    
    [self.lineChartView setState:self.lineChartView.state == JBChartViewStateExpanded ? JBChartViewStateCollapsed : JBChartViewStateExpanded animated:YES callback:^{
        buttonImageView.userInteractionEnabled = YES;
    }];
}

#pragma mark - Legends

- (NSString*) todayString
{
    NSDate * now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [dateFormatter stringFromDate:now];
}

- (NSString*)unitText
{
    return [_graphSettings objectForKey:@"unit"];
}

-(NSDictionary*) configureGraph:(NSString*)type
{
    NSDictionary* config;
    
    if([self.device.type isEqualToString:@"Temperature"]){
        config = @{
                    @"unit":@"°C",
                    @"x_range":@(60*60*12),
                    @"y_range":@[@20, @25],
                    @"resolution":@"60s",
                    @"refresh_wait":@60
                   };
    } else if ([self.device.type isEqualToString:@"Humidity"]){
        config = @{
                   @"unit":@"%",
                   @"x_range":@(60*5),
                   @"y_range":@[@0, @100],
                   @"resolution":@"1s",
                   @"refresh_wait":@1
                   };
    } else if ([self.device.type isEqualToString:@"Lux"]){
        config = @{
                   @"unit":@"lx",
                   @"x_range":@(60*5),
                   @"y_range":@[@0, @1000],
                   @"resolution":@"1s",
                   @"refresh_wait":@1
                   };
    } else if ([self.device.type isEqualToString:@"Pressure"]){
        config = @{
                   @"unit":@"hPA",
                   @"x_range":@(60*60*12),
                   @"y_range":@[@800, @1600],
                   @"resolution":@"60s",
                   @"refresh_wait":@60
                   };
    }
    else{
        config = @{
                   @"unit":@"",
                   @"x_range":@(60*5),
                   @"y_range":@[@0, @1000],
                   @"resolution":@"1s",
                   @"refresh_wait":@1
                   };
    }
    
    return config;
}


#pragma mark - Overrides

- (JBChartView *)chartView
{
    return self.lineChartView;
}

@end