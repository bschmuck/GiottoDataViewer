//
//  ApplicationLogEntity+CoreDataProperties.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ApplicationLogEntity+CoreDataProperties.h"

@implementation ApplicationLogEntity (CoreDataProperties)

@dynamic detail;
@dynamic level;
@dynamic message;
@dynamic timestamp;

@end
