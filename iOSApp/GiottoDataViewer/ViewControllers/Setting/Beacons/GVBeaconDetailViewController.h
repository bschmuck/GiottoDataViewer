//
//  GVBeaconDetailViewController.h
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/22/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconEntity.h"

@interface GVBeaconDetailViewController : UIViewController
{
    IBOutlet UITextField* _uuidTextField;
    IBOutlet UITextField* _majorTextField;
    IBOutlet UITextField* _minorTextField;
    IBOutlet UITextField* _locationTextField;
}

@property (nonatomic, strong) BeaconEntity* beaconEntity;

@end
