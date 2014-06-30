//
//  NSObject+InstantMessengerAccountHistoryModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/17/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "InstantMessengerAccountHistoryModel.h"

@implementation InstantMessengerAccountHistoryModel : MTLModel
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"startDate": @"person",
             @"endDate": @"relationshipType",
             @"account" : @"account"
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
