//
//  GVDevice.h
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVDevice : NSObject

@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSString * uuid;
@property (nonatomic, readonly) NSString * location;
@property (nonatomic, readonly) NSString * type;

- (id) initWithDictionary:(NSDictionary*)dic;

@end
