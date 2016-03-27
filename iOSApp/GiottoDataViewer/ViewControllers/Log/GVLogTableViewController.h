//
//  UALogTableViewController.h
//  UniAuthClient
//
//  Created by Eiji Hayashi on 2/11/14.
//  Copyright (c) 2014 Eiji Hayashi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GVLogTableViewController : UITableViewController <UITableViewDataSource>
{
    __strong NSArray *_applicationLogs;
}

- (IBAction) clearApplicationLogs;

@end
