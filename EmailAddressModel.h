//
//  NSObject+EmailAddressModel.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/16/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface EmailAddressModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSMutableString *type;
@property (nonatomic, strong) NSMutableString *emailType;
@property (nonatomic, strong) NSMutableString *emailAddress;
@end
