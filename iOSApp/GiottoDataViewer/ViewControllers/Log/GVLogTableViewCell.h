//
//  UALogTableViewCell.h
//  UniAuthClient
//
//  Created by Eiji Hayashi on 2/11/14.
//  Copyright (c) 2014 Eiji Hayashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationLogEntity.h"

@interface GVLogTableViewCell : UITableViewCell
{
    UILabel *_timeLabel;
    UILabel *_typeLabel;
    UILabel *_messageLabel;
}

@property (strong) ApplicationLogEntity *applicationLogEntity;

@end
