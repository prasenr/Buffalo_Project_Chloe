//
//  NSObject+ToDoClient.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/6/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>

@interface ToDoClient : NSObject
-(RACSignal *)fetchJSONFromURL :(NSURL *)url;
-(RACSignal *)fetchToDos;
@end
