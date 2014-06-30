//
//  NSObject+TodaySummary_Controller.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+TodaySummaryItems.h"
#import "ToDoModel.h"
#import "NSObject+MeetingModel.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>

@interface TodaySummary_Controller :NSObject
+(instancetype)sharedManager;

@property (nonatomic, strong, readonly) TodaySummaryItems *currentTodaySummary;
@property (nonatomic, strong, readonly) NSMutableArray *todaySummaryListItems;
@property (nonatomic, strong, readonly) NSNumber *fetchTodaySummaryTrigger;
@property (nonatomic, strong, readonly) NSMutableArray *rawMeetings;
@property (nonatomic, strong, readonly) NSMutableDictionary *allMeetingsSorted;
@property (nonatomic, strong, readonly) NSMutableArray *rawToDos;
@property (nonatomic, strong, readonly) NSMutableDictionary *allToDosSorted;

-(void)fetchTodaySummary;
-(void)addMeetings:(NSMutableArray *)meetings;
-(void)addToDos:(NSMutableArray *)todos;
-(void)sortMeetings;
-(void)sortToDos;
-(void)createTodayTodosMeetings;
-(void)completeToDo:(ToDoModel *)listItem;
-(void)deleteToDo:(ToDoModel *)listItem;
-(void)completeMeeting:(MeetingModel *)meeting;
-(void)deleteMeeting:(MeetingModel *)meeting;
-(void)helpMe;
@end
