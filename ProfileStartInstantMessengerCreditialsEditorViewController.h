//
//  ProfileStartInstantMessengerCreditialsEditorViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 7/19/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstantMessengerAccountHistoryModel.h"

@interface ProfileStartInstantMessengerCreditialsEditorViewController : UIViewController
@property (nonatomic, strong) InstantMessengerAccountHistoryModel *instantMessengerAccount;
-(void)addAccount:(InstantMessengerAccountHistoryModel *)instantMessengerAccount;
@end
