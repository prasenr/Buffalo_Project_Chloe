//
//  PersonModel.m
//  Buffalo Project 2
//
//  Created by Christopher Fisher on 8/15/13.
//  Copyright (c) 2013 Christopher Fisher. All rights reserved.
//

#import "NSObject+PersonModel.h"

@implementation PersonModel : MTLModel

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"profileID"                   :   @"profileID",
             @"firstName"                   :   @"firstName",
             @"lastName"                    :   @"lastName",
             @"names"                       :   @"names",
             @"emailAddresses"              :   @"emailAddresses",
             @"instantMessengerAccounts"    :   @"instantMessengerAccounts",
             @"phoneNumbers"                :   @"phoneNumbers",
             @"addresses"                   :   @"addresses",
             @"calendars"                   :   @"calendars",
             @"facebookAccounts"            :   @"facebookAccounts",
             @"googlePlusAccounts"          :   @"googlePlusAccounts",
             @"linkedInAccounts"            :   @"linkedInAccounts",
             @"twitterAccounts"             :   @"twitterAccounts",
             @"relationships"               :   @"relationships",
             @"personImage"                 :   @"personImage",
             @"personBigImage"              :   @"personBigImage",
             @"username"                    :   @"userName",
             @"password"                    :   @"password",
             @"numberOfConversations"       :   @"numberOfConversations"
             };
}

@end
