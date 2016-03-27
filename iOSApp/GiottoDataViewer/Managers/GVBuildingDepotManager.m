//
//  BuildingDepotManager.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import "GVBuildingDepotManager.h"
#import "GVDevice.h"
#import "NSDictionary+JSON.h"
#import "GVCoreDataManager.h"
#import "GVUserPreferences.h"

@implementation GVBuildingDepotManager

#pragma mark -
#pragma mark Singleton

static GVBuildingDepotManager *sharedInstance = nil;

+ (GVBuildingDepotManager *)sharedInstance
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
#pragma mark Methods

- (NSArray*) fetchSensorsAt:(NSString*)location
{
    NSString * message = [NSString stringWithFormat:@"location=%@",location];
    GV_LOG_VERBOSE(@"Fetch Sesnor List", message);

    //http://buildingdepot.andrew.cmu.edu:82/service/api/v1/Location=Google/metadata
    NSString* server = [[GVUserPreferences sharedInstance] giottoServer];
    NSString* port = [[GVUserPreferences sharedInstance]giottoPort];
    NSString* apiPrefix = [[GVUserPreferences sharedInstance]apiPrefix];

    NSString* url = [NSString stringWithFormat:@"http://%@:%@%@location=%@/metadata",
                     server,
                     port,
                     apiPrefix,
                     location];
    
    NSString* json = [self fetchDataFrom:url];
    if(!json){
        return [[NSArray alloc]init];
    }
    NSDictionary* dic = [NSDictionary dictionaryWithJson:json];
    NSDictionary* sensors = [dic objectForKey:@"data"];
    NSMutableArray* devices = [[NSMutableArray alloc] init];

    for(NSString* key in [sensors allKeys]){
        NSDictionary* sensor = [sensors objectForKey:key];
        NSDictionary* metadata = [sensor objectForKey:@"metadata"];
        if([sensor objectForKey:@"name"] != nil &&
           [metadata objectForKey:@"location"] != nil &&
           [sensor objectForKey:@"source_name"] != nil &&
           [metadata objectForKey:@"type"] != nil ){
            NSDictionary* deviceDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [sensor objectForKey:@"name"], @"uuid",
                                       [metadata objectForKey:@"location"], @"location",
                                       [sensor objectForKey:@"source_name"], @"name",
                                       [metadata objectForKey:@"type"], @"type",
                                       nil
                                       ];
            GVDevice* device = [[GVDevice alloc]initWithDictionary:deviceDic];
            [devices addObject:device];
        } else {
            NSString * message = [NSString stringWithFormat:@"name: %@\nlocation: %@\nsource_name: %@\ntype: %@",
                                  [sensor objectForKey:@"name"],
                                  [metadata objectForKey:@"location"],
                                  [sensor objectForKey:@"source_name"],
                                  [metadata objectForKey:@"type"]
                                  ];
            
            GV_LOG_WARNING(@"Incomplete Sensor Found", message);
        }
    }
    
    return devices;
}



- (NSArray*) fetchSensorReading:(NSString*)sensorUuid :(float)startTime :(float)endTime :(int)resolution
{
    NSString* server = [[GVUserPreferences sharedInstance] giottoServer];
    NSString* port = [[GVUserPreferences sharedInstance]giottoPort];
    NSString* apiPrefix = [[GVUserPreferences sharedInstance]apiPrefix];
    
    //Here is an example of a API call
    //http://buildingdepot.andrew.cmu.edu:82/service/api/v1/data/id=09896f73-2905-45a7-86b8-958a0cbedb00/interval=86400s/resolution=3600s
    //http://buildingdepot.andrew.cmu.edu:82/service/api/v1/data/id=c82e86ae-fb89-40c8-879f-d8bad3a7ef8b/interval=43264.000000s/resolution=60s
    
    NSString* url = [NSString stringWithFormat:@"http://%@:%@%@data/id=%@/interval=%ds/resolution=%ds",
                      server,
                      port,
                      apiPrefix,
                      sensorUuid,
                      (int)(endTime - startTime),
                      resolution];

    NSLog(@"%@",url);
    NSString* json = [self fetchDataFrom:url];

    NSDictionary * dic = [NSDictionary dictionaryWithJson:json];
    NSArray * values = [[[[dic objectForKey:@"data"] objectForKey:@"series"]objectAtIndex:0]objectForKey:@"values"];
    
    NSMutableArray* sensorReadings =[[NSMutableArray alloc]init];
    
    for(NSArray* sample in values){
        NSNumber* reading = [sample objectAtIndex:1];
        if(reading != (id)[NSNull null])
            [sensorReadings addObject:reading];
    }
    
    
    return sensorReadings;
}


#pragma mark -

- (NSString*) fetchDataFrom:(NSString*)url
{
    GV_LOG_VERBOSE(@"HTTP GET", url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSString * errorMessage = [NSString stringWithFormat:@"Error getting %@, HTTP status code %li",
                                   url,
                                   (long)[responseCode statusCode]
                                   ];
        
        GV_LOG_ERROR(@"HTTP Error", errorMessage);
        return nil;
    }

    NSString * response = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    GV_LOG_VERBOSE(@"HTTP Respose", response);

    return response;
}

@end
