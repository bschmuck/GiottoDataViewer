//
//  GVGiottoSettingTableViewController.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/21/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import "GVGiottoSettingTableViewController.h"
#import "GVUserPreferences.h"

@interface GVGiottoSettingTableViewController ()

@end

@implementation GVGiottoSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GVUserPreferences* pref = [GVUserPreferences sharedInstance];
    
    [_addressTextField setText:pref.giottoServer];
    [_portTextField setText:pref.giottoPort];
    [_apiPrefixTextField setText:pref.apiPrefix];
}

- (void) viewWillDisappear:(BOOL)animated
{
    GVUserPreferences* pref = [GVUserPreferences sharedInstance];
    
    [pref setGiottoServer:_addressTextField.text];
    [pref setGiottoPort:_portTextField.text];
    [pref setApiPrefix:_apiPrefixTextField.text];
    [pref save];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}



@end
