//
//  GVDeviceTableViewController.h
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@interface GVDeviceTableViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    __strong NSArray *_devices;
}
@end
