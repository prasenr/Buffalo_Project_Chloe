//
//  NSObject+TodaySummaryClient.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>

@interface TodaySummaryClient : NSObject
-(RACSignal *)fetchJSONFromURL :(NSURL *)url;
-(RACSignal *)fetchTodayWeather :(NSString *)dwkey : (NSString *)publickey;
-(RACSignal *)fetchTodaySummary;
@end
