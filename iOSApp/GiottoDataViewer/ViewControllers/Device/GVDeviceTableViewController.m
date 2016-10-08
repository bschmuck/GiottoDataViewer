//
//  GVDeviceTableViewController.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import "GVDeviceTableViewController.h"
#import "GVDeviceTableViewCell.h"
#import "GVBuildingDepotManager.h"
#import "GVAreaGraphViewController.h"
#import "GVLocationManager.h"
#import "GVNotificationConstants.h"

@interface GVDeviceTableViewController ()

@end

@implementation GVDeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.rowHeight = 60;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
    
    
    [self loadTable];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLocationChange:)
                                                 name:GV_NOTIFICATION_DID_LOCATION_CHANGE
                                               object:nil];
    
    self.tableView.backgroundColor = [self defaultBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
   
    [super viewWillAppear:animated];
    [[GVLocationManager sharedInstance] startBeaconMonitoring];

    [self loadTable];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[GVLocationManager sharedInstance] stopBeaconMonitoring];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark EmptyDataSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"EmptyImage"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Nearby Device Found";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Devices will appear when you come closer.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [self defaultBackgroundColor];
}

- (UIColor*) defaultBackgroundColor
{
    int rgbValue = 0xb7e3e4;
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0x00FF00) >>  8))/255.0
                            blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0
                           alpha:1];
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)loadTable
{
    GVBuildingDepotManager* bdManager = [GVBuildingDepotManager sharedInstance];
    GVLocationManager* locManager = [GVLocationManager sharedInstance];
    
    NSArray* locations = [locManager currentLocations];
    
    NSMutableArray* devices = [[NSMutableArray alloc]init];
    for( NSString* loc in locations){
//        NSArray* d = [bdManager fetchSensorsAt:loc];
        NSArray *d = [bdManager fetchSensorsWithLocationTag:loc];
        [devices addObjectsFromArray:d];
    }
    
    _devices = devices;
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"CellID";
    
    GVDeviceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[GVDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    cell.device = [_devices objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GVDeviceTableViewCell *cell = (GVDeviceTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    GVDevice * device = cell.device;
    [self performSegueWithIdentifier:@"areaGraph" sender:cell.device];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Segueの特定
    NSLog(@"prepareForSegue");
    if ( [[segue identifier]isEqualToString:@"areaGraph"] ) {
        GVAreaGraphViewController *controller = [segue destinationViewController];
        controller.device = (GVDevice*)sender;
    }
}

-(void) didLocationChange:(NSNotification*)notification
{
    [self loadTable];
}

@end
