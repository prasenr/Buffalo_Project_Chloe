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

@interface MainViewController : UIViewController <UIScrollViewDelegate> {
    TodayViewController *todayView;
    ContactsViewController *contactsView;
    ContactProfileConversationViewController *contactProfileConversationView;
    MeetingsViewController *meetingView;
    TodosViewController *toDoView;
    ConversationsViewController *conversationsView;
    ProfileViewController *profileView;
   
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