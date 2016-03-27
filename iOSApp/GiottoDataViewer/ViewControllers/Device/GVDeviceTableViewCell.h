//
//  GVDeviceTableViewCell.h
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVDevice.h"

@interface GVDeviceTableViewCell : UITableViewCell
{
    //UILabel *_timeLabel;
    UILabel *_nameLabel;
    UILabel *_locationLabel;
    UILabel *_typeLabel;
    UILabel *_messageLabel;
    UIImageView * _iconImageView;
}

@property (strong) GVDevice * device;

@end
