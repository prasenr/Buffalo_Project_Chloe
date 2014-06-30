//
//  NSObject+MeetingClient.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/5/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "NSObject+MeetingClient.h"
#import "NSObject+MeetingModel.h"

@interface MeetingClient()
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation MeetingClient : NSObject

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

-(RACSignal *) fetchMeetings {
    NSString *urlString = @"http://api.buffalop.com/meetings/";
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        RACSequence *list = [json[@"meetings"] rac_sequence];
        
        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass: [MeetingModel class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

@end
