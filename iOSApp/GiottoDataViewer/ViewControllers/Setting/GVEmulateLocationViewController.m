//
//  GVEmulateLocationViewController.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/22/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import "GVEmulateLocationViewController.h"
#import "GVUserPreferences.h"

@implementation GVEmulateLocationViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _locationTextField.text = [[GVUserPreferences sharedInstance]locationEmulation];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [GVUserPreferences sharedInstance].locationEmulation = _locationTextField.text;
    [[GVUserPreferences sharedInstance]save];
}

@end
