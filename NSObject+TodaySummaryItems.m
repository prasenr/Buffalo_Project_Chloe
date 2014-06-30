//
//  NSObject+TodaySummaryItems.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/29/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "NSObject+TodaySummaryItems.h"

@implementation TodaySummaryItems : MTLModel

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"weatherImagePath": @"weatherImagePath",
             @"whatWeDid": @"whatwedid",
             @"todosMeetingSummary": @"todosMeetingSummary",
             @"todosMeetingSummaryIconPath": @"todosMeetingSummaryIconPath"
             };
}


@end
