//
//  NSObject+TodaySummaryListItems.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 5/20/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "NSObject+TodaySummaryListItems.h"

@implementation TodaySummaryListItems : MTLModel

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"summaryItemid"   :   @"summaryItemid",
             @"type"            :   @"type",
             @"summaryItem"     :   @"summaryItem",
             @"start_date"      :   @"start_date",
             @"end_date"        :   @"end_date",
             @"listItems"       :   @"listItems",
             @"locationName"    :   @"locationName",
             @"locationLatLon"  :   @"locationLatLon",
             @"isComplete"      :   @"isCompleted"
             };
}

+(NSValueTransformer *) dateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
    }reverseBlock: ^(NSDate *date) {
        return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    }];
};

+(NSValueTransformer *) start_dateJSONTransformer {
    return [self dateJSONTransformer];
}

+(NSValueTransformer *) end_dateJSONTransformer {
    return [self dateJSONTransformer];
}
@end
