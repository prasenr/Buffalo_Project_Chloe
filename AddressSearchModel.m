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
             @"addressLine1": @"street",
             @"city": @"adminArea5",
             @"county": @"adminArea4",
             @"state": @"adminArea3",
             @"zipcode": @"postalCode",
             @"country" : @"adminArea1",
             @"latitude" : @"latLng.lat",
             @"longitude" : @"latLng.lng"
             };
}
@end