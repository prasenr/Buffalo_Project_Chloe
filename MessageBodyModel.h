//
//  NSObject+MessageBodyModel.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 8/11/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface MessageBodyModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSMutableString *encoding;
@property (nonatomic, strong) NSMutableString *message;
@end
