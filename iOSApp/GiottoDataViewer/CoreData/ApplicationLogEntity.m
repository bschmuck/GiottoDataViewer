//
//  ApplicationLogEntity.m
//  GiottoDataViewer
//
//  Created by Eiji Hayashi on 3/20/16.
//  Copyright © 2016 Eiji Hayashi. All rights reserved.
//

#import "ApplicationLogEntity.h"

@implementation ApplicationLogEntity

- (NSString*) timestampString
{
    NSString *timestampString;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd HH:mm:ss"];
    
    timestampString = [format stringFromDate:self.timestamp];
    
    return timestampString;
}

- (NSString*) dateString
{
    NSString *timestampString;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd"];
    
    timestampString = [format stringFromDate:self.timestamp];
    
    return timestampString;
}

- (NSString*) timeString
{
    NSString *timestampString;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm:ss"];
    
    timestampString = [format stringFromDate:self.timestamp];
    
    return timestampString;
}

- (NSString*) levelString
{
    NSString *levelString = @"";
    
    if( [self.level intValue] == 0 ){
        levelString = @"Verbose";
    }
    else if ([self.level intValue] == 2 ){
        levelString = @"Info";
    }
    else if ([self.level intValue] == 4 ){
        levelString = @"Data";
    }
    else if ([self.level intValue] == 6 ){
        levelString = @"Warning";
    }
    else if ([self.level intValue] == 8 ){
        levelString = @"Error";
    }
    
    return levelString;
}

- (NSDictionary*)dictionary
{
    NSTimeInterval interval = [self.timestamp timeIntervalSince1970];
    NSNumber *time = [NSNumber numberWithDouble:interval];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:time, @"timestamp",
                         [self dateString], @"date_string",
                         [self timeString], @"time_string",
                         self.level, @"level",
                         self.levelString, @"level_string",
                         self.message, @"message",
                         self.detail, @"detail",
                         nil];
    
    return dic;
}

@end
