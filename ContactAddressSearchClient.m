//
//  NSObject+ContactAddressSearchClient.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ContactAddressSearchClient.h"
#import "AddressSearchModel.h"

@interface ContactAddressSearchClient()
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation ContactAddressSearchClient :NSObject

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
                
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions  error:&jsonError];
                
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

-(RACSignal *)fetchAddressSearchResults:(NSString *)searchText{

    NSMutableString *urlString = [NSMutableString stringWithString:@"http://open.mapquestapi.com/geocoding/v1/address?key=Fmjtd%7Cluur20622h%2Cb2%3Do5-9ats5z&inFormat=kvp&outFormat=json&location="];
    NSArray *searchTextArray = [searchText componentsSeparatedByString:@" "];
    for(int i=0; i<[searchTextArray count]; i++) {
        [urlString appendString:[searchTextArray objectAtIndex:i]];
        if(i!= [searchTextArray count]-1) {
            [urlString appendString:@"+"];
        }
    }
    NSLog(@"url string %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        
        NSArray *firstDict = [json objectForKey:@"results"];
        NSDictionary *newObject = [firstDict objectAtIndex:0];
        

        
        RACSequence *list = [newObject[@"locations"] rac_sequence];

        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass: [AddressSearchModel class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

@end
