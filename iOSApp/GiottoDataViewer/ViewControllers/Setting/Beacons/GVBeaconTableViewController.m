//
//  GVBeaconTableViewController.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/21/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import "GVBeaconTableViewController.h"
#import "GVCoreDataManager.h"
#import "GVBeaconTableViewCell.h"
#import "BeaconEntity.h"
#import "GVBeaconDetailViewController.h"
#import "GVNotificationConstants.h"

@implementation GVBeaconTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadTable];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:GV_NOTIFICATION_DID_REGISTERED_BEACON_CHANGE
                                                        object:nil];
}

- (void) didUpdateApplicationLog:(NSNotification*)notification
{
    [self loadTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)loadTable
{
    _beacons = [[GVCoreDataManager sharedInstance] beaconEntities];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _beacons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"BeaconCell";
    
    GVBeaconTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[GVBeaconTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    BeaconEntity *beacon = [_beacons objectAtIndex:indexPath.row];
    cell.beaconEntity = beacon;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GVBeaconTableViewCell *cell = (GVBeaconTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"detail" sender:cell.beaconEntity];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Segueの特定
    if ( [[segue identifier] isEqualToString:@"detail"] ) {
        GVBeaconDetailViewController *beaconDetailViewController = [segue destinationViewController];
        beaconDetailViewController.beaconEntity = (BeaconEntity*)sender;
    }
}

@end
