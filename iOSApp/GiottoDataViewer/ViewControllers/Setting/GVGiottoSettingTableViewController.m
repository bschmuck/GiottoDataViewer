//
//  GVGiottoSettingTableViewController.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/21/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import "GVGiottoSettingTableViewController.h"
#import "GVUserPreferences.h"
#import "GVBuildingDepotManager.h"

@interface GVGiottoSettingTableViewController ()

@end

@implementation GVGiottoSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GVUserPreferences* pref = [GVUserPreferences sharedInstance];
    
    [_addressTextField setText:pref.giottoServer];
    [_portTextField setText:pref.giottoPort];
    [_apiPrefixTextField setText:pref.apiPrefix];
    [_oauthAppIdTextField setText:pref.oauthAppId];
    [_oauthAppKeyTextField setText:pref.oauthAppKey];
}

- (void) viewWillDisappear:(BOOL)animated
{
    GVUserPreferences* pref = [GVUserPreferences sharedInstance];
    
    [pref setGiottoServer:_addressTextField.text];
    [pref setGiottoPort:_portTextField.text];
    [pref setApiPrefix:_apiPrefixTextField.text];
    
    BOOL isOAuthInfoChanged = NO;
    if( [pref.oauthAppKey isEqualToString:_oauthAppKeyTextField.text]){
        isOAuthInfoChanged = YES;
    }
    if( [pref.oauthAppId isEqualToString:_oauthAppIdTextField.text]){
        isOAuthInfoChanged = YES;
    }
    [pref setOauthAppKey:_oauthAppKeyTextField.text];
    [pref setOauthAppId:_oauthAppIdTextField.text];
    
    [pref save];

    if(isOAuthInfoChanged){
        [[GVBuildingDepotManager sharedInstance]fetchOAuthToken:pref.oauthAppId forKey:pref.oauthAppKey];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
