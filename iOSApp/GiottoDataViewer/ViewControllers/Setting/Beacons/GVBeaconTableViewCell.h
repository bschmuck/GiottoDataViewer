//
//  GVBeaconTableViewCell.h
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/21/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconEntity.h"

@interface GVBeaconTableViewCell : UITableViewCell
{
    UILabel *_uuidLabel;
    UILabel *_locationLabel;
}

@property (strong) BeaconEntity *beaconEntity;
@end
