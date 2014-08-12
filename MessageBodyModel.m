//
//  NSObject+MessageBodyModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 8/11/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "MessageBodyModel.h"

@implementation MessageBodyModel : MTLModel

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"encoding"                   :   @"encoding",
             @"message"                  :   @"message"
             };
}
@end
