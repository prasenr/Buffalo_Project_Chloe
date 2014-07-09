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
#import "ContactPhoneNumberListViewViewController.h"
#import "PhoneNumberEditorViewController.h"
#import "ContactEmailAddressListViewController.h"
#import "EmailAddressEditorViewController.h"
#import "ContactInstantMessengerListViewController.h"
#import "InstantMessengerEditorViewController.h"
#import "ContactRelationshipsListViewController.h"
#import "ContactTwitterAccountListViewController.h"
#import "TwitterEditorViewController.h"
#import "ContactLinkedInAccountListViewController.h"
#import "LinkedInEditorViewController.h"
#import "ContactGooglePlusAccountListViewController.h"
#import "GooglePlusEditorViewController.h"
#import "ContactFacebookAccountListViewController.h"
#import "FacebookEditorViewController.h"
#import "ContactBirthdayEditorViewController.h"

@interface ContactProfileConversationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    ContactAddressListViewController *contactAddressListView;
    AddressEditorViewController *contactAddressEditorView;
    ContactPhoneNumberListViewViewController *contactPhoneNumberListView;
    PhoneNumberEditorViewController *contactPhoneNumberEditorView;
    ContactEmailAddressListViewController *contactEmailListView;
    EmailAddressEditorViewController *contactEmailAddressEditor;
    ContactInstantMessengerListViewController *contactInstantMessengerListView;
    InstantMessengerEditorViewController *contactInstantMessengerEditorView;
    ContactRelationshipsListViewController *contactRelationshipsListView;
    ContactTwitterAccountListViewController *contactTwitterListView;
    TwitterEditorViewController *contactTwitterEditorView;
    ContactLinkedInAccountListViewController *contactLinkedInListView;
    LinkedInEditorViewController *contactLinkedInEditorView;
    ContactGooglePlusAccountListViewController *contactGooglePlusListView;
    GooglePlusEditorViewController *contactGooglePlusEditorView;
    ContactFacebookAccountListViewController *contactFacebookListView;
    FacebookEditorViewController *contactFacebookEditorView;
    ContactRelationshipsListViewController *contactRelationshipListView;
    ContactBirthdayEditorViewController *contactBirthdayEditor;
}

-(id)initWithPerson:(PersonModel *)person initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void)createNameLabels;
-(void)createAddressLabel;
-(void)createButtons;
@end
