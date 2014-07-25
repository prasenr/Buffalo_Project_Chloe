//
//  JSONModel+UserProfileModel.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 7/14/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Mantle.h>

@interface UserProfileModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, nonatomic) NSString* profileID;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSMutableString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSMutableArray *names;
@property (nonatomic, strong) NSMutableArray *emailAddresses;
@property (nonatomic, strong) NSMutableArray *instantMessengerAccounts;
@property (nonatomic, strong) NSMutableArray *phoneNumbers;
@property (nonatomic, strong) NSMutableArray *addresses;
@property (nonatomic, strong) NSMutableArray *calendars;
@property (nonatomic, strong) NSMutableArray *facebookAccounts;
@property (nonatomic, strong) NSMutableArray *googlePlusAccounts;
@property (nonatomic, strong) NSMutableArray *linkedInAccounts;
@property (nonatomic, strong) NSMutableArray *twitterAccounts;
@property (nonatomic, strong) NSMutableArray *relationships;
@property (nonatomic, strong) NSString *personImage;
@property (nonatomic, strong) NSString *personBigImage;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@end
