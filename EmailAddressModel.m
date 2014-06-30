//
//  NSObject+EmailAddressModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/16/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "EmailAddressModel.h"

@implementation EmailAddressModel : MTLModel
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"type": @"type",
             @"emailType" : @"emailType",
             @"emailAddress": @"emailAddress"
             };
}

@end
