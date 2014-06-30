//
//  NSObject+WeatherClient.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/29/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "NSObject+WeatherClient.h"
#import "MTLModel+WeatherCondition.h"
#import "WeatherCondition+DailyForecastModel.h"

@interface  WeatherClient()

@property (nonatomic, strong) NSURLSession *session;

@end
@implementation WeatherClient :NSObject

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

-(RACSignal *) fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial", coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        return [MTLJSONAdapter modelOfClass: [WeatherCondition class] fromJSONDictionary:json error:nil];
    }];
}

-(RACSignal *) fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial", coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        RACSequence *list = [json[@"list"] rac_sequence];
        
        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[WeatherCondition class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

-(RACSignal *) fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=imperial", coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        RACSequence *list = [json[@"list"] rac_sequence];
        
        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[DailyForecastModel class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}
@end