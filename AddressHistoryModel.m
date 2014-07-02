
//
//  NSObject+AddressHistoryModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/17/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "AddressHistoryModel.h"
#import "AddressModel.h"

@implementation AddressHistoryModel : MTLModel

-(void) initWithAddress:(AddressModel *)address {
    self.account = address;
}
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"startDate": @"person",
             @"endDate": @"relationshipType",
             @"account" : @"account"
             };
}

+(NSValueTransformer *) dateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
    } reverseBlock:^(NSDate *date) {
        return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    }];
}

+(NSValueTransformer *) startDateJSONTransformer {
    return [self dateJSONTransformer];
}

+(NSValueTransformer *) endDateJSONTransformer {
    return [self dateJSONTransformer];
}

-(void) convertFromAddressSearch:(AddressSearchModel *)addressSearch {
    AddressModel *aAddress = [[AddressModel alloc] init];
    aAddress.addressLine1 = addressSearch.addressLine1;
    aAddress.city = addressSearch.city;
    aAddress.state = addressSearch.state;
    aAddress.county = addressSearch.county;
    aAddress.zipcode = addressSearch.zipcode;
    aAddress.country = addressSearch.country;
    self.account = aAddress;
}
@end