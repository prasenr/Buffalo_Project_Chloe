//
//  ContactGridViewController.m
//  Buffalo Project 2
//
//  Created by Christopher Fisher on 8/13/13.
//  Copyright (c) 2013 Christopher Fisher. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactGridPictureViewController.h"
#import "NSObject+PersonModel.h"
#import "ContactSearchCell.h"
#import "SearchButton.h"
#import "AddressModel.h"
#import "AddressHistoryModel.h"
#import "EmailAddressHistoryModel.h"
#import "EmailAddressModel.h"
#import "InstantMessengerAccountHistoryModel.h"
#import "InstantMessengerModel.h"
#import "PhoneNumberHistoryModel.h"
#import "PhoneNumberModel.h"
#import "FacebookAccountHistoryModel.h"
#import "FacebookAccountModel.h"
#import "GooglePlusAccountHistoryModel.h"
#import "GooglePlusAccountModel.h"
#import "LinkedInAccountHistoryModel.h"
#import "LinkedInAccountModel.h"
#import "TwitterAccountHistoryModel.h"
#import "TwitterAccountModel.h"
#import "RelationshipHistoryModel.h"
#import "RelationshipModel.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

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
    
    contacts = [[NSMutableArray alloc] init];
    
    PersonModel *shaneModel = [[PersonModel alloc] init];
    shaneModel.firstName = [NSMutableString stringWithString: @"Shane"];;
    shaneModel.lastName = @"Landry";
    shaneModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/shane.png";
    shaneModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/shane.png";
    shaneModel.birthday = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    shaneModel.addresses = [[NSMutableArray alloc] init];
    [contacts addObject:shaneModel];
    
    
    PersonModel *adrienneModel = [[PersonModel alloc] init];
    adrienneModel.firstName = [NSMutableString stringWithString: @"Adrienne"];
    adrienneModel.lastName = @"Fisher";
    adrienneModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/adrienne.png";
    adrienneModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/adrienne.png";
    adrienneModel.birthday = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    adrienneModel.addresses = [[NSMutableArray alloc] init];
    
    AddressModel *aAddress = [[AddressModel alloc] init];
    aAddress.addressLine1 = [NSMutableString stringWithString: @"616 Dartmouth"];
    aAddress.city = [NSMutableString stringWithString: @"Kansas City"];
    aAddress.state = [NSMutableString stringWithString: @"Missouri"];
    aAddress.zipcode = [NSMutableString stringWithString: @"64114"];
    
    AddressHistoryModel *aAddressHistory = [[AddressHistoryModel alloc] init];
    aAddressHistory.account = aAddress;
    
    [adrienneModel.addresses addObject:aAddressHistory];
    
    
    AddressModel *aAddress1 = [[AddressModel alloc] init];
    aAddress1.addressLine1 = [NSMutableString stringWithString: @"7228 Belleview"];
    aAddress1.city = [NSMutableString stringWithString: @"Kansas City"];
    aAddress1.state = [NSMutableString stringWithString: @"Missouri"];
    aAddress1.zipcode = [NSMutableString stringWithString: @"64113"];
    
    AddressHistoryModel *aAddressHistory1 = [[AddressHistoryModel alloc] init];
    aAddressHistory1.account = aAddress1;
    
    [adrienneModel.addresses addObject:aAddressHistory1];
    
    
    AddressModel *aAddress3 = [[AddressModel alloc] init];
    aAddress3.addressLine1 = [NSMutableString stringWithString: @"702 S. Longfellow"];
    aAddress3.city = [NSMutableString stringWithString: @"Wichita"];
    aAddress3.state = [NSMutableString stringWithString: @"Kansas"];
    aAddress3.zipcode = [NSMutableString stringWithString: @"67207"];
    
    AddressHistoryModel *aAddressHistory3 = [[AddressHistoryModel alloc] init];
    aAddressHistory3.account = aAddress3;
    
    [adrienneModel.addresses addObject:aAddressHistory3];
    
    //PHONE NUMBERS
    PhoneNumberModel *aPhoneNumber = [[PhoneNumberModel alloc] init];
    aPhoneNumber.country = [NSMutableString stringWithString:@"01"];
    aPhoneNumber.areaCode = [NSMutableString stringWithString:@"816"];
    aPhoneNumber.prefix = [NSMutableString stringWithString:@"738"];
    aPhoneNumber.phoneNumber = [NSMutableString stringWithString:@"5554"];
    aPhoneNumber.extension = [NSMutableString stringWithString:@""];
    
    PhoneNumberHistoryModel *aPhoneHistory = [[PhoneNumberHistoryModel alloc] init];
    aPhoneHistory.account = aPhoneNumber;
    
    adrienneModel.phoneNumbers = [[NSMutableArray alloc] init];
    [adrienneModel.phoneNumbers addObject:aPhoneHistory];
    
    
    //EMAIL ACCOUNTS
    EmailAddressModel *aEmailAddress = [[EmailAddressModel alloc] init];
    aEmailAddress.emailAddress = [NSMutableString stringWithString:@"adrienne.f.hill@gmail.com"];
    aEmailAddress.emailType = [NSMutableString stringWithString:@"personal"];
    
    EmailAddressHistoryModel *aEmailAddressHistory = [[EmailAddressHistoryModel alloc] init];
    aEmailAddressHistory.account = aEmailAddress;
    
    adrienneModel.emailAddresses= [[NSMutableArray alloc] init];
    [adrienneModel.emailAddresses addObject:aEmailAddressHistory];
    
    
    //INSTANT MESSENGER ACCOUNTS
    InstantMessengerModel *aInstantMessageAccount = [[InstantMessengerModel alloc] init];
    aInstantMessageAccount.username = [NSMutableString stringWithString:@"adrienne.f.hill@gmail.com"];
    aInstantMessageAccount.serverType = [NSMutableString stringWithString:@"gmail.com"];
    aInstantMessageAccount.type = [NSMutableString stringWithString:@"personal"];
    
    InstantMessengerAccountHistoryModel *aInstantMessengerHistory = [[InstantMessengerAccountHistoryModel alloc] init];
    aInstantMessengerHistory.account = aInstantMessageAccount;
    
    adrienneModel.instantMessengerAccounts = [[NSMutableArray alloc] init];
    [adrienneModel.instantMessengerAccounts addObject:aInstantMessengerHistory];
    
    //FACEBOOK ACCOUNTS
    FacebookAccountModel *aFacebookAccount = [[FacebookAccountModel alloc] init];
    aFacebookAccount.username = [NSMutableString stringWithString:@"123456"];
    aFacebookAccount.type = [NSMutableString stringWithString:@"personal"];
    
    FacebookAccountHistoryModel *aFacebookHistory = [[FacebookAccountHistoryModel alloc] init];
    aFacebookHistory.account = aFacebookAccount;
    
    adrienneModel.facebookAccounts = [[NSMutableArray alloc] init];
    [adrienneModel.facebookAccounts addObject:aFacebookHistory];
    
    //GOOGLE PLUS ACCOUNTS
    GooglePlusAccountModel *aGooglePlusAccount = [[GooglePlusAccountModel alloc] init];
    aGooglePlusAccount.username = [NSMutableString stringWithString:@"1234567"];
    aGooglePlusAccount.type = [NSMutableString stringWithString:@"personal"];
    
    GooglePlusAccountHistoryModel *aGooglePlusHistory = [[GooglePlusAccountHistoryModel alloc] init];
    aGooglePlusHistory.account = aGooglePlusAccount;
    
    adrienneModel.googlePlusAccounts = [[NSMutableArray alloc] init];
    [adrienneModel.googlePlusAccounts addObject:aGooglePlusHistory];
    
    //LINKED IN ACCOUNTS
    LinkedInAccountModel *aLinkedInAccount = [[LinkedInAccountModel alloc] init];
    aLinkedInAccount.username = [NSMutableString stringWithString:@"12345678"];
    aLinkedInAccount.type = [NSMutableString stringWithString:@"persona"];
    
    LinkedInAccountHistoryModel *aLinkedInHistory = [[LinkedInAccountHistoryModel alloc] init];
    aLinkedInHistory.account = aLinkedInAccount;
    
    adrienneModel.linkedInAccounts = [[NSMutableArray alloc] init];
    [adrienneModel.linkedInAccounts addObject:aLinkedInHistory];
    
    //TWITTER ACCOUNTS
    TwitterAccountModel *aTwitterAccount = [[TwitterAccountModel alloc] init];
    aTwitterAccount.username = [NSMutableString stringWithString:@"afhill"];
    aTwitterAccount.type = [NSMutableString stringWithString:@"personal"];
    
    TwitterAccountHistoryModel *aTwitterHistory = [[TwitterAccountHistoryModel alloc] init];
    aTwitterHistory.id = [NSMutableString stringWithString:@"1234"];
    aTwitterHistory.account = aTwitterAccount;
    
    adrienneModel.twitterAccounts = [[NSMutableArray alloc] init];
    [adrienneModel.twitterAccounts addObject:aTwitterHistory];
    
    
    //RELATIONSHIPS
    RelationshipHistoryModel *aRelationshipHistory = [[RelationshipHistoryModel alloc] init];
    RelationshipModel *aRelationship = [[RelationshipModel alloc] init];
    aRelationship.relationshipType = [NSMutableString stringWithString:@"Husband"];
    aRelationship.person = shaneModel;
    aRelationshipHistory.relationship = aRelationship;
    
    adrienneModel.relationships = [[NSMutableArray alloc] init];
    [adrienneModel.relationships addObject:aRelationshipHistory];
    
    
    [contacts addObject:adrienneModel];
    
    PersonModel *claireModel = [[PersonModel alloc] init];
    claireModel.firstName = [NSMutableString stringWithString: @"Claire"];
    claireModel.lastName = @"Cunningham";
    claireModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/claire.png";
    claireModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/claire.png";
    [contacts addObject:claireModel];
    
    PersonModel *darrellModel = [[PersonModel alloc] init];
    darrellModel.firstName = [NSMutableString stringWithString: @"Darrell"];
    darrellModel.lastName = @"Simien";
    darrellModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/darrell.png";
    darrellModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/darrell.png";
    [contacts addObject:darrellModel];
    
    PersonModel *kelleyModel = [[PersonModel alloc] init];
    kelleyModel.firstName = [NSMutableString stringWithString: @"Kelley"];
    kelleyModel.lastName = @"Bogden";
    kelleyModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/kelley.png";
    kelleyModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/kelley.png";
    [contacts addObject:kelleyModel];
    
    PersonModel *maddieModel = [[PersonModel alloc] init];
    maddieModel.firstName = [NSMutableString stringWithString: @"Madeleine"];
    maddieModel.lastName = @"Hill";
    maddieModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/maddie.png";
    maddieModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/maddie.png";
    [contacts addObject:maddieModel];
    
    PersonModel *allisonModel = [[PersonModel alloc] init];
    allisonModel.firstName = [NSMutableString stringWithString: @"Allison"];
    allisonModel.lastName = @"DiMartino";
    allisonModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/allison.png";
    allisonModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/allison.png";
    [contacts addObject:allisonModel];
    
    PersonModel *mattModel = [[PersonModel alloc] init];
    mattModel.firstName = [NSMutableString stringWithString: @"Matt"];
    mattModel.lastName = @"Smith";
    mattModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/matt.png";
    mattModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/matt.png";
    [contacts addObject:mattModel];
    
    PersonModel *leslieModel = [[PersonModel alloc] init];
    leslieModel.firstName = [NSMutableString stringWithString: @"Leslie"];
    leslieModel.lastName = @"Terrill";
    leslieModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/leslie.png";
    leslieModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/leslie.png";
    [contacts addObject:leslieModel];
    
    PersonModel *justinModel = [[PersonModel alloc] init];
    justinModel.firstName = [NSMutableString stringWithString: @"Justin"];
    justinModel.lastName = @"Watkins";
    justinModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/watkins.png";
    justinModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/justin.png";
    [contacts addObject:justinModel];
    
    PersonModel *jessicaModel = [[PersonModel alloc] init];
    jessicaModel.firstName = [NSMutableString stringWithString: @"Jessica"];
    jessicaModel.lastName = @"Cox";
    jessicaModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/jessica.png";
    jessicaModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/jessica.png";
    [contacts addObject:jessicaModel];
    
    PersonModel *paulModel = [[PersonModel alloc] init];
    paulModel.firstName = [NSMutableString stringWithString: @"Paul"];
    paulModel.lastName = @"Gordon";
    paulModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/paul.png";
    paulModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/paul.png";
    [contacts addObject:paulModel];
    
    PersonModel *zachModel = [[PersonModel alloc] init];
    zachModel.firstName = [NSMutableString stringWithString: @"Zach"];
    zachModel.lastName = @"Frank";
    zachModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/zach.png";
    zachModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/zach.png";
    [contacts addObject:zachModel];
    
    PersonModel *jtModel = [[PersonModel alloc] init];
    jtModel.firstName = [NSMutableString stringWithString: @"JT"];
    jtModel.lastName = @"Tenjack";
    jtModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/jt.png";
    jtModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/jt.png";
    [contacts addObject:jtModel];
    
    PersonModel *lindseyModel = [[PersonModel alloc] init];
    lindseyModel.firstName = [NSMutableString stringWithString: @"Lindsey"];
    lindseyModel.lastName = @"Smith";
    lindseyModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/lindsey.png";
    lindseyModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/lindsey.png";
    [contacts addObject:lindseyModel];
    
    PersonModel *meganModel = [[PersonModel alloc] init];
    meganModel.firstName = [NSMutableString stringWithString: @"Megan"];
    meganModel.lastName = @"Voepel";
    meganModel.personImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/megan.png";
    meganModel.personBigImage = @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/megan.png";
    [contacts addObject:meganModel];

    //_allTableData = delegate.contacts;
    
    /*float aFloat = self.view.frame.size.width;
    NSLog(@"This is my float: %f \n\nAnd here again: %.2f", aFloat, aFloat);
    
    float aFloat1 = self.view.frame.size.height;
    NSLog(@"This is my float: %f \n\nAnd here again: %.2f", aFloat1, aFloat1);*/
    
    gridButtons = [[NSMutableArray alloc] init];
    gridHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [gridHolder setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:gridHolder];
    
    int a = 0;
    int b = 16;
    int c = 0;
    int d = 0;
    
    NSInteger xPos[4];
    xPos[0] = 0;
    xPos[1] = 80;
    xPos[2] = 160;
    xPos[3] = 240;
    
    NSInteger yPos[4];
    yPos[0] = 0;
    yPos[1] = 142;
    yPos[2] = 284;
    yPos[3] = 426;
    for(;a<b;a++) {
        ContactGridPictureViewController *contact = [[ContactGridPictureViewController alloc] initWithPerson:[[TodaySummary_Controller sharedManager].contacts objectAtIndex:a] initWithNibName:@"ContactGridPictureViewController" bundle:nil];
        CGRect frame = contact.frame;
        frame.size = CGSizeMake(80, 110);
        frame.origin = CGPointMake(xPos[c], yPos[d]);
        contact.frame = frame;
        
        [gridHolder addSubview:contact];
        [gridButtons addObject:contact];
        c++;
        
        if(c==4) {
            d++;
            c = 0;
        }
    }
    
    UIImage *gridOverlayImage = [UIImage imageNamed:@"contactOverlay.png"];
    UIImageView *gridOverlay = [[UIImageView alloc] initWithImage:gridOverlayImage];
    CGRect overlayFrame = gridOverlay.frame;
    overlayFrame.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    gridOverlay.frame = overlayFrame;
    gridOverlay.alpha = 0.5;
    [gridHolder addSubview:gridOverlay];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBackButtonClickedFromConversationList:) name:@"onContactClicked" object:nil];
    
    header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [header setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:header];
    
    searchHeaderBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [searchHeaderBackground setBackgroundColor:[UIColor blackColor]];
    searchHeaderBackground.alpha = 0;
    [header addSubview:searchHeaderBackground];
    
    
    searchIconButton = [SearchButton buttonWithType:UIButtonTypeCustom];
    UIImage *searchBgImage = [UIImage imageNamed:@"searchIcon.png"];
    [searchIconButton setImage:searchBgImage forState:UIControlStateNormal];
    [searchIconButton setFrame:CGRectMake(19, 19, 15, 16)];
    [searchIconButton addTarget:self action:@selector(searchButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:searchIconButton];
    
    addContactButton = [SearchButton buttonWithType:UIButtonTypeCustom];
    [addContactButton setImage:[UIImage imageNamed:@"plusWhite.png"] forState:UIControlStateNormal];
    [addContactButton setFrame:CGRectMake(286, 19, 15, 15)];
    [header addSubview:addContactButton];
    
    gridButton = [[UIButton alloc] initWithFrame:CGRectMake(286, 19, 17, 17)];
    [gridButton setBackgroundImage:[UIImage imageNamed:@"gridIcon.png"] forState:UIControlStateNormal];
    [gridButton addTarget:self action:@selector(gridButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    gridButton.alpha = 0;
    gridButton.hidden = YES;
    [header addSubview:gridButton];
    
    contactSeachBar = [[UISearchBar alloc] initWithFrame:CGRectMake(3, 19, 280, 16)];
    
    contactSeachBar.backgroundColor = [UIColor clearColor];
    [contactSeachBar setImage:[UIImage imageNamed:@"searchIcon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    contactSeachBar.showsScopeBar = NO;
    contactSeachBar.placeholder = @"I want to find ...";
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"Colaborate-Thin" size:16]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    UIImage *searchIcon = [UIImage imageNamed:@"searchBarBlackBackground.png"];
    [contactSeachBar setSearchFieldBackgroundImage:searchIcon forState:UIControlStateNormal];
    contactSeachBar.delegate = (id)self;
    [header addSubview:contactSeachBar];
    
    for(UIView *subview in contactSeachBar.subviews) {
        if([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    contactSeachBar.hidden = YES;
    contactSeachBar.alpha = 0;
    
    
    colleaguesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, self.view.frame.size.width, 18)];
    [colleaguesLabel setTextColor:[UIColor whiteColor]];
    [colleaguesLabel setText:@"Contacts"];
    [colleaguesLabel setTextAlignment:NSTextAlignmentCenter];
    [colleaguesLabel setFont:[UIFont fontWithName:@"Colaborate-Thin" size:24]];
    [colleaguesLabel setBackgroundColor:[UIColor clearColor]];
    [header addSubview:colleaguesLabel];
    
    /*moreOptions = [[MoreOptionsViewController alloc] initWithNibName:@"MoreOptionsViewController" bundle:nil];
     CGRect moreOptionsFrame = moreOptions.view.frame;
     moreOptionsFrame.size = CGSizeMake(self.view.frame.size.width, 300);
     moreOptionsFrame.origin = CGPointMake(0, 430);
     moreOptions.view.frame = moreOptionsFrame;
     [self.view addSubview:moreOptions.view];*/
    
    
    
    
}

-(void)searchButtonTouched:(id)sender {
    
    for (ContactGridPictureViewController *aGridButton in gridButtons) {
        [aGridButton removeClickListener];
    }
    
    contactSearchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStylePlain];
    contactSearchTableView.delegate = self;
    contactSearchTableView.dataSource = self;
    contactSearchTableView.alpha = 0;
    [self.view addSubview:contactSearchTableView];
    
    CGRect gridTo = CGRectMake(0, -gridHolder.frame.size.height, gridHolder.frame.size.width, gridHolder.frame.size.height);
    CGRect searchTableTo = CGRectMake(0, 50, contactSearchTableView.frame.size.width, contactSearchTableView.frame.size.height);
    
    [contactSeachBar setText:@""];
    gridButton.hidden = NO;
    contactSeachBar.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    searchHeaderBackground.alpha = 1.0;
    addContactButton.alpha = 0;
    colleaguesLabel.alpha = 0;
    searchIconButton.alpha = 0;
    gridButton.alpha = 1;
    contactSeachBar.alpha = 1;
    gridHolder.frame = gridTo;
    contactSearchTableView.frame = searchTableTo;
    [UIView commitAnimations];
}


-(void)gridButtonTouched:(id)sender {
    
    for (ContactGridPictureViewController *aGridButton in gridButtons) {
        [aGridButton addClickListner];
    }
    
    [contactSeachBar resignFirstResponder];
    CGRect gridTo = CGRectMake(0, 0, gridHolder.frame.size.width, gridHolder.frame.size.height);
    CGRect searchTableTo = CGRectMake(0, self.view.frame.size.height, contactSearchTableView.frame.size.width, contactSearchTableView.frame.size.height);
    
    gridButton.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(gridShowing:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    searchHeaderBackground.alpha = 0;
    addContactButton.alpha = 1;
    colleaguesLabel.alpha = 1;
    searchIconButton.alpha = 1;
    gridButton.alpha = 0;
    gridHolder.frame = gridTo;
    contactSeachBar.alpha = 0;
    contactSearchTableView.frame = searchTableTo;
    [UIView commitAnimations];
}

-(void)resetKeyboard {
    [contactSeachBar resignFirstResponder];
}

-(void)reset {
    
    [contactSeachBar resignFirstResponder];
    CGRect gridTo = CGRectMake(0, 0, gridHolder.frame.size.width, gridHolder.frame.size.height);
    CGRect searchTableTo = CGRectMake(0, self.view.frame.size.height, contactSearchTableView.frame.size.width, contactSearchTableView.frame.size.height);
    
    gridButton.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(gridShowing:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    searchHeaderBackground.alpha = 0;
    addContactButton.alpha = 1;
    colleaguesLabel.alpha = 1;
    searchIconButton.alpha = 1;
    gridButton.alpha = 0;
    gridHolder.frame = gridTo;
    contactSeachBar.alpha = 0;
    contactSearchTableView.frame = searchTableTo;
    [UIView commitAnimations];
}

-(void)gridShowing:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    contactSeachBar.hidden = YES;
    [contactSearchTableView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
}
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    UIEdgeInsets insets = [contactSearchTableView contentInset];
    insets.bottom = 216;
    [contactSearchTableView setContentInset:insets];
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    UIEdgeInsets insets = [contactSearchTableView contentInset];
    insets.bottom = 0;
    [contactSearchTableView setContentInset:insets];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text {
    
    if(text.length == 0)
    {
        self.isFiltered = NO;
        self.filteredTableData = [[NSMutableArray alloc] init];
        contactSearchTableView.alpha = 0;
    } else {
        self.isFiltered = YES;
        self.filteredTableData = [[NSMutableArray alloc] init];
        for(PersonModel* person in _allTableData)
        {
            NSRange nameRange = [person.fullName rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound) {
                
                [_filteredTableData addObject:person];
            }
        }
        if([_filteredTableData count]>0) {
            contactSearchTableView.alpha = 1;
        } else {
            contactSearchTableView.alpha = 0;
        }
    }
    
    [contactSearchTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    long rowCount;
    if(self.isFiltered)
        rowCount = _filteredTableData.count;
    else
        rowCount = _allTableData.count;
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactSearchCell";
    
    ContactSearchCell *cell = (ContactSearchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactSearchCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    PersonModel *person;
    if(self.isFiltered)
        person = [_filteredTableData objectAtIndex:indexPath.row];
    else
        person = [_allTableData objectAtIndex:indexPath.row];
    
    cell.fromImage.image = person.personImage;
    cell.fromLabelValue.text = person.fullName;
    [cell setPerson:person];
    
    return cell;
}


-(void)onBackButtonClickedFromConversationList:(PersonModel*)person {
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
