//
//  UALogDetailViewController.h
//  UniAuthClient
//
//  Created by Eiji Hayashi on 2/11/14.
//  Copyright (c) 2014 Eiji Hayashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationLogEntity.h"

@interface GVLogDetailViewController : UIViewController
{
    IBOutlet UITextField *_timestampField;
    IBOutlet UITextField *_typeField;
    IBOutlet UITextField *_messageField;
    IBOutlet UITextView  *_detailTextView;
    
}

@property (nonatomic, retain) ApplicationLogEntity* applicationLogEntity;
@end
