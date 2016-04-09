//
//  GVCoreDataManager.m
//
//  Created by Eiji Hayashi on 3/8/14.
//  Copyright (c) 2014 Eiji Hayashi. All rights reserved.
//

#import "GVCoreDataManager.h"
#import "ApplicationLogEntity.h"
#import "BeaconEntity.h"
#import "GVNotificationConstants.h"

#define DATABASE_FILE @"GiottoDataViewer.sqlite"

@implementation GVCoreDataManager

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

#pragma mark -
#pragma mark Singleton

static GVCoreDataManager *sharedInstance = nil;

+ (GVCoreDataManager *)sharedInstance
{
	@synchronized(self)
	{
		if (sharedInstance == nil)
		{
			sharedInstance = [[self alloc] init];
		}
	}
    
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (sharedInstance == nil)
		{
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
    
	return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

#pragma mark -
#pragma mark Init / Dealloc

- (id)init {
	if ( (self = [super init]) ) {
	}
    
    // init NSManagedObjectModel
    //managedObjectModel = [[ NSManagedObjectModel mergedModelFromBundles: nil ] retain ];
    
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Model" ofType:@"momd"]];
    
    // Documents
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [paths objectAtIndex:0];
    
    NSURL *storeURL = [NSURL fileURLWithPath:[documentDir stringByAppendingPathComponent:DATABASE_FILE]];
    
    NSError *error = nil;
    NSLog(@"%@", storeURL);
    
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // Instanciate NSPersistentStoreCoordinator
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Instanciate NSManagedObjectContext
    if (persistentStoreCoordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
	
	return self;
}

#pragma mark -
#pragma mark Instance Methods

-(NSArray*) getManagedObjectsForEntity: (NSString*)entity sortBy:(NSString*)key ascending:(BOOL) asc
{
    // ** check whether an entry exists **
    // create a DB request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // sort condition
    NSSortDescriptor *desc;
    if( key ){
        desc = [[NSSortDescriptor alloc] initWithKey:key ascending:asc];
    }
    else{
        desc = [[NSSortDescriptor alloc] initWithKey:@"primaryKey" ascending:asc];
    }
    NSArray *sortDescriptors;
    sortDescriptors = [[NSArray alloc] initWithObjects:desc, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // create entity description
    NSEntityDescription *entityDescription;
    entityDescription = [NSEntityDescription entityForName:entity inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    // max number to fetch
    [fetchRequest setFetchBatchSize:500];
    
    // create a result controller
    NSFetchedResultsController *resultsController;
    resultsController = [[NSFetchedResultsController alloc]
                         initWithFetchRequest:fetchRequest
                         managedObjectContext:[self managedObjectContext]
                         sectionNameKeyPath:nil
                         cacheName:nil];
    
    // fetch
    NSError *error;
    if (![resultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    
    // extract results from fetched objects
    NSArray *result = resultsController.fetchedObjects;
    
    return result;
}

-(NSManagedObject*)getManagedObjectForEntity: (NSString*) entity withPrimaryKey:(NSNumber *)primaryKey
{
    // create a DB request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // sort condition
    NSSortDescriptor *desc;
    desc = [[NSSortDescriptor alloc] initWithKey:@"primaryKey" ascending:YES];
    
    NSArray *sortDescriptors;
    sortDescriptors = [[NSArray alloc] initWithObjects:desc, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // create entity description
    NSEntityDescription *entityDescription;
    entityDescription = [NSEntityDescription entityForName:entity inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    // search condition
    NSPredicate *pred;
    pred = [NSPredicate predicateWithFormat:@"primaryKey=%@", primaryKey];
    [fetchRequest setPredicate:pred];
    
    // max number to fetch
    [fetchRequest setFetchBatchSize:1];
    
    NSString *entityName = nil;
    // create a result controller
    NSFetchedResultsController *resultsController;
    resultsController = [[NSFetchedResultsController alloc]
                         initWithFetchRequest:fetchRequest
                         managedObjectContext:[self managedObjectContext]
                         sectionNameKeyPath:nil
                         cacheName:entityName];
    
    // fetch
    NSError *error;
    if (![resultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    
    // extract results from fetched objects
    NSArray *result = resultsController.fetchedObjects;
    if( [result count] == 0 ){
        return nil;
    }
    else{
        return (NSManagedObject*)[result objectAtIndex:0];
    }
}

- (void) save{
    NSError* error;
    if( ![managedObjectContext save:&error] ){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (NSArray*) search:(NSString*)text inEntity:(NSString*)entity forKey:(NSString*)key
{
    // create a DB request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // sort condition
    NSSortDescriptor *desc;
    desc = [[NSSortDescriptor alloc] initWithKey:@"primaryKey" ascending:YES];
    
    NSArray *sortDescriptors;
    sortDescriptors = [[NSArray alloc] initWithObjects:desc, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // create entity description
    NSEntityDescription *entityDescription;
    entityDescription = [NSEntityDescription entityForName:entity
                                    inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    // search condition
    NSPredicate *pred;
    pred = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", key, text];
    [fetchRequest setPredicate:pred];
    NSLog(@"%@",pred);
    
    // max number to fetch
    [fetchRequest setFetchBatchSize:50];
    
    NSString *entityName = nil;
    // create a result controller
    NSFetchedResultsController *resultsController;
    resultsController = [[NSFetchedResultsController alloc]
                         initWithFetchRequest:fetchRequest
                         managedObjectContext:[self managedObjectContext]
                         sectionNameKeyPath:nil
                         cacheName:entityName];
    
    // fetch
    NSError *error;
    if (![resultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    
    // extract results from fetched objects
    NSArray* result = resultsController.fetchedObjects;
    
    return result;
}


#pragma mark - ApplicationLogEntity

// create a new excluded site entity
- (ApplicationLogEntity*)insertAppliationLogEntity {
    
    ApplicationLogEntity *appLogEntity;
    appLogEntity = (ApplicationLogEntity*)[NSEntityDescription insertNewObjectForEntityForName:@"ApplicationLogEntity" inManagedObjectContext:self.managedObjectContext];
    
    return appLogEntity;
}

// obtain all excluded site entities
- (NSArray*)applicationLogEntities
{
    return [self getManagedObjectsForEntity:@"ApplicationLogEntity" sortBy:@"timestamp" ascending:NO];
}

- (void) addApplicationLogMessage:(NSString *)message detail:(NSString *)detail level:(int)level
{
    ApplicationLogEntity* appLogEntry = [self insertAppliationLogEntity];
    
    appLogEntry.timestamp = [NSDate dateWithTimeIntervalSinceNow:0];
    appLogEntry.level = [NSNumber numberWithInt:level];
    appLogEntry.message = message;
    appLogEntry.detail = detail;
    
    [self save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ua_application_log_updated"
                                                        object:nil];
}

- (void) clearApplicationLogEntry
{
    NSArray *appLogEntities = self.applicationLogEntities;
    
    for( ApplicationLogEntity* appLogEntity in appLogEntities ){
        [self.managedObjectContext deleteObject:appLogEntity];
    }
    
    [self save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ua_application_log_updated"
                                                        object:nil];
}

#pragma mark - BeaconEntity

// create a new beacon entity
- (BeaconEntity*)insertBeaconEntity
{
    
    BeaconEntity *beaconEntity;
    beaconEntity = (BeaconEntity*)[NSEntityDescription insertNewObjectForEntityForName:@"BeaconEntity" inManagedObjectContext:self.managedObjectContext];

    return beaconEntity;
}

// obtain all excluded site entities
- (NSArray*)beaconEntities
{
    return [self getManagedObjectsForEntity:@"BeaconEntity" sortBy:@"uuid" ascending:YES];
}


- (void) deleteBeaconEntity:(BeaconEntity*)beaconEntity
{
    [self.managedObjectContext deleteObject:beaconEntity];
    [self save];
}

@end
