//
//  NSObject+PhoneNumberModel.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/16/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface PhoneNumberModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSMutableString *type;
@property (nonatomic, strong) NSMutableString *country;
@property (nonatomic, strong) NSMutableString *areaCode;
@property (nonatomic, strong) NSMutableString *prefix;
@property (nonatomic, strong) NSMutableString *phoneNumber;
@property (nonatomic, strong) NSMutableString *extension;
@end
