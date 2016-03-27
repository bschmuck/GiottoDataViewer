//
//  UALogTableViewController.m
//  UniAuthClient
//
//  Created by Eiji Hayashi on 2/11/14.
//  Copyright (c) 2014 Eiji Hayashi. All rights reserved.
//

#import "GVLogTableViewController.h"
#import "GVCoreDataManager.h"
#import "ApplicationLogEntity.h"
#import "GVLogTableViewCell.h"
#import "AppDelegate.h"
#import "GVLogDetailViewController.h"

@implementation GVLogTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadTable];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateApplicationLog:)
                                                 name:@"ua_application_log_updated"
                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    _applicationLogs = [[GVCoreDataManager sharedInstance] applicationLogEntities];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _applicationLogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"CellID";
    
    GVLogTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[GVLogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    ApplicationLogEntity *applicationLog = [_applicationLogs objectAtIndex:indexPath.row];
    cell.applicationLogEntity = applicationLog;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GVLogTableViewCell *cell = (GVLogTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"detail" sender:cell.applicationLogEntity];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (IBAction) clearApplicationLogs
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear Logs"
                                                    message:@"Clear all application logs?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK",nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [[GVCoreDataManager sharedInstance]clearApplicationLogEntry];
    }
    
    [self loadTable];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"detail"] ) {
        GVLogDetailViewController *logDetailViewController = [segue destinationViewController];
        logDetailViewController.applicationLogEntity = (ApplicationLogEntity*)sender;
    }
}


@end
