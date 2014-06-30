//
//  MainViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/28/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayViewController.h"
#import "ContactsViewController.h"
#import "MeetingsViewController.h"
#import "TodosViewController.h"
#import "NSObject+TodaySummary_Controller.h"
#import "ProfileViewController.h"
#import "ConversationsViewController.h"
#import "ContactProfileConversationViewController.h"
#import "ContactRelationshipsListViewController.h"
#import "ContactTwitterAccountListViewController.h"
#import "TwitterEditorViewController.h"
#import "ContactLinkedInAccountListViewController.h"
#import "LinkedInEditorViewController.h"
#import "ContactGooglePlusAccountListViewController.h"
#import "GooglePlusEditorViewController.h"
#import "ContactFacebookAccountListViewController.h"
#import "FacebookEditorViewController.h"
#import "ContactInstantMessengerListViewController.h"
#import "InstantMessengerEditorViewController.h"
#import "ContactEmailAddressListViewController.h"
#import "EmailAddressEditorViewController.h"
#import "ContactPhoneNumberListViewViewController.h"
#import "PhoneNumberEditorViewController.h"
#import "ContactAddressListViewController.h"
#import "AddressEditorViewController.h"
#import "ContactBirthdayEditorViewController.h"
#import "ContactRelationshipsListViewController.h"

@interface MainViewController : UIViewController <UIScrollViewDelegate> {
    TodayViewController *todayView;
    ContactsViewController *contactsView;
    ContactProfileConversationViewController *contactProfileConversationView;
    MeetingsViewController *meetingView;
    TodosViewController *toDoView;
    ConversationsViewController *conversationsView;
    ProfileViewController *profileView;
    
    ContactRelationshipsListViewController *contactRelationshipsListView;
    ContactTwitterAccountListViewController *contactTwitterListView;
    TwitterEditorViewController *contactTwitterEditorView;
    ContactLinkedInAccountListViewController *contactLinkedInListView;
    LinkedInEditorViewController *contactLinkedInEditorView;
    ContactGooglePlusAccountListViewController *contactGooglePlusListView;
    GooglePlusEditorViewController *contactGooglePlusEditorView;
    ContactFacebookAccountListViewController *contactFacebookListView;
    FacebookEditorViewController *contactFacebookEditorView;
    ContactInstantMessengerListViewController *contactInstantMessengerListView;
    InstantMessengerEditorViewController *contactInstantMessengerEditorView;
    ContactEmailAddressListViewController *contactEmailListView;
    EmailAddressEditorViewController    *contactEmailAddressEditor;
    ContactPhoneNumberListViewViewController *contactPhoneNumberListView;
    PhoneNumberEditorViewController *contactPhoneNumberEditorView;
    
    ContactRelationshipsListViewController *contactRelationshipListView;
    ContactBirthdayEditorViewController *contactBirthdayEditor;
   
    UISwipeGestureRecognizer *todayGestureLeft;
    UISwipeGestureRecognizer *todayGestureRight;
    UISwipeGestureRecognizer *contactGestureLeft;
    UISwipeGestureRecognizer *contactGestureRight;
    UISwipeGestureRecognizer *allConversationsGestureRight;
    UISwipeGestureRecognizer *toDoGestureLeft;
    UISwipeGestureRecognizer *toDoGestureRight;
    UISwipeGestureRecognizer *meetingGestureLeft;
    UISwipeGestureRecognizer *meetingGestureRight;
    UISwipeGestureRecognizer *profileGestureLeft;
}



@end
