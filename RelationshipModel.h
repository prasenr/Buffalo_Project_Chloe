//
//  NSObject+RelationshipModel.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/16/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>
#import "NSObject+PersonModel.h"

@interface RelationshipModel : MTLModel <MTLJSONSerializing>
@property(nonatomic, strong) PersonModel *person;
@property(nonatomic, strong) NSMutableString *relationshipType;
@end
