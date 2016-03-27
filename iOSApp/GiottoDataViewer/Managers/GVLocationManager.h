//
//  GVLocationManager.h
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GVLocationManager : NSObject <CLLocationManagerDelegate>
{
    __strong NSMutableArray* _currentLocations;
    
    __strong CLLocationManager* _locationManager;
    __strong NSMutableArray* _regions;
    
    __strong NSMutableDictionary* _nearbyBeacons;
    
    __strong NSString * _currentLocation;
}


+ (GVLocationManager *)sharedInstance;

- (NSArray*) currentLocations;
- (void) startBeaconMonitoring;
- (void) stopBeaconMonitoring;


@end
