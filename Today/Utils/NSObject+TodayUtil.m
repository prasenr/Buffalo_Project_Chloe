//
//  NSObject+TodayUtil.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/29/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "NSObject+TodayUtil.h"

@implementation TodayUtil

static NSString *yoweatherAPIid = @"d6ed26157a5738db1bff7b5db13f32d2";

+ (NSString *)weatherAPIId {
    return yoweatherAPIid;
}
@end
