//
//  BuildingDepotManager.h
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GVBuildingDepotManagerDelegate

- (void)authenticationDidSucceed;
- (void)authenticationDidFail;

@end

@interface GVBuildingDepotManager : NSObject

+ (GVBuildingDepotManager *)sharedInstance;

@property (strong, nonatomic) NSString *accessToken;
@property (weak) id<GVBuildingDepotManagerDelegate> delegate;

- (NSArray *) fetchSensorsWithOwner:(NSString *)owner;
- (NSArray*) fetchSensorsAt:(NSString*)location;
- (NSArray *) fetchSensorsWithLocationTag:(NSString *)location;
- (NSArray*) fetchSensorReading:(NSString*)sensorUuid :(NSTimeInterval)startTime :(NSTimeInterval)endTime :(NSString*)resolution;
- (void) fetchOAuthToken:(NSString*)appId forKey:(NSString*)appKey;

@end
