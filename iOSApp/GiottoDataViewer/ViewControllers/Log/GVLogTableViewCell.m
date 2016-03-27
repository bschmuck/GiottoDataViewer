//
//  UALogTableViewCell.m
//  UniAuthClient
//
//  Created by Eiji Hayashi on 2/11/14.
//  Copyright (c) 2014 Eiji Hayashi. All rights reserved.
//

#import "GVLogTableViewCell.h"
#import "GVCoreDataManager.h"

#define PADDING_LEFT 20
#define PADDING_RIGHT 20
#define PADDING_TOP 6
#define PADDING_BOTTON 3
@implementation GVLogTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
        _timeLabel = [[UILabel alloc]init];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        _typeLabel = [[UILabel alloc] init];
        [_typeLabel setFont:[UIFont systemFontOfSize:14]];
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setFont:[UIFont boldSystemFontOfSize:16]];
        
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_typeLabel];
        [self.contentView addSubview:_messageLabel];
	}
    
	return self;
}

- (void) layoutSubviews {
	[super layoutSubviews];
    
    
    CGRect frame = self.contentView.frame;
    CGFloat width = frame.size.width - PADDING_LEFT - PADDING_RIGHT;
    
    _timeLabel.frame = CGRectMake( PADDING_LEFT,
                                  PADDING_TOP,
                                  120,
                                  16 );
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd HH:mm:ss"];
    
    _timeLabel.text = [format stringFromDate:_applicationLogEntity.timestamp];
    
    
    _typeLabel.frame = CGRectMake( PADDING_LEFT + 130,
                                  PADDING_TOP,
                                  width - 120,
                                  16 );
    
    _typeLabel.text = _applicationLogEntity.levelString;
    
    _messageLabel.frame = CGRectMake( PADDING_LEFT,
                                     PADDING_TOP + 18,
                                     width,
                                     18 );
    
    _messageLabel.text = _applicationLogEntity.message;
    if( [_applicationLogEntity.level intValue] == GV_LOG_LEVEL_VERBOSE ){
        _messageLabel.textColor = [UIColor grayColor];
    }
    else if( [_applicationLogEntity.level intValue] == GV_LOG_LEVEL_INFO ){
        _messageLabel.textColor = [UIColor blackColor];
    }
    else if( [_applicationLogEntity.level intValue] == GV_LOG_LEVEL_DATA ){
        _messageLabel.textColor = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];
    }
    else if( [_applicationLogEntity.level intValue] == GV_LOG_LEVEL_WARNING ){
        _messageLabel.textColor = [UIColor orangeColor];
    }
    else if( [_applicationLogEntity.level intValue] == GV_LOG_LEVEL_ERROR ){
        _messageLabel.textColor = [UIColor redColor];
    }
    
}

- (void)prepareForReuse {
	[super prepareForReuse];
    self.applicationLogEntity = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
