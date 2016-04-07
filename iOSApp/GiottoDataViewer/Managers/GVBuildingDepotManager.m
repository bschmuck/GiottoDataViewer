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

- (id) init
{
    self = [super init];
    if(self){
        GVUserPreferences * pref = [GVUserPreferences sharedInstance];
        [self fetchOAuthToken:pref.oauthAppId forKey:pref.oauthAppKey];
    }
    
    return self;
}

#pragma mark -
#pragma mark Methods

- (void) fetchOAuthToken:(NSString*)appId forKey:(NSString*)appKey
{
    NSString * message = [NSString stringWithFormat:@"AppID: %@\nAppKey:%@", appId, appKey];
    GV_LOG_VERBOSE(@"Fetch OAuth token", message);
    
    NSString* server = [[GVUserPreferences sharedInstance] giottoServer];
    NSString* port = [[GVUserPreferences sharedInstance]giottoPort];
    //NSString* apiPrefix = [[GVUserPreferences sharedInstance]apiPrefix];
    
    NSString* url = [NSString stringWithFormat:@"%@:%@/oauth/access_token/client_id=%@/client_secret=%@",
                     server,
                     port,
                     appId,
                     appKey
                     ];
    NSLog(@"%@",url);
    
    NSString* json = [self fetchDataFrom:url withOAuthToken:nil];
    if(!json){
        GV_LOG_ERROR(@"Could not fetch OAuth token", message);
        return;
    }
    
    NSDictionary* dic = [NSDictionary dictionaryWithJson:json];
    
    _accessToken = [dic objectForKey:@"access_token"];
}

- (NSArray*) fetchSensorsAt:(NSString*)location
{
    NSString * message = [NSString stringWithFormat:@"location=%@",location];
    GV_LOG_VERBOSE(@"Fetch Sesnor List", message);

    NSString* server = [[GVUserPreferences sharedInstance] giottoServer];
    NSString* port = [[GVUserPreferences sharedInstance]giottoPort];
    NSString* apiPrefix = [[GVUserPreferences sharedInstance]apiPrefix];

    NSString* url = [NSString stringWithFormat:@"%@:%@%@/sensor/list?filter=metadata&location=%@",
                     server,
                     port,
                     apiPrefix,
                     location];
    
    NSString* json = [self fetchDataFrom:url withOAuthToken:_accessToken];
    if(!json){
        return [[NSArray alloc]init];
    }
    
    NSDictionary* dic = [NSDictionary dictionaryWithJson:json];
    NSArray* sensors = [dic objectForKey:@"data"];
    NSMutableArray* devices = [[NSMutableArray alloc] init];

    for(NSDictionary* sensor in sensors){
        NSDictionary* metadata = [sensor objectForKey:@"metadata"];
        NSString * name = [sensor objectForKey:@"name"];
        NSString * location = [metadata objectForKey:@"location"];
        NSString * sourceName = [sensor objectForKey:@"source_name"];
        NSString * type = [metadata objectForKey:@"type"];
        
        if(!name){
            name = @"No Name";
        }
        
        if(!location){
            location = @"No Location Info";
        }
        
        if(!sourceName){
            sourceName = @"No Source Name";
        }
        
        if(!type){
            type = @"No Type Info";
        }
        
        
        NSDictionary* deviceDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [sensor objectForKey:@"name"], @"uuid",
                                   [metadata objectForKey:@"location"], @"location",
                                   [sensor objectForKey:@"source_name"], @"name",
                                   [metadata objectForKey:@"type"], @"type",
                                   nil
                                   ];
        GVDevice* device = [[GVDevice alloc]initWithDictionary:deviceDic];
        [devices addObject:device];
        
    }
    
    return devices;
}



- (NSArray*) fetchSensorReading:(NSString*)sensorUuid :(NSTimeInterval)startTime :(NSTimeInterval)endTime :(NSString*)resolution
{
    NSString* server = [[GVUserPreferences sharedInstance] giottoServer];
    NSString* port = [[GVUserPreferences sharedInstance]giottoPort];
    NSString* apiPrefix = [[GVUserPreferences sharedInstance]apiPrefix];
    
    NSString* url = [NSString stringWithFormat:@"%@:%@%@/sensor/%@/timeseries?start_time=%f&end_time=%f",
                      server,
                      port,
                      apiPrefix,
                      sensorUuid,
                      startTime,
                     endTime
                     ];
    if(resolution != nil && ![resolution isEqualToString:@""]){
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&resolusion=%@",resolution]];
    }
               
    NSLog(@"%@",url);
    NSString* json = [self fetchDataFrom:url withOAuthToken:_accessToken];
    if(!json){
        return nil;
    }

    NSDictionary * dic = [NSDictionary dictionaryWithJson:json];
    NSDictionary * data = [dic objectForKey:@"data"];
    if(data==nil){
        return nil;
    }
    NSDictionary * readings = [[[dic objectForKey:@"data"] objectForKey:@"series"]objectAtIndex:0];
    NSArray * columns = [readings objectForKey:@"columns"];
    NSUInteger index = [columns indexOfObject:@"value"];
    NSArray * values = [readings objectForKey:@"values"];
    
    NSMutableArray* sensorReadings =[[NSMutableArray alloc]init];
    
    for(NSArray* sample in values){
        NSNumber* reading = [sample objectAtIndex:index];
        if(reading != (id)[NSNull null])
            [sensorReadings addObject:reading];
    }
    
    
    return sensorReadings;
}


#pragma mark -

- (NSString*) fetchDataFrom:(NSString*)url withOAuthToken:(NSString*)token
{
    GV_LOG_VERBOSE(@"HTTP GET", url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSString * tokenHeader = [NSString stringWithFormat:@"Bearer %@", token];
    NSLog(@"%@", tokenHeader);
    if(token != nil){
        [request addValue:tokenHeader forHTTPHeaderField:@"Authorization"];
    }

    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    NSString * response = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];

    NSLog(@"%ld", (long)[responseCode statusCode]);
    
    if([responseCode statusCode] != 200){
        NSString * errorMessage = [NSString stringWithFormat:@"Error getting %@, HTTP status code %li",
                                   url,
                                   (long)[responseCode statusCode]
                                   ];
        
        GV_LOG_ERROR(@"HTTP Error", errorMessage);
        return nil;
    }

    //NSString * response = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    GV_LOG_VERBOSE(@"HTTP Respose", response);

    return response;
}

@end
