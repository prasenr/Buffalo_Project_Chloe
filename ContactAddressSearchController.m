//
//  NSObject+ContactAddressSearchController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ContactAddressSearchController.h"
#import "ContactAddressSearchClient.h"
#import <TSMessages/TSMessage.h>
#import "AddressSearchModel.h"

@interface ContactAddressSearchController()
@property (nonatomic, strong) NSString *searchText;
@property(nonatomic, strong, readwrite)NSMutableArray *searchResults;
@property (nonatomic, strong, readwrite) NSNumber *fetchSearchAddressTrigger;
@property (nonatomic, strong) ContactAddressSearchClient *client;

@end

@implementation ContactAddressSearchController : NSObject

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
        
        self.fetchSearchAddressTrigger = 0;
        
        _client = [[ContactAddressSearchClient alloc] init];
        
        [[[[RACObserve(self, self.fetchSearchAddressTrigger)
            ignore:nil]
           
           flattenMap:^(AddressSearchModel *newSearchResult) {
               return [RACSignal merge:@[
                                         [self updateSearchResults]
                                         ]];
               
           }] deliverOn:RACScheduler.mainThreadScheduler]
         
         subscribeError:^(NSError *error) {
             [TSMessage showNotificationWithTitle:@"Error" subtitle:@"There was a problem fetching address search results" type:TSMessageNotificationTypeError];
         }];
        
        
    }
    return self;
}

-(RACSignal *) updateSearchResults {
    return [[self.client fetchAddressSearchResults:self.searchText] doNext:^(NSMutableArray *incomingSearchResults) {
        [ContactAddressSearchController sharedManager].searchResults = incomingSearchResults;
         }];
}

-(void)fetchSearchResults:(NSString *)searchText{
    self.searchText = searchText;
    int value = [self.fetchSearchAddressTrigger intValue];
    self.searchResults = [[NSMutableArray alloc] init];
    self.fetchSearchAddressTrigger = [NSNumber numberWithInt:value + 1];
}
@end
