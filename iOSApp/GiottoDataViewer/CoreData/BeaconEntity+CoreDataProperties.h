//
//  BeaconEntity+CoreDataProperties.h
//  
//
//  Created by Eiji Hayashi on 3/23/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BeaconEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeaconEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
