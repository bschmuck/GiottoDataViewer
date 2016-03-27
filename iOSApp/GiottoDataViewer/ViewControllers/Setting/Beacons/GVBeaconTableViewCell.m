//
//  GVBeaconTableViewCell.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/21/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import "GVBeaconTableViewCell.h"
#define PADDING_TOP 10
#define PADDING_LEFT 20
#define PADDING_RIGHT 20

@implementation GVBeaconTableViewCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    
    return 60;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:identifier]) {

        _uuidLabel = [[UILabel alloc] init];
        [_uuidLabel setFont:[UIFont systemFontOfSize:16]];
        _locationLabel = [[UILabel alloc] init];
        [_locationLabel setFont:[UIFont boldSystemFontOfSize:16]];
        
        [self.contentView addSubview:_uuidLabel];
        [self.contentView addSubview:_locationLabel];
    }
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    
    CGRect frame = self.contentView.frame;
    CGFloat width = frame.size.width - PADDING_LEFT - PADDING_RIGHT;

    
    _uuidLabel.frame = CGRectMake( PADDING_LEFT,
                                  PADDING_TOP,
                                  width,
                                  20 );
    
    _locationLabel.frame = CGRectMake( PADDING_LEFT,
                                      PADDING_TOP+25,
                                      width,
                                      12 );
    
    
    _uuidLabel.text = _beaconEntity.uuid;
    _locationLabel.text = _beaconEntity.location;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _beaconEntity = nil;
}

@end
