//
//  NSArray+JSON.h
//  UniAuthServer
//
//  Created by Eiji Hayashi on 1/9/14.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (JSON)
-(NSString*) JsonString: (BOOL) prettyPrinted;
+(NSArray*) arrayWithJson:(NSString*)jsonString;

@end
