//
//  NSObject+WhoAreYouPersonModel.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 7/15/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface WhoAreYouPersonModel : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, assign) int *contactId;
@end
