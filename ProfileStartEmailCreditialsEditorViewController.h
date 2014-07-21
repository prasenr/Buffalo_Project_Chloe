//
//  ProfileStartEmailCreditialsEditorViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 7/19/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmailAddressHistoryModel.h"

@interface ProfileStartEmailCreditialsEditorViewController : UIViewController
@property (nonatomic, strong) EmailAddressHistoryModel *emailAccount;
-(void)addAccount:(EmailAddressHistoryModel *)emailAccount;
@end
