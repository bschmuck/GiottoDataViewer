//
//  UALogDetailViewController.m
//  UniAuthClient
//
//  Created by Eiji Hayashi on 2/11/14.
//  Copyright (c) 2014 Eiji Hayashi. All rights reserved.
//

#import "GVLogDetailViewController.h"

@interface GVLogDetailViewController ()

@end

@implementation GVLogDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd HH:mm:ss"];
    _timestampField.text = [format stringFromDate:_applicationLogEntity.timestamp];

    _typeField.text = _applicationLogEntity.levelString;
    _messageField.text = _applicationLogEntity.message;
    _detailTextView.text = _applicationLogEntity.detail;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
