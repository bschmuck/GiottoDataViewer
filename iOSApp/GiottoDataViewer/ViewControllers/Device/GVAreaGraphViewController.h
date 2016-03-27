//
//  CRAreaGraphViewController.h
//  CrowdResourcing
//
//  Created by Eiji Hayashi on 7/23/15.
//  Copyright (c) 2015 Eiji Hayashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVDevice.h"

@interface GVAreaGraphViewController : UIViewController
{
    NSDictionary* _graphSettings;
}

@property (nonatomic,strong) GVDevice * device;

@end
