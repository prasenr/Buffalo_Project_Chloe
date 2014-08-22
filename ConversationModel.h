//
//  ConversationModel.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 8/10/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface ConversationModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSMutableString *conversationId;
@property (nonatomic, strong) NSMutableArray *messages;
@end
