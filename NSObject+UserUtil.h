//
//  NSObject+UserUtil.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserUtil :NSObject

-(NSString *) getUserPublicKey;
-(NSString *) getUserDWKey;
-(void) produceKeys;
@end
