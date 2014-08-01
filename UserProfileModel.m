//
//  JSONModel+UserProfileModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 7/14/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "UserProfileModel.h"
#import "EmailAddressHistoryModel.h"
#import "InstantMessengerAccountHistoryModel.h"
#import"AddressHistoryModel.h"
#import "PhoneNumberHistoryModel.h"
#import "FacebookAccountHistoryModel.h"
#import "GooglePlusAccountHistoryModel.h"
#import "LinkedInAccountHistoryModel.h"
#import "TwitterAccountHistoryModel.h"
#import "RelationshipHistoryModel.h"

@implementation UserProfileModel : MTLModel

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
             @"password"                    :   @"password"
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

+(NSValueTransformer *) birthdayJSONTransformer {
    return [self dateJSONTransformer];
}

+ (NSValueTransformer *)emailAddressesJSONTransformer {
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[EmailAddressHistoryModel class]];
}

+ (NSValueTransformer *)instantMessengerAccountsJSONTransformer {
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[InstantMessengerAccountHistoryModel class]];
}

+ (NSValueTransformer *)phoneNumbersJSONTransformer {
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PhoneNumberHistoryModel class]];
}
+ (NSValueTransformer *)addressesJSONTransformer {
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[AddressHistoryModel class]];
}

+ (NSValueTransformer *)facebookAccountsJSONTransformer {
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FacebookAccountHistoryModel class]];
}

+ (NSValueTransformer *)googlePlusAccountsJSONTransformer {
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[GooglePlusAccountHistoryModel class]];
}

+ (NSValueTransformer *)linkedInAccountsJSONTransformer {
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[LinkedInAccountHistoryModel class]];
}

+ (NSValueTransformer *)twitterAccountsJSONTransformer {
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[TwitterAccountHistoryModel class]];
}

+ (NSValueTransformer *)relationshipsJSONTransformer {
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[RelationshipHistoryModel class]];
}


@end

