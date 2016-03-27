//
//  NSArray+JSON.m
//  UniAuthServer
//
//  Created by Eiji Hayashi on 1/9/14.
//
//

#import "NSArray+JSON.h"

@implementation NSArray (JSON)
-(NSString*) JsonString: (BOOL) prettyPrinted
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions) (prettyPrinted ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        jsonString = @"error";
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

+(NSArray*) arrayWithJson:(NSString*)jsonString
{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    
    return json;
}

@end
