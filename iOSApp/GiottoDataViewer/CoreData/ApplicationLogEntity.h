//
//  ApplicationLogEntity.h
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplicationLogEntity : NSManagedObject

@property (nonatomic, readonly) NSString * levelString;
@property (nonatomic, readonly) NSString * timeString;
@property (nonatomic, readonly) NSString * dateString;

@end

NS_ASSUME_NONNULL_END

#import "ApplicationLogEntity+CoreDataProperties.h"
