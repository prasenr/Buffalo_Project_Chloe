//
//  NSObject+MeetingsController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/5/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import "NSObject+MeetingModel.h"

@interface MeetingsController: NSObject
+(instancetype)sharedManager;

@property (nonatomic, strong, readonly) NSMutableArray *meetings;
@property (nonatomic, strong, readonly) NSNumber *fetchMeetingsTrigger;
-(void)fetchMeetings;
@end
