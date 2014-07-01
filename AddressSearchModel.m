//
//  NSObject+AddressSearchModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "AddressSearchModel.h"

@implementation AddressSearchModel : MTLModel

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"addressLine1": @"addressLine1",
             @"addressLine2": @"addressLine2",
             @"city": @"city",
             @"state": @"state",
             @"zipcode": @"zipcode"
             };
}
@end
