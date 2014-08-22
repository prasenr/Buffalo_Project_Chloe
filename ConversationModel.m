//
//  ConversationModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 8/10/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ConversationModel.h"
#import "YoMessage.h"

@implementation ConversationModel 
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"conversationId"          :   @"conversationId",
             @"messages"                :   @"messages"
             };
}

+ (NSValueTransformer *)messagesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[YoMessage class]];
}
@end
