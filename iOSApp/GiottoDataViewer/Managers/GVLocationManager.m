//
//  GVLocationManager.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import "GVLocationManager.h"
#import "GVUserPreferences.h"
#import "GVCoreDataManager.h"
#import "BeaconEntity.h"
#import "GVNotificationConstants.h"
#import "GVCoreDataManager.h"

@implementation GVLocationManager
#pragma mark -
#pragma mark Singleton

static GVLocationManager *sharedInstance = nil;

+ (GVLocationManager *)sharedInstance
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

- (id)init
{
    self = [super init];
    [self refreshLocations];
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark -
#pragma mark Methods

- (NSArray*) currentLocations
{
    NSString * locationEmulation = [[GVUserPreferences sharedInstance]locationEmulation];
    NSMutableArray * locations = [[NSMutableArray alloc]initWithArray:_currentLocations];
    
    if(![locationEmulation isEqualToString:@""]){
        [locations addObject:locationEmulation];
    }
    
    
    return locations;
}

#pragma mark -
#pragma mark iBeacon

- (void) startBeaconMonitoring
{
    [self refreshLocations];
    
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
    _locationManager.delegate = self;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    
    for(CLBeaconRegion* region in _regions){
        NSLog(@"%@", region);
        
        [_locationManager startMonitoringForRegion:region];
        [_locationManager startRangingBeaconsInRegion:region];
    }

    [_locationManager startUpdatingLocation];

    NSString * message =[NSString stringWithFormat:@"%@", _regions];
    GV_LOG_VERBOSE(@"iBeacon Scanning Started", message);
}

- (void) refreshLocations
{
    _regions = [[NSMutableArray alloc]init];
    _currentLocations = [[NSMutableArray alloc]init];
    _nearbyBeacons = [[NSMutableDictionary alloc]init];
    
    NSArray* registeredBeacons = [[GVCoreDataManager sharedInstance]beaconEntities];
    
    for(BeaconEntity* beacon in registeredBeacons){
        NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: beacon.uuid];
                              //@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
        NSString *beaconIdentifier = beacon.location;
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:
                                        beaconUUID identifier:beaconIdentifier];
        
        beaconRegion.notifyOnEntry = YES;
        beaconRegion.notifyOnExit = YES;
        
        if(beaconRegion){
            [_regions addObject:beaconRegion];
        }
        else{
            GV_LOG_ERROR(@"Invalid UUID", beacon.uuid);
        }
    }
    
    NSLog(@"Regions: %@",_regions);
}

- (void) stopBeaconMonitoring
{
    for(CLBeaconRegion* region in _regions){
        [_locationManager stopMonitoringForRegion:region];
    }
    
    GV_LOG_VERBOSE(@"iBeacon Scanning Stopped",@"");
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:
(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    if(beacons.count > 0) {
        BOOL isContained = NO;
        for(NSString * loc in _currentLocations){
            if([loc isEqualToString:region.identifier]){
                isContained = YES;
            }
        }
        
        if(!isContained){
            GV_LOG_VERBOSE(@"Did Enter Location", region.identifier);
            [_currentLocations addObject:region.identifier];
            [[NSNotificationCenter defaultCenter] postNotificationName:GV_NOTIFICATION_DID_LOCATION_CHANGE
                                                                object:nil];
        }

    } else {
        NSArray* temp = [[NSArray alloc]initWithArray:_currentLocations];
        for(NSString * loc in temp){
            if([loc isEqualToString:region.identifier]){
                GV_LOG_VERBOSE(@"Did Exit Location", region.identifier);
                [_currentLocations removeObject:loc];
                [[NSNotificationCenter defaultCenter] postNotificationName:GV_NOTIFICATION_DID_LOCATION_CHANGE
                                                                    object:nil];

            }
        }
    }
}

@end
