//
//  ContactFacebookAccountListViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/16/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+PersonModel.h"
#import "FacebookAccountHistoryModel.h"

@interface ContactFacebookAccountListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
-(void) person:(PersonModel *)person;
-(void) addFacebookAccount:(FacebookAccountHistoryModel *)facebookAccount;
@end
