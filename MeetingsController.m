//
//  NSObject+MeetingsController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/5/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "MeetingsController.h"
#import "NSObject+MeetingClient.h"
#import "NSObject+MeetingModel.h"
#import <TSMessages/TSMessage.h>
#import "NSObject+TodaySummary_Controller.h"

@interface MeetingsController()
@property(nonatomic, strong, readwrite)NSMutableArray *meetings;
@property (nonatomic, strong, readwrite) NSNumber *fetchMeetingsTrigger;
@property (nonatomic, strong) MeetingClient *client;

@end

@implementation MeetingsController : NSObject

+(instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(id)init {
    if (self= [super init]) {
        
        self.fetchMeetingsTrigger = 0;
        
        _client = [[MeetingClient alloc] init];
        
        [[[[RACObserve(self, self.fetchMeetingsTrigger)
            ignore:nil]
           
           flattenMap:^(MeetingModel *newMeetingItem) {
               return [RACSignal merge:@[
                                         [self updateMeetings]
                                         ]];
               
           }] deliverOn:RACScheduler.mainThreadScheduler]
         
         subscribeError:^(NSError *error) {
             [TSMessage showNotificationWithTitle:@"Error" subtitle:@"There was a problem fetching meetings" type:TSMessageNotificationTypeError];
         }];

        
    }
    return self;
}


-(RACSignal *) updateMeetings {
    return [[self.client fetchMeetings] doNext:^(NSMutableArray *incomingMeetingItems) {
        [[TodaySummary_Controller sharedManager] addMeetings:incomingMeetingItems];
        self.meetings = [NSMutableArray arrayWithArray:incomingMeetingItems];
    }];
}

-(void)fetchMeetings {
    int value = [self.fetchMeetingsTrigger intValue];
    self.fetchMeetingsTrigger = [NSNumber numberWithInt:value + 1];
}
@end
