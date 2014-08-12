//
//  NSObject+YoMessage.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 8/11/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "YoMessage.h"
#import "MessageBodyModel.h"

@implementation YoMessage: MTLModel

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"seqno"                   :   @"seqno",
             @"header"                  :   @"header",
             @"subject":@"subject",
             @"messageDate":@"messageDate",
             @"tos":@"tos",
             @"ccs":@"ccs",
             @"bccs":@"bccs",
             @"body":@"body",
             @"messageBodies":@"messageBodies",
             @"boundary":@"boundary"
 
             };
}

+(NSValueTransformer *) dateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
    } reverseBlock:^(NSDate *date) {
        return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    }];
}

+ (NSValueTransformer *)messageBodiesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MessageBodyModel class]];
}

/*+ (NSValueTransformer *)tosJSONTransformer {
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[NSString class]];
}

+ (NSValueTransformer *)messageBodiesJSONTransformer {
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[NSString class]];
}*/


+(NSValueTransformer *) messageDateJSONTransformer {
    return [self dateJSONTransformer];
}

@end
