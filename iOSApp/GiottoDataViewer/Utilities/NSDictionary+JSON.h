//
//  NSDictionary+JSON.h
//  UniAuthServer
//
//  Created by Eiji Hayashi on 1/9/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)
+(NSDictionary*) dictionaryWithJson:(NSString*)jsonString;
-(NSString*) JsonString: (BOOL) prettyPrinted;
@end