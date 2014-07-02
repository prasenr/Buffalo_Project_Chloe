//
//  NSObject+AddressModel.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/12/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface AddressModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSMutableString *addressLine1;
@property (nonatomic, strong) NSMutableString *addressLine2;
@property (nonatomic, strong) NSMutableString *city;
@property (nonatomic, strong) NSMutableString *state;
@property (nonatomic, strong) NSMutableString *county;
@property (nonatomic, strong) NSMutableString *zipcode;
@property (nonatomic, strong) NSMutableString *country;
@end
