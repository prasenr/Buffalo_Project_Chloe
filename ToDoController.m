//
//  NSObject+ToDoController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/6/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ToDoController.h"
#import "ToDoClient.h"
#import "ToDoModel.h"
#import <TSMessages/TSMessage.h>
#import "NSObject+TodaySummary_Controller.h"

@interface ToDoController()
@property (nonatomic, strong, readwrite) NSMutableArray *todos;
@property (nonatomic, strong, readwrite) NSNumber *fetchToDosTrigger;
@property (nonatomic, strong) ToDoClient *client;
@end

@implementation ToDoController : NSObject

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
        
        self.fetchToDosTrigger= 0;
        
        _client = [[ToDoClient alloc] init];
        
        [[[[RACObserve(self, self.fetchToDosTrigger)
            ignore:nil]
           
           flattenMap:^(ToDoModel *newToDoItem) {
               return [RACSignal merge:@[
                                         [self updateToDos]
                                         ]];
               
           }] deliverOn:RACScheduler.mainThreadScheduler]
         
         subscribeError:^(NSError *error) {
             [TSMessage showNotificationWithTitle:@"Error" subtitle:@"There was a problem fetching todos" type:TSMessageNotificationTypeError];
         }];
        
        
    }
    return self;
}


-(RACSignal *) updateToDos {
    return [[self.client fetchToDos] doNext:^(NSMutableArray *incomingToDoItems) {
        [[TodaySummary_Controller sharedManager] addToDos:incomingToDoItems];
        self.todos = [NSMutableArray arrayWithArray:incomingToDoItems];
    }];
}

-(void)fetchToDos {
    int value = [self.fetchToDosTrigger intValue];
    self.fetchToDosTrigger = [NSNumber numberWithInt:value + 1];
}
@end
