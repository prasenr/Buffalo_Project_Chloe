//
//  NSObject+InstantMessengerModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/16/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "InstantMessengerModel.h"

@implementation InstantMessengerModel : MTLModel
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"type": @"type",
             @"serverType": @"serverType",
             @"username": @"username"
             };
}

@end
