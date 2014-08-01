//
//  NSObject+InstantMessengerAccountHistoryModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/17/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "InstantMessengerAccountHistoryModel.h"
#import "InstantMessengerModel.h"

@implementation InstantMessengerAccountHistoryModel : MTLModel
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"startDate": @"startDate",
             @"endDate": @"endDate",
             @"account" : @"account"
             };
}

+ (NSValueTransformer *)appURLSchemeJSONTransformer {
    // use Mantle's built-in "value transformer" to convert strings to NSURL and vice-versa
    // you can write your own transformers
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+(NSValueTransformer *) dateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
    } reverseBlock:^(NSDate *date) {
        return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    }];
}

+ (NSValueTransformer *)accountJSONTransformer {
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[InstantMessengerModel class]];
}

+(NSValueTransformer *) startDateJSONTransformer {
    return [self dateJSONTransformer];
}

+(NSValueTransformer *) endDateJSONTransformer {
    return [self dateJSONTransformer];
}
@end
