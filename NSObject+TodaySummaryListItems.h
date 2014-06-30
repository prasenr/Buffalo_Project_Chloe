//
//  NSObject+TodaySummaryListItems.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 5/20/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Mantle.h>

@interface TodaySummaryListItems : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *summaryItemid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *summaryItem;
@property (nonatomic, strong) NSDate *start_date;
@property (nonatomic, strong) NSDate *end_date;
@property (nonatomic, strong) NSArray *listItems;
@property (nonatomic, strong) NSString *locatioName;
@property (nonatomic, strong) NSArray *locationLatLon;
@property (nonatomic, assign) BOOL isCompleted;

@end
