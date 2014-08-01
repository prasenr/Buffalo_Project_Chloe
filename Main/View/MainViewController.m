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
#import "RelationshipHistoryModel.h"

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
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEditToDo:) name:@"editToDo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEditMeeting:) name:@"editMeeting" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onContactSelectedFromGrid:) name:@"contactClickedFromGrid" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onContactEditorBack:) name:@"contactEditCanceled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProcessContacts:) name:@"processContacts" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onContactsCreated:) name:@"contactsProcessed" object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"profileId"]) {
        profileView = [[UserProfileViewController alloc] init];
        CGRect profileFrame = profileView.view.frame;
        profileFrame.origin = CGPointMake(0, 0);
        profileFrame.size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
        profileView.view.frame = profileFrame;
        [self.view addSubview:profileView.view];
        [profileView createNewProfile];
        profileGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(profileSwipeLeft:)];
        profileGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:profileGestureLeft];
        
        meetingView = [[MeetingsViewController alloc] init];
        CGRect meetingFrame = meetingView.view.frame;
        meetingFrame.origin = CGPointMake(self.view.frame.size.width, 0);
        meetingView.view.frame = meetingFrame;
        [self.view addSubview:meetingView.view];
        
        toDoView = [[TodosViewController alloc] init];
        CGRect todoFrame = toDoView.view.frame;
        todoFrame.origin = CGPointMake(self.view.frame.size.width, 0);
        toDoView.view.frame = todoFrame;
        [self.view addSubview:toDoView.view];
        
        todayView = [[TodayViewController alloc] init];
        CGRect todayFrame = todayView.view.frame;
        todayFrame.origin.x = self.view.bounds.size.width;
        todayView.view.frame = todayFrame;
        [self.view addSubview:todayView.view];
        
        contactsView = [[ContactsViewController alloc] init];
        CGRect contactFrame = contactsView.view.frame;
        contactFrame.origin.x = self.view.bounds.size.width;
        contactsView.view.frame = contactFrame;
        [self.view addSubview:contactsView.view];
        
    } else {
        NSString *userId = [defaults objectForKey:@"profileId"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTodayShowing:) name:@"todayIsShowing" object:nil];
        todayView = [[TodayViewController alloc] init];
        todayGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(todaySwipeLeft:)];
        todayGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        todayGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(todaySwipeRight:)];
        todayGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:todayGestureRight];
        [self.view addGestureRecognizer:todayGestureLeft];
        [self.view addSubview:todayView.view];
        [self.view addSubview:self.loaderScreen];
        
        [todayView fetchWeather];
        [todayView fetchTodosAndMeetings];
    }
    
}

-(void) hideMainLoaderScreen {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.loaderScreen.alpha = 0;
    [UIView commitAnimations];
}

-(void) onTodayShowing:(NSNotification *)notification {
    
    [self hideMainLoaderScreen];

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
    
    profileView = [[UserProfileViewController alloc] init];
    [profileView addProfile:[self getPlaceholderUserProfile]];
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

-(void) onContactsCreated:(NSNotification *)notification {
    NSMutableArray *contacts = [[notification userInfo] valueForKey:@"contacts"];
    [contactsView addContactsData:contacts];
    [todayView fetchWeather];
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

-(void) onProcessContacts:(NSNotification *)notification {
    NSMutableArray *tempUserProfileIds = [[notification userInfo] valueForKey:@"contactId"];
    [[TodaySummary_Controller sharedManager] processContacts:tempUserProfileIds];
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

-(UserProfileModel *) getPlaceholderUserProfile {
    UserProfileModel*UserModel = [[UserProfileModel alloc] init];
    UserModel.firstName = [NSMutableString stringWithString: @"Christopher"];
    UserModel.lastName = @"Fisher";
    UserModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/adrienne.png";
    UserModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/chris.png";
    UserModel.birthday = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    UserModel.addresses = [[NSMutableArray alloc] init];
    
    AddressModel *aAddress = [[AddressModel alloc] init];
    aAddress.addressLine1 = [NSMutableString stringWithString: @"616 Dartmouth"];
    aAddress.city = [NSMutableString stringWithString: @"Kansas City"];
    aAddress.state = [NSMutableString stringWithString: @"Missouri"];
    aAddress.zipcode = [NSMutableString stringWithString: @"64114"];
    
    AddressHistoryModel *aAddressHistory = [[AddressHistoryModel alloc] init];
    aAddressHistory.account = aAddress;
    
    [UserModel.addresses addObject:aAddressHistory];
    
    
    AddressModel *aAddress1 = [[AddressModel alloc] init];
    aAddress1.addressLine1 = [NSMutableString stringWithString: @"7228 Belleview"];
    aAddress1.city = [NSMutableString stringWithString: @"Kansas City"];
    aAddress1.state = [NSMutableString stringWithString: @"Missouri"];
    aAddress1.zipcode = [NSMutableString stringWithString: @"64113"];
    
    AddressHistoryModel *aAddressHistory1 = [[AddressHistoryModel alloc] init];
    aAddressHistory1.account = aAddress1;
    
    [UserModel.addresses addObject:aAddressHistory1];
    
    
    AddressModel *aAddress3 = [[AddressModel alloc] init];
    aAddress3.addressLine1 = [NSMutableString stringWithString: @"702 S. Longfellow"];
    aAddress3.city = [NSMutableString stringWithString: @"Wichita"];
    aAddress3.state = [NSMutableString stringWithString: @"Kansas"];
    aAddress3.zipcode = [NSMutableString stringWithString: @"67207"];
    
    AddressHistoryModel *aAddressHistory3 = [[AddressHistoryModel alloc] init];
    aAddressHistory3.account = aAddress3;
    
    [UserModel.addresses addObject:aAddressHistory3];
    
    //PHONE NUMBERS
    PhoneNumberModel *aPhoneNumber = [[PhoneNumberModel alloc] init];
    aPhoneNumber.country = [NSMutableString stringWithString:@"01"];
    aPhoneNumber.areaCode = [NSMutableString stringWithString:@"816"];
    aPhoneNumber.prefix = [NSMutableString stringWithString:@"738"];
    aPhoneNumber.phoneNumber = [NSMutableString stringWithString:@"5554"];
    aPhoneNumber.extension = [NSMutableString stringWithString:@""];
    
    PhoneNumberHistoryModel *aPhoneHistory = [[PhoneNumberHistoryModel alloc] init];
    aPhoneHistory.account = aPhoneNumber;
    
    UserModel.phoneNumbers = [[NSMutableArray alloc] init];
    [UserModel.phoneNumbers addObject:aPhoneHistory];
    
    
    //EMAIL ACCOUNTS
    EmailAddressModel *aEmailAddress = [[EmailAddressModel alloc] init];
    aEmailAddress.emailAddress = [NSMutableString stringWithString:@"adrienne.f.hill@gmail.com"];
    aEmailAddress.emailType = [NSMutableString stringWithString:@"personal"];
    
    EmailAddressHistoryModel *aEmailAddressHistory = [[EmailAddressHistoryModel alloc] init];
    aEmailAddressHistory.account = aEmailAddress;
    
    UserModel.emailAddresses= [[NSMutableArray alloc] init];
    [UserModel.emailAddresses addObject:aEmailAddressHistory];
    
    
    //INSTANT MESSENGER ACCOUNTS
    InstantMessengerModel *aInstantMessageAccount = [[InstantMessengerModel alloc] init];
    aInstantMessageAccount.username = [NSMutableString stringWithString:@"adrienne.f.hill@gmail.com"];
    aInstantMessageAccount.serverType = [NSMutableString stringWithString:@"gmail.com"];
    aInstantMessageAccount.type = [NSMutableString stringWithString:@"personal"];
    
    InstantMessengerAccountHistoryModel *aInstantMessengerHistory = [[InstantMessengerAccountHistoryModel alloc] init];
    aInstantMessengerHistory.account = aInstantMessageAccount;
    
    UserModel.instantMessengerAccounts = [[NSMutableArray alloc] init];
    [UserModel.instantMessengerAccounts addObject:aInstantMessengerHistory];
    
    //FACEBOOK ACCOUNTS
    FacebookAccountModel *aFacebookAccount = [[FacebookAccountModel alloc] init];
    aFacebookAccount.username = [NSMutableString stringWithString:@"123456"];
    aFacebookAccount.type = [NSMutableString stringWithString:@"personal"];
    
    FacebookAccountHistoryModel *aFacebookHistory = [[FacebookAccountHistoryModel alloc] init];
    aFacebookHistory.account = aFacebookAccount;
    
    UserModel.facebookAccounts = [[NSMutableArray alloc] init];
    [UserModel.facebookAccounts addObject:aFacebookHistory];
    
    //GOOGLE PLUS ACCOUNTS
    GooglePlusAccountModel *aGooglePlusAccount = [[GooglePlusAccountModel alloc] init];
    aGooglePlusAccount.username = [NSMutableString stringWithString:@"1234567"];
    aGooglePlusAccount.type = [NSMutableString stringWithString:@"personal"];
    
    GooglePlusAccountHistoryModel *aGooglePlusHistory = [[GooglePlusAccountHistoryModel alloc] init];
    aGooglePlusHistory.account = aGooglePlusAccount;
    
    UserModel.googlePlusAccounts = [[NSMutableArray alloc] init];
    [UserModel.googlePlusAccounts addObject:aGooglePlusHistory];
    
    //LINKED IN ACCOUNTS
    LinkedInAccountModel *aLinkedInAccount = [[LinkedInAccountModel alloc] init];
    aLinkedInAccount.username = [NSMutableString stringWithString:@"12345678"];
    aLinkedInAccount.type = [NSMutableString stringWithString:@"persona"];
    
    LinkedInAccountHistoryModel *aLinkedInHistory = [[LinkedInAccountHistoryModel alloc] init];
    aLinkedInHistory.account = aLinkedInAccount;
    
    UserModel.linkedInAccounts = [[NSMutableArray alloc] init];
    [UserModel.linkedInAccounts addObject:aLinkedInHistory];
    
    //TWITTER ACCOUNTS
    TwitterAccountModel *aTwitterAccount = [[TwitterAccountModel alloc] init];
    aTwitterAccount.username = [NSMutableString stringWithString:@"afhill"];
    aTwitterAccount.type = [NSMutableString stringWithString:@"personal"];
    
    TwitterAccountHistoryModel *aTwitterHistory = [[TwitterAccountHistoryModel alloc] init];
    aTwitterHistory.id = [NSMutableString stringWithString:@"1234"];
    aTwitterHistory.account = aTwitterAccount;
    
    UserModel.twitterAccounts = [[NSMutableArray alloc] init];
    [UserModel.twitterAccounts addObject:aTwitterHistory];
    
    return UserModel;
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
