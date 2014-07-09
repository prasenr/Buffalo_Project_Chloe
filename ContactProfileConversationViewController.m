//
//  ContactProfileConversationViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 5/14/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ContactProfileConversationViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "AddressModel.h"
#import "AddressHistoryModel.h"
#import "PhoneNumberModel.h"
#import "PhoneNumberHistoryModel.h"
#import "ContactAddressSearchViewController.h"

@interface ContactProfileConversationViewController ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UIView *tableParentContainer;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UILabel *profileSectionLabel;
@property (nonatomic, strong) UIImageView *profileSectionIcon;
@property (nonatomic, strong) PersonModel *personModel;
@property (nonatomic, strong) NSMutableArray *nameLabelArray;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *nameContent;
@property (nonatomic, strong) UIView *addressContent;
@property (nonatomic, strong) UIView *buttonContent;
@property (nonatomic, strong) UIImageView *loaderImage;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) ContactAddressSearchViewController *addressSearchResults;
@end

static NSDateFormatter *dateFormatter = nil;
@implementation ContactProfileConversationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithPerson:(PersonModel *)person initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.personModel = person;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //UIImage *background = [UIImage imageNamed:@"fall.jpg"];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.alpha = 0;
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
   // [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    self.tableParentContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableParentContainer];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableParentContainer addSubview:self.tableView];
    
    CGRect headerFrame = self.view.bounds;
    self.header = [[UIView alloc] initWithFrame:headerFrame];
    self.header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.header;
    
    self.nameContent = [[UIView alloc] init];
    [self.header addSubview:self.nameContent];
    
    int yPos = 0;
    [self createNameLabels];
    yPos = self.nameContent.frame.size.height;
    
    if([self.personModel.addresses count]>0) {
        self.addressContent = [[UIView alloc] init];
        [self createAddressLabel];
        NSLog(@"ypos intial old %d", yPos);
        yPos = yPos + self.addressContent.frame.size.height;
        NSLog(@"ypos intial new %d", yPos);
        [self.header addSubview:self.addressContent];
    }
        self.buttonContent = [[UIView alloc] init];
        [self.header addSubview:self.buttonContent];
        [self createButtons];
        yPos = yPos + 60;
    
    
    
    yPos = self.view.frame.size.height -  yPos;
    
    CGRect newFrame = self.nameContent.frame;
    newFrame.origin.y = yPos;
    self.nameContent.frame = newFrame;

    if([self.personModel.addresses count]>0) {
        yPos = yPos + self.nameContent.frame.size.height;
        yPos = yPos - 10;
        
        CGRect addressFrame = self.addressContent.frame;
        addressFrame.origin.y = yPos;
        self.addressContent.frame = addressFrame;
        NSLog(@"ypos old %d", yPos);
        yPos = yPos + self.addressContent.frame.size.height + 10;
        NSLog(@"ypos new %d", yPos);
        CGRect buttonFrame = self.buttonContent.frame;
        buttonFrame.origin.y = self.view.bounds.size.height - 40;
        self.buttonContent.frame = buttonFrame;
    } else {
        yPos = yPos + self.nameContent.frame.size.height;
        newFrame = self.buttonContent.frame;
        newFrame.origin.y = yPos;
        self.buttonContent.frame = newFrame;
    }
    
    
     
    

    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 5, 50, 50)];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelCloseButton.png"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(onCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    NSMutableString *filePath = [[NSMutableString alloc] init];
    [filePath appendString:@"big"];
    [filePath appendString:[self.personModel.firstName substringToIndex:1].lowercaseString];
    [filePath appendString:@".png"];
    
    self.loaderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filePath]];
    self.loaderImage.frame = self.view.bounds;
    self.loaderImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.loaderImage];
    
    
    __block NSData *imageData;
    dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.buffaloproject.profileImageBGqueue", NULL);
    
    dispatch_async(backgroundQueue, ^(void) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.personModel.personBigImage]];
        UIImage *imageLoad;
        imageLoad = [[UIImage alloc] initWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.backgroundImageView setImage:imageLoad];
            [self.blurredImageView setImageToBlur:imageLoad blurRadius:10 completionBlock:nil];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:.5];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            self.backgroundImageView.alpha = 1;
            self.loaderImage.alpha = 0;
            [UIView commitAnimations];
        });
    });
    
    [self addAddressListeners];
}

-(void) addAddressListeners {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactAddressesListView:) name:@"showContactAddressesList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactAddressListView:) name:@"cancelContactAddressesList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactAddressEditorView:) name:@"showContactAddressEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactAddressEditorView:) name:@"cancelAddressEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowAddressSearchResults:) name:@"searchForContactAddress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddContactAddress:) name:@"addContactAddress" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactPhoneNumbersListView:) name:@"showContactPhoneNumbersList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactPhoneNumbersListView:) name:@"cancelContactPhoneNumbersList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactPhoneNumberEditorView:) name:@"showContactPhoneNumberEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactPhoneNumberEditorView:) name:@"cancelPhoneNumberEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddPhoneNumber:) name:@"addPhoneNumber" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactEmailAddressesListView:) name:@"showContactEmailAddressesList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactEmailAddressesListView:) name:@"cancelContactEmailAddressesList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactEmailAddressEditorView:) name:@"showContactEmailAddressEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactEmailAddressEditorView:) name:@"cancelEmailAddressEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddEmailAddressAccount:) name:@"addEmailAddress" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactInstantMessengerAccountsListView:) name:@"showContactInstantMessengerAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactInstantMessengerAccountsListView:) name:@"cancelContactInstantMessengerAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactInstantMessengerEditorView:) name:@"showContactInstantMessengerEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactInstantMessengerEditorView:) name:@"cancelInstantMessengerEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddInstantMessengerAccount:) name:@"addInstantMessengerAccount" object:nil];
    
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
}


-(IBAction)onCancelClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactEditCanceled" object:nil];
}


-(void) backgroundImage1Loaded:(UIImage *)image {
    if(image) {
        NSLog(@"image loaded");
        [self.backgroundImageView setImage:image];
        [self.blurredImageView setImageToBlur:image blurRadius:10 completionBlock:nil];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    self.blurredImageView.alpha = percent;
}

//ADDRESSES
-(void) onShowContactAddressesListView:(NSNotification *)notification {
    
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactAddressListView = [[ContactAddressListViewController alloc] init];
    CGRect addressListFrame = contactAddressListView.view.frame;
    addressListFrame.origin.x = self.view.bounds.size.width;
    contactAddressListView.view.frame = addressListFrame;
    [contactAddressListView person:person];
    [self.view addSubview:contactAddressListView.view];
    
    CGRect profileListTo = CGRectMake(-self.view.bounds.size.width, 0, addressListFrame.size.width, addressListFrame.size.height);
    CGRect addressListTo = CGRectMake(0, 0, addressListFrame.size.width, addressListFrame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.cancelButton.alpha = 0;
    self.tableParentContainer.frame = profileListTo;
    contactAddressListView.view.frame = addressListTo;
    
    [UIView commitAnimations];
}

-(void) onCancelContactAddressListView:(NSNotification *)notification {
    CGRect profileListTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect addressListTo = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeAddressListView:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.tableParentContainer.frame = profileListTo;
    contactAddressListView.view.frame = addressListTo;
    self.cancelButton.alpha = 1;
    [UIView commitAnimations];
}

-(void)removeAddressListView:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [contactAddressListView.view removeFromSuperview];
}

-(void) onShowContactAddressEditorView:(NSNotification *)notification {
    contactAddressEditorView = [[AddressEditorViewController alloc] init];
    CGRect editorFrame = contactAddressEditorView.view.frame;
    editorFrame.origin.x = self.view.bounds.size.width;
    contactAddressEditorView.view.frame = editorFrame;
    [self.view addSubview:contactAddressEditorView.view];
    
    CGRect addressEditorTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect addressListTo = CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    contactAddressEditorView.view.frame = addressEditorTo;
    contactAddressListView.view.frame = addressListTo;
    [UIView commitAnimations];
}

-(void) onCancelContactAddressEditorView:(NSNotification *)notification {
    CGRect addressEditorTo = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect addressListTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeAddressEditorView:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    contactAddressEditorView.view.frame = addressEditorTo;
    contactAddressListView.view.frame = addressListTo;
    [UIView commitAnimations];
}

-(void)removeAddressEditorView:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [contactAddressEditorView.view removeFromSuperview];
}


-(void)onShowAddressSearchResults:(NSNotification *)notification {
    NSString *searchText = [[notification userInfo] valueForKey:@"searchText"];
    self.addressSearchResults = [[ContactAddressSearchViewController alloc] initWithSearch:searchText initWithNibName:@"ContactAddressSearchViewController" bundle:nil];
    
    CGRect initalFrame = self.addressSearchResults.view.frame;
    initalFrame.origin.x = self.view.bounds.size.width;
    self.addressSearchResults.view.frame = initalFrame;
    [self.view addSubview:self.addressSearchResults.view];
    
    CGRect editorTo = CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect resultsTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    contactAddressEditorView.view.frame = editorTo;
    self.addressSearchResults.view.frame = resultsTo;
    [UIView commitAnimations];
}

-(void)onAddContactAddress:(NSNotification *)notification {
    
    AddressHistoryModel *addressHistory = [[notification userInfo] valueForKey:@"addressHistory"];
    
    CGRect resultsTo = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect listTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
;
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         contactAddressListView.view.frame = listTo;
                         self.addressSearchResults.view.frame = resultsTo;
                     }
                     completion:^(BOOL finished){
                         [contactAddressListView addAddress:addressHistory];
                         [contactAddressListView.view removeFromSuperview];
                         [contactAddressEditorView.view removeFromSuperview];
                     }];
}

-(void) onShowContactPhoneNumbersListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactPhoneNumberListView = [[ContactPhoneNumberListViewViewController alloc] init];
    [contactPhoneNumberListView person:person];
    
    [self.view addSubview:contactPhoneNumberListView.view];
}

-(void) onCancelContactPhoneNumbersListView:(NSNotification *)notification {
    [contactPhoneNumberListView.view removeFromSuperview];
}

-(void) onShowContactPhoneNumberEditorView:(NSNotification *)notification {
    contactPhoneNumberEditorView = [[PhoneNumberEditorViewController alloc] init];
    
    [self.view addSubview:contactPhoneNumberEditorView.view];
}

-(void) onCancelContactPhoneNumberEditorView:(NSNotification *)notification {
    [contactPhoneNumberEditorView.view removeFromSuperview];
}

-(void) onAddPhoneNumber:(NSNotification *)notification {
    
    PhoneNumberHistoryModel *newPhoneNumber = [[notification userInfo] valueForKey:@"phoneNumber"];
    
    CGRect resultsTo = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect listTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
    ;
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         contactAddressListView.view.frame = listTo;
                         self.addressSearchResults.view.frame = resultsTo;
                     }
                     completion:^(BOOL finished){
                         
                         //[contactAddressListView addAddress:addressHistory];
                         //[contactAddressListView.view removeFromSuperview];
                         //[contactAddressEditorView.view removeFromSuperview];
                     }];
    
    [contactPhoneNumberListView addPhoneNumber:newPhoneNumber];
    
    [contactPhoneNumberEditorView.view removeFromSuperview];
}

-(void)onShowContactEmailAddressesListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactEmailListView = [[ContactEmailAddressListViewController alloc] init];
    [contactEmailListView person:person];
    
    [self.view addSubview:contactEmailListView.view];
}

-(void) onCancelContactEmailAddressesListView:(NSNotification *)notification {
    [contactEmailListView.view removeFromSuperview];
}

-(void) onShowContactEmailAddressEditorView:(NSNotification *)notification {
    contactEmailAddressEditor = [[EmailAddressEditorViewController alloc] init];
    
    [self.view addSubview:contactEmailAddressEditor.view];
}

-(void) onCancelContactEmailAddressEditorView:(NSNotification *)notification {
    [contactEmailAddressEditor.view removeFromSuperview];
}

-(void) onAddEmailAddressAccount:(NSNotification *)notification {
    
    EmailAddressHistoryModel *newEmailAddress = [[notification userInfo] valueForKey:@"emailAddress"];
    [contactEmailListView addEmailAddress:newEmailAddress];
    
    [contactEmailAddressEditor.view removeFromSuperview];
}

-(void)onShowContactInstantMessengerAccountsListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactInstantMessengerListView = [[ContactInstantMessengerListViewController alloc] init];
    [contactInstantMessengerListView person:person];
    
    [self.view addSubview:contactInstantMessengerListView.view];
}

-(void) onCancelContactInstantMessengerAccountsListView:(NSNotification *)notification {
    [contactInstantMessengerListView.view removeFromSuperview];
}

-(void) onShowContactInstantMessengerEditorView:(NSNotification *)notification {
    contactInstantMessengerEditorView = [[InstantMessengerEditorViewController alloc] init];
    
    [self.view addSubview:contactInstantMessengerEditorView.view];
}

-(void) onCancelContactInstantMessengerEditorView:(NSNotification *)notification {
    [contactInstantMessengerEditorView.view removeFromSuperview];
}

-(void) onAddInstantMessengerAccount:(NSNotification *)notification {
    
    InstantMessengerAccountHistoryModel *newInstantMessengerAccount = [[notification userInfo] valueForKey:@"instantMessengerAccount"];
    [contactInstantMessengerListView addInstantMessengerAccount:newInstantMessengerAccount];
    
    [contactInstantMessengerEditorView.view removeFromSuperview];
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
    contactRelationshipsListView = [[ContactRelationshipsListViewController alloc] init];
    [contactRelationshipListView person:person];
    
    [self.view addSubview:contactRelationshipListView.view];
}

-(void) onCancelContactRelationshipsListView:(NSNotification *)notification {
    [contactRelationshipListView.view removeFromSuperview];
}



//TOOD

//GENERAL

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        self.profileSectionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [cell.contentView addSubview:self.profileSectionIcon];
        
        self.profileSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, self.view.bounds.size.width - 20, 30)];
        self.profileSectionLabel.textColor = [UIColor whiteColor];
        self.profileSectionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.profileSectionLabel.adjustsFontSizeToFitWidth = NO;
        self.profileSectionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:self.profileSectionLabel];
    }
    
    switch (indexPath.row) {
        case 0:
            
            if(dateFormatter == nil){
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMMM d, yyyy"];
            }
            self.profileSectionLabel.text = [dateFormatter stringFromDate: self.personModel.birthday];
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"birthdayIcon.png"]];
            break;
        case 1:
            self.profileSectionLabel.text = @"Addresses";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"addressIcon.png"]];
            break;
        case 2:
            self.profileSectionLabel.text = @"Phone Numbers";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"phoneListIcon.png"]];
            break;
        case 3:
            self.profileSectionLabel.text = @"Email Addresses";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"emailIcon.png"]];
            break;
        case 4:
            self.profileSectionLabel.text = @"Instant Messenger Accounts";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"imIcon.png"]];
            break;
        case 5:
            self.profileSectionLabel.text = @"Facebook Accounts";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"facebookIcon.png"]];
            break;
        case 6:
            self.profileSectionLabel.text = @"Google+ Accounts";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"googlePlusIcon.png"]];
            break;
        case 7:
            self.profileSectionLabel.text = @"Linked In Accounts";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"linkedInIcon.png"]];
            break;
        case 8:
            self.profileSectionLabel.text = @"Twitter Accounts";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"twitterIcon.png"]];
            break;
        case 9:
            self.profileSectionLabel.text = @"Relationships";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"relationshipsIcon.png"]];
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)createNameLabels {
    
    NSArray *names = [[NSArray alloc] initWithObjects:self.personModel.firstName, self.personModel.lastName, nil];
    self.nameLabelArray = [[NSMutableArray alloc] init];
    int nameHeight = 0;
    for(NSString *aName in names) {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        NSMutableAttributedString *nameAttributed =  [[NSMutableAttributedString alloc] initWithString:aName attributes:
                                                      @{
                                                        NSFontAttributeName : [UIFont fontWithName:@"Didot" size:57],
                                                        NSKernAttributeName : @(-5.3f),
                                                        NSForegroundColorAttributeName :[UIColor whiteColor]
                                                        }];
        nameLabel.attributedText = nameAttributed;
        
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [aName boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nameLabel.font} context:nil];
        CGRect newFrame = nameLabel.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        nameLabel.frame = newFrame;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameHeight = nameHeight + nameLabel.frame.size.height;
        nameHeight = nameHeight - 27;
        
        [self.nameContent addSubview:nameLabel];
        [self.nameLabelArray addObject:nameLabel];
    }
    
   // UILabel *aLabel = [self.nameLabelArray objectAtIndex:0];
    
    CGRect nameFrame = self.nameContent.frame;
    nameHeight = nameHeight + 27;
    nameFrame.size.height = nameHeight;
    nameFrame.size.width = self.view.frame.size.width;
    self.nameContent.frame = nameFrame;
    
    int yPos = 0;
    for(UILabel *aNameLabel in self.nameLabelArray) {
        CGRect newFrame = aNameLabel.frame;
        newFrame.origin.y = yPos;
        aNameLabel.frame = newFrame;
        yPos = yPos + (newFrame.size.height - 27);
    }
}

-(void) createAddressLabel {
    
    int totalHeight = 0;
    AddressHistoryModel *aAddressHistory = [self.personModel.addresses objectAtIndex:0];
    AddressModel *aAddress = aAddressHistory.account;
    
    if([aAddress.addressLine1 length]>0) {
        UILabel *addressLine1Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        addressLine1Label.text = aAddress.addressLine1;
        addressLine1Label.font = [UIFont fontWithName:@"Colaborate" size:12];
        addressLine1Label.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [aAddress.addressLine1 boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:addressLine1Label.font} context:nil];
        CGRect newFrame = addressLine1Label.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        addressLine1Label.frame = newFrame;
        totalHeight = totalHeight + addressLine1Label.frame.size.height;
        [self.addressContent addSubview:addressLine1Label];
    }
    
    if([aAddress.addressLine2 length]>0) {
        UILabel *addressLine2Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        addressLine2Label.text = aAddress.addressLine2;
        addressLine2Label.font = [UIFont fontWithName:@"Colaborate" size:12];
        addressLine2Label.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [aAddress.addressLine1 boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:addressLine2Label.font} context:nil];
        CGRect newFrame = addressLine2Label.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        newFrame.origin.y = totalHeight;
        addressLine2Label.frame = newFrame;
        totalHeight = totalHeight + addressLine2Label.frame.size.height;
        [self.addressContent addSubview:addressLine2Label];
    }
    
    int currentWidth = 0;
    
    if([aAddress.city length]>0) {
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        cityLabel.text = aAddress.city;
        cityLabel.font = [UIFont fontWithName:@"Colaborate" size:12];
        cityLabel.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [aAddress.city boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cityLabel.font} context:nil];
        CGRect newFrame = cityLabel.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        newFrame.origin.y = totalHeight;
        cityLabel.frame = newFrame;
        currentWidth = currentWidth + cityLabel.frame.size.width + 5;
        [self.addressContent addSubview:cityLabel];
    }
    
    if([aAddress.state length]>0) {
        NSMutableString *stateString = [[NSMutableString alloc] init];
        if([aAddress.city length]>0) {
            [stateString appendString:@", "];
        }
        
        [stateString appendString:aAddress.state];
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        stateLabel.text = aAddress.state;
        stateLabel.font = [UIFont fontWithName:@"Colaborate" size:12];
        stateLabel.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [stateString boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:stateLabel.font} context:nil];
        CGRect newFrame = stateLabel.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        newFrame.origin.x = currentWidth;
        newFrame.origin.y = totalHeight;
        stateLabel.frame = newFrame;
        currentWidth = currentWidth + stateLabel.frame.size.width + 5;
        [self.addressContent addSubview:stateLabel];
    }
    
    if([aAddress.zipcode length]>0) {
        UILabel *zipCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        zipCodeLabel.text = aAddress.state;
        zipCodeLabel.font = [UIFont fontWithName:@"Colaborate" size:12];
        zipCodeLabel.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [aAddress.zipcode boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:zipCodeLabel.font} context:nil];
        CGRect newFrame = zipCodeLabel.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        newFrame.origin.x = currentWidth;
        newFrame.origin.y = totalHeight;
        zipCodeLabel.frame = newFrame;
        [self.addressContent addSubview:zipCodeLabel];
    }
    
    CGRect addressContentFrame = self.addressContent.frame;
    addressContentFrame.size.height = totalHeight;
    addressContentFrame.size.width = self.view.frame.size.width;
    self.addressContent.frame = addressContentFrame;
}

-(void) createButtons {
    
    UIButton *phoneCallButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    [phoneCallButton setBackgroundImage:[UIImage imageNamed:@"phoneIcon"] forState:UIControlStateNormal];
    [phoneCallButton addTarget:self action:@selector(onPhoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    CGRect newFrame = self.buttonContent.frame;
    newFrame.size.height = 40;
    self.buttonContent.frame = newFrame;
    [self.buttonContent addSubview:phoneCallButton];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.view.bounds.size.height/10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.personModel forKey:@"person"];
    switch (indexPath.row) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactBirthdayEditScreen" object:nil userInfo:userInfo];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactAddressesList" object:nil userInfo:userInfo];
            break;
        case 2:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactPhoneNumbersList" object:nil userInfo:userInfo];
            break;
        case 3:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactEmailAddressesList" object:nil userInfo:userInfo];
            break;
        case 4:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactInstantMessengerAccountsList" object:nil userInfo:userInfo];
            break;
        case 5:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactFacebookAccountsList" object:nil userInfo:userInfo];
            break;
        case 6:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactGooglePlusAccountsList" object:nil userInfo:userInfo];
            break;
        case 7:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactLinkedInAccountsList" object:nil userInfo:userInfo];
            break;
        case 8:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showTwitterAccountsList" object:nil userInfo:userInfo];
            break;
        case 9:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showRelationshipsList" object:nil userInfo:userInfo];
            break;
        default:
            break;
    }
}

-(IBAction)onPhoneButtonClick:(id)sender {
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

@end
