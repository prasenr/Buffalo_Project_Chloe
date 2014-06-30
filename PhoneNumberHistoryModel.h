//
//  NSObject+PhoneNumberHistoryModel.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/17/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>
#import "PhoneNumberModel.h"

@interface PhoneNumberHistoryModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) PhoneNumberModel *account;
@end
