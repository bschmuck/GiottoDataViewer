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
    IBOutlet UITextField* _apiPrefixTextField;
}
@end
