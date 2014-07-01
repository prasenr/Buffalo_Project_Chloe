//
//  NSObject+ContactAddressSearchController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import "AddressSearchModel.h"

@interface ContactAddressSearchController : NSObject
+(instancetype)sharedManager;

@property (nonatomic, strong, readonly) NSMutableArray *searchResults;
@property (nonatomic, strong, readonly) NSNumber *fetchSearchAddressTrigger;
-(void)fetchSearchResults:(NSString *)searchText;
@end
