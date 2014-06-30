//
//  NSObject+TodaySummary_Controller.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "NSObject+TodaySummary_Controller.h"
#import "NSObject+TodaySummaryClient.h"
#import "NSObject+TodaySummaryItems.h"
#import "NSObject+UserUtil.h"
#import "NSObject+MeetingModel.h"
#import "ToDoModel.h"
#import <TSMessages/TSMessage.h>

@interface TodaySummary_Controller()
@property(nonatomic, strong, readwrite)TodaySummaryItems *currentTodaySummary;
@property(nonatomic, strong, readwrite)NSMutableArray *todaySummaryListItems;
@property(nonatomic, strong, readwrite)NSNumber *fetchTodaySummaryTrigger;
@property(nonatomic, strong, readwrite)NSMutableArray *rawMeetings;
@property(nonatomic, strong, readwrite)NSMutableDictionary *allMeetingsSorted;
@property(nonatomic, strong, readwrite)NSMutableArray *rawToDos;
@property(nonatomic, strong, readwrite)NSMutableDictionary *allToDosSorted;

@property (nonatomic, strong) TodaySummaryClient *client;
@property (nonatomic, strong) UserUtil *userUtil;


@end

static NSDateFormatter *dateFormatter = nil;
static NSDateFormatter *timeFormatter = nil;
@implementation TodaySummary_Controller :NSObject

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
        
        self.fetchTodaySummaryTrigger = 0;
        self.todaySummaryListItems = [[NSMutableArray alloc] init];
        self.allMeetingsSorted = [[NSMutableDictionary alloc] init];
        self.allToDosSorted = [[NSMutableDictionary alloc] init];
        
        _client = [[TodaySummaryClient alloc] init];
        
        [[[[RACObserve(self, fetchTodaySummaryTrigger)
            ignore:nil]
           
           flattenMap:^(TodaySummaryItems *newTodaySummaryItem) {
               return [RACSignal merge:@[
                                         [self updateTodaySummary]
                                         ]];
               
           }] deliverOn:RACScheduler.mainThreadScheduler]
         
         subscribeError:^(NSError *error) {
             [TSMessage showNotificationWithTitle:@"Error" subtitle:@"There was a problem fetching today summary" type:TSMessageNotificationTypeError];
         }];
    }
    return self;
}

-(RACSignal *) updateTodayWeather {
    return [[self.client fetchTodayWeather:[self.userUtil getUserDWKey] :[self.userUtil getUserPublicKey] ] doNext:^(TodaySummaryItems *todaySummaryItems){
        self.currentTodaySummary = todaySummaryItems;
    }];
}

-(RACSignal *) updateTodaySummary {
    return [[self.client fetchTodaySummary] doNext:^(TodaySummaryItems *todaySummaryItems) {
        self.currentTodaySummary = todaySummaryItems;
    }];
}

-(void)addMeetings:(NSMutableArray *)meetings {
    self.rawMeetings = meetings;
    [self createTodayTodosMeetings];
    [self sortMeetings];
    
}

-(void)addToDos:(NSMutableArray *)todos {
    self.rawToDos = todos;
    
    /*NSSortDescriptor *startDateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
    NSSortDescriptor *endDateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:startDateSortDescriptor, nil];
    [self.rawToDos sortUsingDescriptors:sortArray];*/
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //NSArray *sortedArray;
    
    self.rawToDos = [[NSMutableArray alloc] initWithArray:[self.rawToDos sortedArrayUsingDescriptors:sortDescriptors] copyItems:YES];
   // NSArray *reverseToDos = [[self.rawToDos reverseObjectEnumerator] allObjects];
    
    //self.rawToDos = [[NSMutableArray alloc] initWithArray:reverseToDos copyItems:NO];
    
    [self createTodayTodosMeetings];
    self.allToDosSorted = [[NSMutableDictionary alloc] init];
    [self sortToDos];
    
    NSSortDescriptor *keySortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"key"
                                                                      ascending:YES];
    NSArray *keySortDescriptors = [[NSArray alloc] initWithObjects:keySortDescriptor, nil];
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];

    for(NSString *aKey in [self.allToDosSorted allKeys]) {
        NSDictionary *aDateDict = [self.allToDosSorted valueForKey:aKey];
        /*keySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"key" ascending:YES comparator:^(id obj1, id obj2) {
            
            if (obj1 > obj2) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if (obj1 < obj2) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];*/

        
        NSArray *allTimeKeys = [aDateDict allKeys];
        
       // sortedArray = [anArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]
        NSArray *sortedKeys = [allTimeKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSMutableDictionary *orderedDictionary = [NSMutableDictionary dictionary];
        
        for (NSString *index in sortedKeys) {
            [orderedDictionary setObject:[aDateDict objectForKey:index] forKey:index];
        }
        
        [tempDict setObject:orderedDictionary forKey:aKey];
        //[self.allToDosSorted setObject:orderedDictionary forKey:aKey];
    }

    NSLog(@"Hello");
}

-(void)completeToDo:(ToDoModel *)listItem {
    int i = 0;
    for(;i<[self.todaySummaryListItems count];i++) {
        NSString *className = NSStringFromClass([[self.todaySummaryListItems objectAtIndex:i] class]);
        if([className  isEqual: @"ToDoModel"]) {
            ToDoModel *possibleListItem =[self.todaySummaryListItems objectAtIndex:i];
            if(possibleListItem.todoid == listItem.todoid) {
                possibleListItem = listItem;
            }
        }
    }
    
    for(ToDoModel __strong *possibleListItem in self.rawToDos) {
        if(listItem.todoid == possibleListItem.todoid) {
            possibleListItem = listItem;
        }
    }
}

-(void)deleteToDo:(ToDoModel *)listItem {
    int i = 0;
    for(;i<[self.todaySummaryListItems count];i++) {
        NSString *className = NSStringFromClass([[self.todaySummaryListItems objectAtIndex:i] class]);
        if([className  isEqual: @"ToDoModel"]) {
            ToDoModel *possibleListItem =[self.todaySummaryListItems objectAtIndex:i];
            if(listItem.todoid == possibleListItem.todoid) {
                [self.todaySummaryListItems removeObjectAtIndex:i];
                break;
            }
        }
        i++;
    }
    
    i = 0;
    
    for(ToDoModel __strong *possibleListItem in self.rawToDos) {
        if(listItem.todoid == possibleListItem.todoid) {
            [self.rawToDos removeObjectAtIndex:i];
            break;
        }
    }
}

-(void)completeMeeting:(MeetingModel *)meeting {
    int i = 0;
    for(;i<[self.todaySummaryListItems count];i++) {
        NSString *className = NSStringFromClass([[self.todaySummaryListItems objectAtIndex:i] class]);
        if([className  isEqual: @"MeetingModel"]) {
            MeetingModel *possibleListItem =[self.todaySummaryListItems objectAtIndex:i];
            if(possibleListItem.meetingId == meeting.meetingId) {
                possibleListItem = meeting;
            }
        }
    }
    
    for(MeetingModel __strong *possibleListItem in self.rawMeetings) {
        if(meeting.meetingId == possibleListItem.meetingId) {
            possibleListItem = meeting;
        }
    }
}

-(void)deleteMeeting:(MeetingModel *)meeting{
    int i = 0;
    for(;i<[self.todaySummaryListItems count];i++) {
        NSString *className = NSStringFromClass([[self.todaySummaryListItems objectAtIndex:i] class]);
        if([className  isEqual: @"MeetingModel"]) {
            MeetingModel *possibleListItem =[self.todaySummaryListItems objectAtIndex:i];
            if(meeting.meetingId == possibleListItem.meetingId) {
                [self.todaySummaryListItems removeObjectAtIndex:i];
                break;
            }
        }
        i++;
    }
    
    i = 0;
    
    for(MeetingModel __strong *possibleListItem in self.rawMeetings) {
        if(meeting.meetingId == possibleListItem.meetingId) {
            [self.rawMeetings removeObjectAtIndex:i];
            break;
        }
    }
}

-(void)helpMe {
    NSLog(@"you mmama");
}

-(void) fetchTodaySummary {
    
    int value = [self.fetchTodaySummaryTrigger intValue];
    self.fetchTodaySummaryTrigger = [NSNumber numberWithInt:value + 1];
}

-(void)createTodayTodosMeetings {
    
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyy"];
    }
    
    self.todaySummaryListItems = [[NSMutableArray alloc] init];
    
    NSDate *today = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSDate *beginningOfTime = [[NSDate alloc] initWithTimeIntervalSince1970:0];

    for (MeetingModel *possibleMeeting in self.rawMeetings) {
        NSString *todayFormatted = [dateFormatter stringFromDate:today];
        NSString *startDateFormatted = [dateFormatter stringFromDate:possibleMeeting.startDate];
        NSString *begininngOfTimeFormatted = [dateFormatter stringFromDate:beginningOfTime];

        if([todayFormatted isEqualToString: startDateFormatted] || [startDateFormatted isEqualToString:begininngOfTimeFormatted]){
            [self.todaySummaryListItems addObject:possibleMeeting];
        }
    }
    
    for(ToDoModel *possibleToDo in self.rawToDos) {
        NSString *todayFormatted = [dateFormatter stringFromDate:today];
        NSString *startDateFormatted = [dateFormatter stringFromDate:possibleToDo.startDate];
        NSString *begininngOfTimeFormatted = [dateFormatter stringFromDate:beginningOfTime];
        if([todayFormatted isEqualToString: startDateFormatted] || [startDateFormatted isEqualToString:begininngOfTimeFormatted]) {
            [self.todaySummaryListItems addObject:possibleToDo];
        }
    }
    
    NSSortDescriptor *startDateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
    NSSortDescriptor *endDateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:startDateSortDescriptor, endDateSortDescriptor, nil];
    [self.todaySummaryListItems sortUsingDescriptors:sortArray];
}

-(NSInteger) daysBetweenDate: (NSDate *)firstDate andDate: (NSDate *)secondDate{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components: NSDayCalendarUnit
                                                      fromDate: firstDate
                                                        toDate: secondDate
                                                       options: 0];
    
    NSInteger days = [components day];
    return days;
}

-(void)sortToDos {
    
    if(timeFormatter == nil){
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"hh:mma"];
    }
    
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyy"];
    }

    for(ToDoModel *newToDo in self.rawToDos) {
        [self aToDoStartDate:[dateFormatter stringFromDate:newToDo.startDate] aToDoStartTime:[timeFormatter stringFromDate:newToDo.startDate] aNewTodo:newToDo];
    }
}

-(void)aToDoStartDate:(NSString *)aDate aToDoStartTime:(NSString*)aTime aNewTodo:(ToDoModel *)newToDo {
    
    if([self.allToDosSorted valueForKey:aDate]==nil) {
        [self.allToDosSorted setObject:[[NSMutableDictionary alloc] init] forKey:aDate];
    }
    
    if([[self.allToDosSorted valueForKey:aDate] valueForKey:aTime] == nil) {
        [[self.allToDosSorted valueForKey:aDate] setObject:[[NSMutableArray alloc] init] forKey:aTime];
    }
    [[[self.allToDosSorted valueForKey:aDate] valueForKey:aTime] addObject:newToDo];
}

-(void)sortMeetings {
    if(timeFormatter == nil){
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"hh:mma"];
    }
    
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyy"];
    }
    
    for(MeetingModel *newMeeting in self.rawMeetings) {
        [self aMeetingStartDate:[dateFormatter stringFromDate:newMeeting.startDate] aMeetingStartTime:[timeFormatter stringFromDate:newMeeting.startDate] aNewMeeting:newMeeting];
    }
}

-(void)aMeetingStartDate:(NSString*)aDate aMeetingStartTime:(NSString*)aTime aNewMeeting:(MeetingModel *)newMeeting{
    
    if([self.allMeetingsSorted valueForKey:aDate]==nil) {
        [self.allMeetingsSorted setObject:[[NSMutableDictionary alloc] init] forKey:aDate];
    }
    
    if([[self.allMeetingsSorted valueForKey:aDate] valueForKey:aTime] == nil) {
        [[self.allMeetingsSorted valueForKey:aDate] setObject:[[NSMutableArray alloc] init] forKey:aTime];
    }
    [[[self.allMeetingsSorted valueForKey:aDate] valueForKey:aTime] addObject:newMeeting];
}

@end
