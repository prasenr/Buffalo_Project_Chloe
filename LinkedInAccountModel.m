//
//  NSObject+LinkedInAccountModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/16/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "LinkedInAccountModel.h"

@implementation LinkedInAccountModel : MTLModel
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"type": @"type",
             @"username": @"username"
             };
}

@end
