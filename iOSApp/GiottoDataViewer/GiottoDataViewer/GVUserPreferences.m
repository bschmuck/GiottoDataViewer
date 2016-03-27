//
//  UAUserPreferences.m
//  UniAuthClient
//
//  Created by Eiji Hayashi on 2/14/14.
//  Copyright (c) 2014 Eiji Hayashi. All rights reserved.
//

#import "GVUserPreferences.h"

@implementation GVUserPreferences

#pragma mark - Singleton

static GVUserPreferences *sharedInstance = nil;

+ (GVUserPreferences *)sharedInstance
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

#pragma mark - Init / Dealloc

- (id) init
{
    self = [super init];
    if( self ){
    }
    
    return self;
}

- (void) dealloc
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - accessors

- (NSString*)giottoServer
{
    return [self loadPreference:@"giottoServer" default:@""];
}

- (void) setGiottoServer:(NSString *)giottoServer
{
    [self savePreference:giottoServer forKey:@"giottoServer"];
}

- (NSString*) giottoPort
{
    return [self loadPreference:@"giottoPort" default:@"82"];
}

- (void) setGiottoPort:(NSString *)giottoPort
{
    [self savePreference:giottoPort forKey:@"giottoPort"];
}

- (NSString*) locationEmulation
{
    return [self loadPreference:@"locationEmulation" default:@""];
}

- (void) setLocationEmulation:(NSString *)locationEmulation
{
    [self savePreference:locationEmulation forKey:@"locationEmulation"];
}

- (NSString*) apiPrefix
{
    return [self loadPreference:@"apiPrefix" default:@"/service/api/v1/"];
}

- (void) setApiPrefix:(NSString *)apiPrefix
{
    [self savePreference:apiPrefix forKey:@"apiPrefix"];
}

- (void)save
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - private method

- (id) loadPreference: (NSString*)key default:(id) defaultValue
{
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if( !object )
        object = defaultValue;
    
    return object;
}

- (void) savePreference: (id) object forKey:(NSString*) key
{
    if( object )
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
}


@end
