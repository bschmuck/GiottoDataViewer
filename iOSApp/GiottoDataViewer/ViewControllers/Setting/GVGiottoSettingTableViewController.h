//
//  GVGiottoSettingTableViewController.h
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/21/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GVGiottoSettingTableViewController : UITableViewController
{
    IBOutlet UITextField* _addressTextField;
    IBOutlet UITextField* _portTextField;
    __weak IBOutlet UITextField *_oauthPortTextField;
    IBOutlet UITextField* _apiPrefixTextField;
    IBOutlet UITextField* _oauthAppIdTextField;
    IBOutlet UITextField* _oauthAppKeyTextField;
}
@end
