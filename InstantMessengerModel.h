//
//  NSObject+InstantMessengerModel.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/16/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface InstantMessengerModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSMutableString *type;
@property (nonatomic, strong) NSMutableString *serverType;
@property (nonatomic, strong) NSMutableString *username;
@end
