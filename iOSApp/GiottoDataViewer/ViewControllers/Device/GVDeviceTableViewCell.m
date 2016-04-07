//
//  GVDeviceTableViewCell.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import "GVDeviceTableViewCell.h"

#define PADDING_LEFT 20
#define PADDING_RIGHT 20
#define PADDING_TOP 12
#define PADDING_BOTTON 3

@implementation GVDeviceTableViewCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    
    return 60;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode =  UIViewContentModeScaleAspectFit;
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont systemFontOfSize:18]];
        _locationLabel = [[UILabel alloc] init];
        [_locationLabel setFont:[UIFont systemFontOfSize:14]];
        _locationLabel.textColor = [UIColor grayColor];
        _typeLabel = [[UILabel alloc] init];
        [_typeLabel setFont:[UIFont systemFontOfSize:16]];
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setFont:[UIFont boldSystemFontOfSize:16]];
        
        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_locationLabel];
        [self.contentView addSubview:_typeLabel];
        [self.contentView addSubview:_messageLabel];
    }
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    
    CGRect frame = self.contentView.frame;
    CGFloat width = frame.size.width - PADDING_LEFT - PADDING_RIGHT;
    /*
     _timeLabel.frame = CGRectMake( PADDING_LEFT,
     PADDING_TOP,
     100,
     16 );
     
     NSDateFormatter *format = [[NSDateFormatter alloc] init];
     [format setDateFormat:@"MM/dd HH:mm:ss"];
     
     _timeLabel.text = [format stringFromDate:_thingEntity.lastFound];
     */
    _iconImageView.frame = CGRectMake( PADDING_LEFT + 8,
                                      PADDING_TOP+3,
                                      33,
                                      30 );
    
    _nameLabel.frame = CGRectMake( PADDING_LEFT + 50,
                                  PADDING_TOP,
                                  width - 70,
                                  20 );
    
    _locationLabel.frame = CGRectMake( PADDING_LEFT + 50,
                                      PADDING_TOP+25,
                                      width - 70,
                                      12 );
    
    _typeLabel.frame = CGRectMake( PADDING_LEFT + 110,
                                  PADDING_TOP,
                                  width - 100,
                                  16 );
    
    
    _messageLabel.frame = CGRectMake( PADDING_LEFT,
                                     PADDING_TOP + 16,
                                     width,
                                     18 );
    
    _nameLabel.text = _device.name;
    _locationLabel.text = _device.location;
    if([_device.type isEqualToString:@"Hue"]){
        _iconImageView.image = [UIImage imageNamed:@"HueIcon"];
    }
    else if([_device.type isEqualToString:@"Temperature"]){
        _iconImageView.image = [UIImage imageNamed:@"TemperatureIcon"];
    }
    else if([_device.type isEqualToString:@"Humidity"]){
        _iconImageView.image = [UIImage imageNamed:@"HumidityIcon"];
    }
    else if([_device.type isEqualToString:@"RoomLight"]){
        _iconImageView.image = [UIImage imageNamed:@"RoomLightIcon"];
    }
    else if([_device.type isEqualToString:@"Lux"]){
        _iconImageView.image = [UIImage imageNamed:@"LuxIcon"];
    }
    else if([_device.type isEqualToString:@"Pressure"]){
        _iconImageView.image = [UIImage imageNamed:@"PressureIcon"];
    }
    else if([_device.type isEqualToString:@"Accelerometer"]){
        _iconImageView.image = [UIImage imageNamed:@"AccelerometerIcon"];
    }
    else{
        _iconImageView.image = [UIImage imageNamed:@"UnknownIcon"];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _device = nil;
    _iconImageView.image = nil;
}


@end
