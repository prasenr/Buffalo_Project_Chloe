//
//  NSObject+TodaySummaryClient.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "NSObject+TodaySummaryClient.h"
#import "NSObject+TodaySummaryItems.h"
#import "NSObject+TodaySummaryListItems.h"

@interface  TodaySummaryClient()

@property (nonatomic, strong) NSURLSession *session;

@end
@implementation TodaySummaryClient :NSObject

-(id) init {
    if(self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    
    return self;
}

-(RACSignal *)fetchJSONFromURL:(NSURL *)url {
   // NSLog(@"Fetching: %@", url.absoluteString);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if(!error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                if(!jsonError) {
                    [subscriber sendNext:json];
                } else {
                    [subscriber sendError:jsonError];
                }
            } else {
                [subscriber sendError:error];
            }
            
            [subscriber sendCompleted];
        }];
        
        [dataTask resume];
        
        return [RACDisposable disposableWithBlock:^ {
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(RACSignal *)fetchTodayWeather:(NSString *)dwkey :(NSString *)publickey {
    NSString *urlString = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&units=imperial", dwkey, publickey];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        
        return [MTLJSONAdapter modelOfClass: [TodaySummaryItems class] fromJSONDictionary:json error:nil];
    }];
}

-(RACSignal *) fetchTodaySummary {
    NSString *urlString = @"http://api.buffalop.com/today/summary/";
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        return [MTLJSONAdapter modelOfClass:[TodaySummaryItems class] fromJSONDictionary:json[@"data"] error:nil];
    }];
}

@end
