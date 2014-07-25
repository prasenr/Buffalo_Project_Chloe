//
//  WhoAreYouContactListViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 7/15/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "WhoAreYouPersonModel.h"
#import "UserProfileModel.h"
#import "EmailAddressHistoryModel.h"
#import "EmailAddressModel.h"
#import "AddressHistoryModel.h"
#import "AddressModel.h"
#import "PhoneNumberHistoryModel.h"
#import "PhoneNumberModel.h"
#import "InstantMessengerAccountHistoryModel.h"
#import "InstantMessengerModel.h"
#import "UserProfileModel.h"


@interface WhoAreYouContactListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
-(void)addProfile:(UserProfileModel *)userProfile;
@end
