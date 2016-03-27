//
//  GVCoreDataManager.h
//
//  GVeated by Eiji Hayashi on 3/8/14.
//  Copyright (c) 2014 Eiji Hayashi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BeaconEntity.h"

#define GV_LOG_LEVEL_VERBOSE    0
#define GV_LOG_LEVEL_INFO       2
#define GV_LOG_LEVEL_DATA       4
#define GV_LOG_LEVEL_WARNING    6
#define GV_LOG_LEVEL_ERROR      8

#define GV_LOG(_level,_message,_detail) \
[[GVCoreDataManager sharedInstance]addApplicationLogMessage:_message detail:_detail level:_level]

#define GV_LOG_INFO(message,detail) GV_LOG(GV_LOG_LEVEL_INFO,message,detail)
#define GV_LOG_VERBOSE(message,detail) GV_LOG(GV_LOG_LEVEL_VERBOSE,message,detail)
#define GV_LOG_WARNING(message,detail) GV_LOG(GV_LOG_LEVEL_WARNING,message,detail)
#define GV_LOG_ERROR(message,detail) GV_LOG(GV_LOG_LEVEL_ERROR,message,detail)
#define GV_LOG_DATA(message,detail) GV_LOG(GV_LOG_LEVEL_DATA,message,detail)

@interface GVCoreDataManager : NSObject
{
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *managedObjectContext;
    
    // uploading logs to a server
    NSMutableData *_responseData;
    NSArray *_uploadBuffer;
}


// would not need to make them properties
@property ( nonatomic, retain, readonly ) NSPersistentStoreCoordinator		*persistentStoreCoordinator;
@property ( nonatomic, retain, readonly ) NSManagedObjectModel		*managedObjectModel;
@property ( nonatomic, retain, readonly ) NSManagedObjectContext *managedObjectContext;

+ (GVCoreDataManager *)sharedInstance;
- (void) save;

// Application Logs
@property (nonatomic, readonly) NSArray *applicationLogEntities;
- (void) addApplicationLogMessage:(NSString*)message detail:(NSString*)detail level:(int)level;
- (void) clearApplicationLogEntry;

// Beacons
@property (nonatomic, readonly) NSArray* beaconEntities;
- (BeaconEntity*)insertBeaconEntity;
- (void) deleteBeaconEntity:(BeaconEntity*)beaconEntity;





@end
