//
//  NSObject+YoMessage.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 8/11/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface YoMessage : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong)NSMutableString *seqno;
@property (nonatomic, strong)NSMutableString *header;
@property (nonatomic, strong)NSMutableString *subject;
@property (nonatomic, strong)NSDate *messageDate;
@property (nonatomic, strong)NSMutableArray *tos;
@property (nonatomic, strong)NSMutableArray *ccs;
@property (nonatomic, strong)NSMutableArray *bccs;
@property (nonatomic, strong)NSMutableString *body;
@property (nonatomic, strong)NSMutableArray *messageBodies;
@property (nonatomic, strong)NSMutableString *boundary;
@property (nonatomic, strong)NSMutableArray *froms;
@property (nonatomic, strong)NSString *messageStatus;
@end
