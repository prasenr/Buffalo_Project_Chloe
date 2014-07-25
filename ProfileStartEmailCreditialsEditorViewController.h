//
//  ProfileStartEmailCreditialsEditorViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 7/19/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmailAddressHistoryModel.h"
#import "InstantMessengerAccountHistoryModel.h"

@interface ProfileStartEmailCreditialsEditorViewController : UIViewController
@property (nonatomic, strong) EmailAddressHistoryModel *emailAccount;
@property (nonatomic, strong) InstantMessengerAccountHistoryModel *instantMessengerAccount;
-(void)addEmailAccount:(EmailAddressHistoryModel *)emailAccount;
-(void)addIMAccount:(InstantMessengerAccountHistoryModel *)instantMessengerAccount;
@end
