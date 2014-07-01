//
//  NSObject+ContactAddressSearchClient.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>

@interface ContactAddressSearchClient : NSObject
-(RACSignal *)fetchJSONFromURL :(NSURL *)url;
-(RACSignal *)fetchAddressSearchResults:(NSString *)searchText;
@end
