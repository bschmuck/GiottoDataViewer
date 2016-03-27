//
//  GVBeaconDetailViewController.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/22/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import "GVBeaconDetailViewController.h"
#import "GVCoreDataManager.h"
#import "GVNotificationConstants.h"

@implementation GVBeaconDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Delete"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(deleteButtonClicked:)];
    self.navigationItem.rightBarButtonItem = flipButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if( _beaconEntity != nil ){
        _uuidTextField.text = _beaconEntity.uuid;
        _locationTextField.text = _beaconEntity.location;
    } else {
        _beaconEntity = [[GVCoreDataManager sharedInstance] insertBeaconEntity];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSString * uuid = _uuidTextField.text;
    NSString * location = _locationTextField.text;
    
    if(_beaconEntity == nil){
        return;
    }
    
    if(uuid != nil && ![uuid isEqualToString:@""] && location != nil && ![location isEqualToString:@""]){
        _beaconEntity.uuid = _uuidTextField.text;
        _beaconEntity.location = _locationTextField.text;
        [[GVCoreDataManager sharedInstance]save];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GV_NOTIFICATION_DID_REGISTERED_BEACON_CHANGE
                                                            object:nil];
    } else {
        [[GVCoreDataManager sharedInstance]deleteBeaconEntity:_beaconEntity];
    }
}

- (IBAction)deleteButtonClicked:(id)sender
{
    if( _beaconEntity ){
        [[GVCoreDataManager sharedInstance]deleteBeaconEntity:_beaconEntity];
        _beaconEntity = nil;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
