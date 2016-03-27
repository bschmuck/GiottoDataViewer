//
//  GVBeaconTableViewController.h
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/21/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GVBeaconTableViewController : UITableViewController <UITableViewDataSource>
{
    __strong NSArray *_beacons;
}

- (IBAction) addBeacon;

@end
