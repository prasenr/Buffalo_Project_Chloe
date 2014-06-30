//
//  NSObject+ToDoController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/6/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import "ToDoModel.h" 

@interface ToDoController : NSObject
+(instancetype)sharedManager;

@property (nonatomic, strong, readonly) NSMutableArray *todos;
@property (nonatomic, strong, readonly) NSNumber *fetchToDosTrigger;
-(void)fetchToDos;
@end
