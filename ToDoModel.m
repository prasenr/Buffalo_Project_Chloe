//
//  NSObject+ToDoModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/5/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ToDoModel.h"

@implementation ToDoModel:MTLModel

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"todoid": @"todoid",
             @"todo": @"todo",
             @"startDate": @"startDate",
             @"endDate": @"endDate",
             @"locationName": @"location",
             @"locationLatLon": @"locationLatLon",
             @"isComplete": @"isComplete",
             @"listItem":@"listItems"
             };
}

+(NSValueTransformer *) dateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
    } reverseBlock:^(NSDate *date) {
        return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    }];
}

+(NSValueTransformer *) startDateJSONTransformer {
    return [self dateJSONTransformer];
}

+(NSValueTransformer *) endDateJSONTransformer {
    return [self dateJSONTransformer];
}
@end
