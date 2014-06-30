//
//  ContactProfileConversationViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 5/14/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+PersonModel.h"
#import "ContactAddressListViewController.h"
#import "AddressEditorViewController.h"

@interface ContactProfileConversationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    ContactAddressListViewController *contactAddressListView;
    AddressEditorViewController *contactAddressEditorView;
}

-(id)initWithPerson:(PersonModel *)person initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void)createNameLabels;
-(void)createAddressLabel;
-(void)createButtons;
@end
