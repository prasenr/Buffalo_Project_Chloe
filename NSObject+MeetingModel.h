//
//  NSObject+MeetingModel.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/5/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Mantle.h>

@interface MeetingModel :MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *meetingId;
@property (nonatomic, strong) NSString *meetingDescription;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSMutableArray *locationLatLon;
@property (nonatomic, strong) NSMutableArray *attendees;
@end
