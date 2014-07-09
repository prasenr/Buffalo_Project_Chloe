//
//  MainViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/28/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "MainViewController.h"
#import "TodayViewController.h"
#import "NSObject+TodaySummary_Controller.h"
#import "NSObject+TodaySummary_Controller.h"
#import "ToDoEditorViewController.h"
#import "MeetingEditorViewController.h"
#import <POP/POP.h>
#import "NSObject+TodaySummaryListItems.h"
#import "ContactProfileConversationViewController.h"
#import "NSObject+PersonModel.h"
#import "GooglePlusAccountHistoryModel.h"

@interface MainViewController ()
@property (nonatomic, retain) ToDoEditorViewController *toDoEditor;
@property (nonatomic, retain) MeetingEditorViewController *meetingEditor;
@property (nonatomic, strong) TodaySummary_Controller *todaySummaryDataController;
@property (nonatomic, strong) UIImageView *loaderScreen;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }*/
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.loaderScreen = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.loaderScreen.contentMode = UIViewContentModeScaleAspectFill;
    self.loaderScreen.image = [UIImage imageNamed:@"Default.png"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTodayShowing:) name:@"todayIsShowing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEditToDo:) name:@"editToDo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEditMeeting:) name:@"editMeeting" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onContactSelectedFromGrid:) name:@"contactClickedFromGrid" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onContactEditorBack:) name:@"contactEditCanceled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowEditContactBirthdayView:) name:@"showContactBirthdayEditScreen" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactFacebookAccountsListView:) name:@"showContactFacebookAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactFacebookAccountsListView:) name:@"cancelContactFacebookAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactFacebookEditorView:) name:@"showContactFacebookEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactFacebookEditorView:) name:@"cancelFacebookEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddFacebookAccount:) name:@"addFacebookAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactGooglePlusAccountsListView:) name:@"showContactGooglePlusAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactGooglePlusAccountsListView:) name:@"cancelContactGooglePlusAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactGooglePlusEditorView:) name:@"showContactGooglePlusEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactGooglePlusEditorView:) name:@"cancelGooglePlusEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddGooglePlusAccount:) name:@"addGooglePlusAccount" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactLinkedInAccountsListView:) name:@"showContactLinkedInAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactLinkedInAccountsListView:) name:@"cancelContactLinkedInAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactLinkedInEditorView:) name:@"showContactLinkedInEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactLinkedInEditorView:) name:@"cancelLinkedInEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddLinkedInAccount:) name:@"addLinkedInAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactTwitterAccountsListView:) name:@"showTwitterAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactTwitterAccountsListView:) name:@"cancelTwitterAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactTwitterEditorView:) name:@"showContactTwitterEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContacttwitterEditorView:) name:@"cancelTwitterEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddTwitterAccount:) name:@"addTwitterAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactRelationshipsListView:) name:@"showRelationshipsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactRelationshipsListView:) name:@"cancelContactRelationshipsList" object:nil];

    todayView = [[TodayViewController alloc] init];
    todayGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(todaySwipeLeft:)];
    todayGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    todayGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(todaySwipeRight:)];
    todayGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:todayGestureRight];
    [self.view addGestureRecognizer:todayGestureLeft];
    [self.view addSubview:todayView.view];
    
    [self.view addSubview:self.loaderScreen];
}

-(void) onTodayShowing:(NSNotification *)notification {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.loaderScreen.alpha = 0;
    [UIView commitAnimations];

    contactsView = [[ContactsViewController alloc] init];
    CGRect frame = contactsView.view.frame;
    frame.origin = CGPointMake(self.view.frame.size.width, 0);
    contactsView.view.frame = frame;
    [self.view addSubview:contactsView.view];
    
    /*contactProfileConversationView = [[ContactProfileConversationViewController alloc] init];
    CGRect contactProfileFrame = contactProfileConversationView.view.frame;
    contactProfileFrame.origin = CGPointMake(self.view.frame.size.width, 0);
    contactProfileConversationView.view.frame = contactProfileFrame;
    [self.view addSubview:contactProfileConversationView.view];*/
    
    conversationsView = [[ConversationsViewController alloc] init];
    CGRect conversationFrame = conversationsView.view.frame;
    conversationFrame.origin = CGPointMake(self.view.frame.size.width, 0);
    conversationsView.view.frame = conversationFrame;
    [self.view addSubview:conversationsView.view];
    
    meetingView = [[MeetingsViewController alloc] init];
    CGRect meetingFrame = meetingView.view.frame;
    meetingFrame.origin = CGPointMake(-self.view.frame.size.width, 0);
    meetingView.view.frame = meetingFrame;
    [self.view addSubview:meetingView.view];
    
    toDoView = [[TodosViewController alloc] init];
    CGRect todoFrame = toDoView.view.frame;
    todoFrame.origin = CGPointMake(-self.view.frame.size.width, 0);
    toDoView.view.frame = todoFrame;
    [self.view addSubview:toDoView.view];
    
    profileView = [[ProfileViewController alloc] init];
    CGRect profileFrame = profileView.view.frame;
    profileFrame.origin = CGPointMake(-self.view.frame.size.width, 0);
    profileView.view.frame = profileFrame;
    [self.view addSubview:profileView.view];
}

-(IBAction)todaySwipeLeft:(UIGestureRecognizer *)sender {
    CGRect todayTo = CGRectMake(-todayView.view.frame.size.width, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    CGRect contactTo = CGRectMake(0, 0, contactsView.view.frame.size.width, contactsView.view.frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(contactsShowing:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    todayView.view.frame = todayTo;
    contactsView.view.frame = contactTo;
    [UIView commitAnimations];
}

-(IBAction)todaySwipeRight:(UIGestureRecognizer *)sender {
    CGRect todayTo = CGRectMake(todayView.view.frame.size.width, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    CGRect toDoTo = CGRectMake(0, 0, contactsView.view.frame.size.width, contactsView.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(toDoShowing:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    todayView.view.frame = todayTo;
    toDoView.view.frame = toDoTo;
    [UIView commitAnimations];
}

-(IBAction)contactGridSwipeRight:(UIGestureRecognizer *)sender {
    CGRect todayTo = CGRectMake(0, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    CGRect contactTo = CGRectMake(contactsView.view.frame.size.width, 0, contactsView.view.frame.size.width, contactsView.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(todayShowing:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    todayView.view.frame = todayTo;
    contactsView.view.frame = contactTo;
    [UIView commitAnimations];
}

-(IBAction)contactGridSwipeLeft:(UIGestureRecognizer *)sender {
    CGRect contactTo = CGRectMake(-contactsView.view.frame.size.width, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    CGRect allConversationsTo = CGRectMake(0, 0, contactsView.view.frame.size.width, contactsView.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(allConversationsShowing:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    contactsView.view.frame = contactTo;
    conversationsView.view.frame = allConversationsTo;
    [UIView commitAnimations];
}

-(IBAction)allConversationsSwipeRight:(UIGestureRecognizer *)sender {
    CGRect contactTo = CGRectMake(0, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    CGRect allConversationsTo = CGRectMake(conversationsView.view.frame.size.width, 0, contactsView.view.frame.size.width, contactsView.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(contactsShowing:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    contactsView.view.frame = contactTo;
    conversationsView.view.frame = allConversationsTo;
    [UIView commitAnimations];
}

-(IBAction)toDoSwipeLeft:(UIGestureRecognizer *)sender {
    CGRect todayTo = CGRectMake(0, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    CGRect toDoTo = CGRectMake(-self.view.frame.size.width, 0, contactsView.view.frame.size.width, contactsView.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(todayShowing:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    todayView.view.frame = todayTo;
    toDoView.view.frame = toDoTo;
    [UIView commitAnimations];
}

-(IBAction)toDoSwipeRight:(UIGestureRecognizer *)sender {
    CGRect meetingTo = CGRectMake(0, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    CGRect toDoTo = CGRectMake(self.view.frame.size.width, 0, contactsView.view.frame.size.width, contactsView.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(meetingShowing:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    toDoView.view.frame = toDoTo;
    meetingView.view.frame = meetingTo;
    [UIView commitAnimations];
}

-(IBAction)meetingSwipeLeft:(UIGestureRecognizer *)sender {
    CGRect toDoTo = CGRectMake(0, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    CGRect meetingTo = CGRectMake(-self.view.frame.size.width, 0, contactsView.view.frame.size.width, contactsView.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(toDoShowing:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    meetingView.view.frame = meetingTo;
    toDoView.view.frame = toDoTo;
    [UIView commitAnimations];
}

-(IBAction)meetingSwipeRight:(UIGestureRecognizer *)sender {
    CGRect profileTo = CGRectMake(0, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    CGRect meetingTo = CGRectMake(self.view.frame.size.width, 0, contactsView.view.frame.size.width, contactsView.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(profileShowing:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    meetingView.view.frame = meetingTo;
    profileView.view.frame = profileTo;
    [UIView commitAnimations];
}

-(IBAction)profileSwipeLeft:(UIGestureRecognizer *)sender {
    CGRect meetingTo = CGRectMake(0, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    CGRect profileTo = CGRectMake(-self.view.frame.size.width, 0, contactsView.view.frame.size.width, contactsView.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(meetingShowing:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    meetingView.view.frame = meetingTo;
    profileView.view.frame = profileTo;
    [UIView commitAnimations];
}

-(void)todayShowing:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [self.view removeGestureRecognizer:contactGestureLeft];
    [self.view removeGestureRecognizer:contactGestureRight];
    [self.view removeGestureRecognizer:toDoGestureLeft];
    [self.view removeGestureRecognizer:toDoGestureRight];
    
    todayGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(todaySwipeLeft:)];
    todayGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:todayGestureLeft];
    
    todayGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(todaySwipeRight:)];
    todayGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:todayGestureRight];
}

-(void)contactsShowing:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    contactGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(contactGridSwipeRight:)];
    contactGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:contactGestureRight];
    
    contactGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(contactGridSwipeLeft:)];
    contactGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:contactGestureLeft];
    
    [self.view removeGestureRecognizer:todayGestureLeft];
    [self.view removeGestureRecognizer:todayGestureRight];
    [self.view removeGestureRecognizer:allConversationsGestureRight];
}

-(void)allConversationsShowing:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    allConversationsGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(allConversationsSwipeRight:)];
    allConversationsGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:allConversationsGestureRight];
    
    [self.view removeGestureRecognizer:contactGestureRight];
    [self.view removeGestureRecognizer:contactGestureLeft];
}

-(void)toDoShowing:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [self.view removeGestureRecognizer:todayGestureRight];
    [self.view removeGestureRecognizer:todayGestureLeft];
    [self.view removeGestureRecognizer:meetingGestureLeft];
    [self.view removeGestureRecognizer:meetingGestureRight];
    
    toDoGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toDoSwipeLeft:)];
    toDoGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:toDoGestureLeft];
    
    toDoGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toDoSwipeRight:)];
    toDoGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:toDoGestureRight];
}

-(void)meetingShowing:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [self.view removeGestureRecognizer:toDoGestureRight];
    [self.view removeGestureRecognizer:toDoGestureLeft];
    [self.view removeGestureRecognizer:profileGestureLeft];
    
    meetingGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(meetingSwipeLeft:)];
    meetingGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
   [self.view addGestureRecognizer:meetingGestureLeft];
    
    meetingGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(meetingSwipeRight:)];
    meetingGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:meetingGestureRight];
}

-(void)profileShowing:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [self.view removeGestureRecognizer:meetingGestureRight];
    [self.view removeGestureRecognizer:meetingGestureLeft];
    
    profileGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(profileSwipeLeft:)];
    profileGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:profileGestureLeft];

}


-(IBAction)onGridShowComplete:(id)sender {
    
    
}

-(void) onContactSelectedFromSearch:(NSNotification *)notification {
    //[contactsView resetKeyboard];
    
    //PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    
    //contactEditor = [[ContactEditorViewController alloc] initWithPerson:person initWithNibName:@"ContactEditorViewController" bundle:nil];
    //CGRect editorFrame = contactEditor.view.frame;
    //editorFrame.origin = CGPointMake(self.view.frame.size.width, 0);
    //contactEditor.view.frame = editorFrame;
    //[self.view addSubview:contactEditor.view];
    
    //CGRect contactTo = CGRectMake(-self.view.frame.size.width, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    //CGRect editorTo = CGRectMake(0, 0, contactGrid.view.frame.size.width, contactGrid.view.frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onFinishedShowingContactEditorFromSearch:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //contactGrid.view.frame = contactTo;
    //contactEditor.view.frame = editorTo;
    [UIView commitAnimations];
}

-(void)onFinishedShowingContactEditorFromSearch:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    //[contactGrid reset];
}

-(void) onContactSelectedFromGrid:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactProfileConversationView = [[ContactProfileConversationViewController alloc] initWithPerson:person initWithNibName:@"ContactProfileConversationViewController" bundle:nil];
    CGRect editorFrame = contactProfileConversationView.view.frame;
    editorFrame.origin = CGPointMake(self.view.frame.size.width, 0);
    contactProfileConversationView.view.frame = editorFrame;
    [self.view addSubview:contactProfileConversationView.view];
    
    CGRect contactTo = CGRectMake(-self.view.frame.size.width, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    CGRect editorTo = CGRectMake(0, 0, contactsView.view.frame.size.width, contactsView.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    contactsView.view.frame = contactTo;
    contactProfileConversationView.view.frame = editorTo;
    [UIView commitAnimations];
}

-(void) onContactEditorBack:(NSNotification *)notification {
    CGRect contactTo = CGRectMake(0, 0, todayView.view.frame.size.width, todayView.view.frame.size.height);
    CGRect editorTo = CGRectMake(self.view.frame.size.width, 0, contactsView.view.frame.size.width, contactsView.view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onContactEditorHidden:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    contactsView.view.frame = contactTo;
    contactProfileConversationView.view.frame = editorTo;
    [UIView commitAnimations];
}

-(void)onContactEditorHidden:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [contactProfileConversationView.view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
}

-(void) onEditMeeting:(NSNotification *)notification {
    TodaySummaryListItems *meeting = [[notification userInfo] valueForKey:@"meeting"];
    
    if(self.meetingEditor) {
        [self.meetingEditor.view removeFromSuperview];
    }
    
    self.meetingEditor = [[MeetingEditorViewController alloc] initWtihMeeting:meeting initWithNibName:@"MeetingEditorViewController" bundle:nil];
    [self.view addSubview:self.meetingEditor.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMeetingComplete:) name:@"meetingCompleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeleteMeeting:) name:@"deleteMeeting" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelMeeting:) name:@"cancelMeeting" object:nil];
}

-(void) onMeetingComplete:(NSNotification *)notification {
    [self removeMeetingListeners];
    
    MeetingModel *meetingItem = [[notification userInfo] valueForKey:@"meeting"];
    [UIView beginAnimations:nil context:(__bridge void *)(meetingItem)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onCompletedMeetingEditorHidden:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.meetingEditor.view.alpha = 0;
    [UIView commitAnimations];
}

-(void)onCompletedMeetingEditorHidden:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [self.meetingEditor.view removeFromSuperview];
    MeetingModel *meeting = (__bridge MeetingModel *)context;
    [[TodaySummary_Controller sharedManager] completeMeeting:meeting];
    
    [todayView updateList];
}

-(void) onDeleteMeeting:(NSNotification *)notification {
    [self removeMeetingListeners];
    
    MeetingModel *meetingItem = [[notification userInfo] valueForKey:@"meeting"];
    [UIView beginAnimations:nil context:(__bridge void *)(meetingItem)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onDeleteMeetingEditorHidden:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.meetingEditor.view.alpha = 0;
    [UIView commitAnimations];
}

-(void)onDeleteMeetingEditorHidden:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [self.meetingEditor.view removeFromSuperview];
    MeetingModel *meeting = (__bridge MeetingModel *)context;
    [[TodaySummary_Controller sharedManager] deleteMeeting:meeting];
    
    [todayView updateList];
}

-(void) onCancelMeeting:(NSNotification *)notfication {
    [self removeMeetingListeners];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onCancelMeetingEditorHidden:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.meetingEditor.view.alpha = 0;
    [UIView commitAnimations];
}

-(void)onCancelMeetingEditorHidden:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [self.meetingEditor.view removeFromSuperview];
}

-(void) removeMeetingListeners {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"meetingCompleted" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteMeeting" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelMeeting" object:nil];
}

-(void) onEditToDo:(NSNotification *)notification {
    ToDoModel *todo = [[notification userInfo] valueForKey:@"todo"];
    
    if(self.toDoEditor) {
        [self.toDoEditor.view removeFromSuperview];
    }
    
    self.toDoEditor = [[ToDoEditorViewController alloc] initWtihToDo:todo initWithNibName:@"ToDoEditorViewController" bundle:nil];
    [self.view addSubview:self.toDoEditor.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onToDoCompleted:) name:@"toDoCompleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeleteToDo:) name:@"deleteToDo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelToDo:) name:@"cancelToDo" object:nil];
}

-(void) onToDoCompleted:(NSNotification *)notification {
    [self removeToDoListeners];
    
    ToDoModel *todoItem = [[notification userInfo] valueForKey:@"todo"];
    [UIView beginAnimations:nil context:(__bridge void *)(todoItem)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onCompletedToDoEditorHidden:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.toDoEditor.view.alpha = 0;
    [UIView commitAnimations];
}

-(void)onCompletedToDoEditorHidden:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [self.toDoEditor.view removeFromSuperview];
    ToDoModel *todo = (__bridge ToDoModel *)context;
    todo.isComplete = YES;
    [[TodaySummary_Controller sharedManager] completeToDo:todo];
    
    [todayView updateList];
    //[toDoView updateToDos];
}

-(void) onDeleteToDo:(NSNotification *)notification {
    [self removeToDoListeners];
    
    ToDoModel *todoItem = [[notification userInfo] valueForKey:@"todo"];
    [UIView beginAnimations:nil context:(__bridge void *)(todoItem)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onDeleteToDoEditorHidden:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.toDoEditor.view.alpha = 0;
    [UIView commitAnimations];
}

-(void)onDeleteToDoEditorHidden:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [self.toDoEditor.view removeFromSuperview];
    ToDoModel *todo = (__bridge ToDoModel *)context;
    [[TodaySummary_Controller sharedManager] deleteToDo:todo];
    
    [todayView updateList];
    //[toDoView updateToDos];
}

-(void) onCancelToDo:(NSNotification *)notification {
    [self removeToDoListeners];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onCancelToDoEditorHidden:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.toDoEditor.view.alpha = 0;
    [UIView commitAnimations];
}

-(void)onCancelToDoEditorHidden:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [self.toDoEditor.view removeFromSuperview];
}

-(void) removeToDoListeners {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"toDoCompleted" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteToDo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelToDo" object:nil];
}

-(void)onToDoEditorHidden:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [self.toDoEditor.view removeFromSuperview];
}

-(void)onShowEditContactBirthdayView:(NSNotification *)notification {
    
}







-(void) onShowContactLinkedInAccountsListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactLinkedInListView = [[ContactLinkedInAccountListViewController alloc] init];
    [contactLinkedInListView person:person];
    
    [self.view addSubview:contactLinkedInListView.view];
}

-(void) onCancelContactLinkedInAccountsListView:(NSNotification *)notification {
    [contactLinkedInListView.view removeFromSuperview];
}

-(void) onShowContactLinkedInEditorView:(NSNotification *)notification {
    contactLinkedInEditorView = [[LinkedInEditorViewController alloc] init];
    
    [self.view addSubview:contactLinkedInEditorView.view];
}

-(void) onCancelContactLinkedInEditorView:(NSNotification *)notification {
    [contactLinkedInEditorView.view removeFromSuperview];
}

-(void) onAddLinkedInAccount:(NSNotification *)notification {
    LinkedInAccountHistoryModel *newLinkedInAccount = [[notification userInfo] valueForKey:@"linkedInAccount"];
    [contactLinkedInListView addLinkedInAccount:newLinkedInAccount];
    
    [contactLinkedInEditorView.view removeFromSuperview];
}

-(void) onShowContactGooglePlusAccountsListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactGooglePlusListView = [[ContactGooglePlusAccountListViewController alloc] init];
    [contactGooglePlusListView person:person];
    
    [self.view addSubview:contactGooglePlusListView.view];
}

-(void) onCancelContactGooglePlusAccountsListView:(NSNotification *)notification {
    [contactGooglePlusListView.view removeFromSuperview];
}

-(void) onShowContactGooglePlusEditorView:(NSNotification *)notification {
    contactGooglePlusEditorView = [[GooglePlusEditorViewController alloc] init];
    
    [self.view addSubview:contactGooglePlusEditorView.view];
}

-(void) onCancelContactGooglePlusEditorView:(NSNotification *)notification {
    [contactGooglePlusEditorView.view removeFromSuperview];
}

-(void) onAddGooglePlusAccount:(NSNotification *)notification {
    
    GooglePlusAccountHistoryModel *newGooglePlusAccount = [[notification userInfo] valueForKey:@"googlePlusAccount"];
    [contactGooglePlusListView addGooglePlusAccount:newGooglePlusAccount];
    
    [contactGooglePlusEditorView.view removeFromSuperview];
}

-(void) onShowContactFacebookAccountsListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactFacebookListView = [[ContactFacebookAccountListViewController alloc] init];
    [contactFacebookListView person:person];
    
    [self.view addSubview:contactFacebookListView.view];
}

-(void) onCancelContactFacebookAccountsListView:(NSNotification *)notification {
    [contactFacebookListView.view removeFromSuperview];
}

-(void) onShowContactFacebookEditorView:(NSNotification *)notification {
    contactFacebookEditorView = [[FacebookEditorViewController alloc] init];
    
    [self.view addSubview:contactFacebookEditorView.view];
}

-(void) onCancelContactFacebookEditorView:(NSNotification *)notification {
    [contactFacebookEditorView.view removeFromSuperview];
}

-(void) onAddFacebookAccount:(NSNotification *)notification {
    
    FacebookAccountHistoryModel *newFacebookAccount = [[notification userInfo] valueForKey:@"facebookAccount"];
    [contactFacebookListView addFacebookAccount:newFacebookAccount];
    
    [contactFacebookEditorView.view removeFromSuperview];
}

-(void)onShowContactTwitterAccountsListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactTwitterListView = [[ContactTwitterAccountListViewController alloc] init];
    [contactTwitterListView person:person];
    
    [self.view addSubview:contactTwitterListView.view];
}

-(void) onCancelContactTwitterAccountsListView:(NSNotification *)notification {
    [contactTwitterListView.view removeFromSuperview];
}

-(void) onShowContactTwitterEditorView:(NSNotification *)notification {
    contactTwitterEditorView = [[TwitterEditorViewController alloc] init];
    
    [self.view addSubview:contactTwitterEditorView.view];
}

-(void) onCancelContacttwitterEditorView:(NSNotification *)notification {
    [contactTwitterEditorView.view removeFromSuperview];
}

-(void) onAddTwitterAccount:(NSNotification *)notification {
    TwitterAccountHistoryModel *newTwitterAccount = [[notification userInfo] valueForKey:@"twitterAccount"];
    [contactTwitterListView addTwitterAccount:newTwitterAccount];
    
    [contactTwitterEditorView.view removeFromSuperview];
}

-(void)onShowContactRelationshipsListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactRelationshipListView = [[ContactRelationshipsListViewController alloc] init];
    [contactRelationshipListView person:person];
    
    [self.view addSubview:contactRelationshipListView.view];
}

-(void) onCancelContactRelationshipsListView:(NSNotification *)notification {
    [contactRelationshipListView.view removeFromSuperview];
}

-(void) getToDoSource {
    
    /* ToDoModel *toDo1 = [[ToDoModel alloc] init];
     toDo1.toDoSummary = @"To Do Number 1";
     
     ToDoModel *toDo2 = [[ToDoModel alloc] init];
     toDo1.toDoSummary = @"To Do Number 2";
     
     ToDoModel *toDo3 = [[ToDoModel alloc] init];
     toDo1.toDoSummary = @"To Do Number 3";
     
     ToDoModel *toDo4 = [[ToDoModel alloc] init];
     toDo1.toDoSummary = @"To Do Number 4";
     
     self.toDos = [[NSMutableArray alloc] initWithObjects:toDo1, toDo2, toDo3, toDo4, nil];*/
}
-(UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"cell"];
    if(nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(void) weatherButtonClick {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

@end
