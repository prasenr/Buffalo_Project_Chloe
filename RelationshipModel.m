//
//  NSObject+RelationshipModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/16/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "RelationshipModel.h"

@implementation RelationshipModel : MTLModel

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"person": @"person",
             @"relationshipType": @"relationshipType"
             };
}
@end
