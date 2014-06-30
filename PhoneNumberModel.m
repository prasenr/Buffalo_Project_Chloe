//
//  NSObject+PhoneNumberModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/16/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "PhoneNumberModel.h"

@implementation PhoneNumberModel : MTLModel
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"type": @"type",
             @"country": @"country",
             @"areaCode": @"areaCode",
             @"prefix": @"prefix",
             @"phoneNumber": @"phoneNumber",
             @"extension" : @"extension"
             };
}

@end
