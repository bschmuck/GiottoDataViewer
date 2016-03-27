//
//  NSDictionary+JSON.m
//  UniAuthServer
//
//  Created by Eiji Hayashi on 1/9/14.
//
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

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

+(NSDictionary*) dictionaryWithJson:(NSString*)jsonString
{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    
    return json;
}
@end
