//
//  UserProfileViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 7/10/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileModel.h"
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

@interface UserProfileViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
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
-(void)addProfile:(UserProfileModel *)userProfile;
-(void)createNewProfile;
-(void)createNameLabels;
-(void)createAddressLabel;
-(void)createButtons;
@end
