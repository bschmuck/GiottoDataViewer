//
//  GVDevice.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import "GVDevice.h"

@implementation GVDevice

- (id) initWithDictionary:(NSDictionary*)dic
{
    _name = (NSString*)[dic objectForKey:@"name"];
    _uuid = (NSString*)[dic objectForKey:@"uuid"];
    _location = (NSString*)[dic objectForKey:@"location"];
    _type = (NSString*)[dic objectForKey:@"type"];
    
    return self;
}

@end
