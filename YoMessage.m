//
//  NSObject+YoMessage.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 8/11/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "YoMessage.h"
#import "MessageBodyModel.h"
#import "NSObject+PersonModel.h"

@implementation YoMessage: MTLModel

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"seqno"                   :   @"seqno",
             @"header"                  :   @"header",
             @"subject"                 :   @"subject",
             @"messageDate"             :   @"messageDate",
             @"tos"                     :   @"tos",
             @"ccs"                     :   @"ccs",
             @"bccs"                    :   @"bccs",
             @"body"                    :   @"body",
             @"messageBodies"           :   @"messageBodies",
             @"boundary"                :   @"boundary",
             @"froms"                   :   @"froms",
             @"messageStatus"           :   @"messageStatus"
 
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

-(MessageBodyModel *)plainTextMessage {
    int a = 0;
    int b = [self.messageBodies count];
    for(;a<b;a++) {
        MessageBodyModel *possibleMessage = [self.messageBodies objectAtIndex:a];
        if([possibleMessage.encoding isEqual: @"text"]) {
            return possibleMessage;
        }
        
    }
    
    return [self.messageBodies objectAtIndex:0];
}

/*+ (NSValueTransformer *)fromsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PersonModel class]];
}

+ (NSValueTransformer *)tosJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[PersonModel class]];
}*/



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
