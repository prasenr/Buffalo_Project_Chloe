//
//  NSObject+TodaySummaryItems.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/29/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Mantle.h>

@interface TodaySummaryItems :MTLModel <MTLJSONSerializing>

@property(nonatomic, strong) NSString *weatherImagePath;
@property(nonatomic, strong) NSString *whatWeDid;
@property(nonatomic, strong) NSString *todosMeetingSummary;
@property(nonatomic, strong) NSString *todosMeetingSummaryIconPath;
@end
