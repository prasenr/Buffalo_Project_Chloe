//
//  WhoAreYouContactListViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 7/15/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "WhoAreYouContactListViewController.h"

@interface WhoAreYouContactListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *allContacts;
@property (nonatomic, strong) NSMutableArray *parsedContacts;
@property (nonatomic, strong) UILabel *firstNameCellLabel;
@property (nonatomic, strong) UILabel *lastNameCellLabel;
@property (nonatomic, strong) UserProfileModel *profile;
@property (nonatomic, strong) NSMutableDictionary *selectedContacts;
@end

@implementation WhoAreYouContactListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)addProfile:(UserProfileModel *)userProfile {
    self.profile = userProfile;
    NSLog(@"profile id2: %@", self.profile.profileID);
}

-(id) init {
    self.selectedContacts = [[NSMutableDictionary alloc] init];
    self.parsedContacts = [[NSMutableArray alloc] init];
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    self.allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    //__block NSData *imageData;
    dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.buffaloproject.contactsBGqueue", NULL);
    
    dispatch_async(backgroundQueue, ^(void) {
        NSUInteger i = 0; for (i = 0; i < [self.allContacts count]; i++) {
            WhoAreYouPersonModel *person = [[WhoAreYouPersonModel alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)self.allContacts[i];
            ABRecordID recordID = ABRecordGetRecordID(contactPerson);
            NSMutableString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson,
                                                                                  kABPersonFirstNameProperty);
            NSMutableString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            
            if(firstName != nil && lastName != nil) {
                NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                if(firstName == nil) {
                    firstName = [[NSMutableString alloc] initWithString:@""];
                    fullName = [NSString stringWithFormat:@"%@", lastName];
                }
                if(lastName == nil) {
                    lastName = [[NSMutableString alloc] initWithString:@""];
                    fullName = [NSString stringWithFormat:@"%@", firstName];
                }
                
                person.firstName = firstName;
                person.lastName = lastName;
                person.fullName = fullName;
                person.contactId = [NSNumber numberWithInt:(int)recordID];
                [self.parsedContacts addObject:person];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSSortDescriptor *sortFirstName = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
            NSSortDescriptor *sortLastName = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
            self.parsedContacts=[self.parsedContacts sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortFirstName, sortLastName, nil]];
            [self.tableView reloadData];
        });
    });
    
    return self;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    WhoAreYouPersonModel *cellData = [self.parsedContacts objectAtIndex:indexPath.row];
    
    if(!cell) {
        

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[UIColor colorWithRed:104.0/255.0 green:137.0/255.0 blue:179.0/255.0 alpha:1.0]];
        [cell setSelectedBackgroundView:bgColorView];
        
        self.firstNameCellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 30)];
        self.firstNameCellLabel.textColor = [UIColor blackColor];
        self.firstNameCellLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.firstNameCellLabel.adjustsFontSizeToFitWidth = NO;
        [cell.contentView addSubview:self.firstNameCellLabel];

    }
    
    self.firstNameCellLabel.text = cellData.fullName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.selectedContacts removeObjectForKey:[NSString stringWithFormat:@"%ld",  (long)indexPath.row]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    WhoAreYouPersonModel *selectedContact = [self.parsedContacts objectAtIndex:indexPath.row];
    [self.selectedContacts setObject:selectedContact forKey:[NSString stringWithFormat:@"%ld",  (long)indexPath.row]];
}

-(IBAction)onDoneTouch:(id)sender {

    self.profile.emailAddresses = [[NSMutableArray alloc] init];
    self.profile.addresses = [[NSMutableArray alloc] init];
    self.profile.phoneNumbers = [[NSMutableArray alloc] init];
    self.profile.instantMessengerAccounts = [[NSMutableArray alloc] init];
    self.profile.calendars = [[NSMutableArray alloc] init];
    self.profile.facebookAccounts = [[NSMutableArray alloc] init];
    self.profile.googlePlusAccounts = [[NSMutableArray alloc] init];
    self.profile.birthday = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    self.profile.fullName = @"";
    self.profile.linkedInAccounts = [[NSMutableArray alloc] init];
    self.profile.names = [[NSMutableArray alloc] init];
    self.profile.password = @"";
    self.profile.relationships = [[NSMutableArray alloc] init];
    self.profile.twitterAccounts = [[NSMutableArray alloc] init];
    self.profile.userName = @"";
    self.profile.personImage = @"";
    
    NSMutableArray *selectedRecordIds = [[NSMutableArray alloc] init];
    NSArray *allKeys = [self.selectedContacts allKeys];
    NSUInteger m = 0;
    for (m = 0; m < [allKeys count]; m++) {
        NSSortDescriptor *sortFirstName = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
        NSSortDescriptor *sortLastName = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
        self.parsedContacts=[self.parsedContacts sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortFirstName, sortLastName, nil]];
        
        WhoAreYouPersonModel *selectedContact = [self.selectedContacts objectForKey:[allKeys objectAtIndex:m]];
        ABRecordID recordId = (ABRecordID)[selectedContact.contactId intValue];//*(selectedContact.contactId);
        [selectedRecordIds addObject:selectedContact.contactId];
        
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
        ABRecordRef contactPerson = ABAddressBookGetPersonWithRecordID(addressBookRef,recordId);
        //UserProfileModel *profile = [[UserProfileModel alloc] init];
        
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
        NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
        
        self.profile.firstName = firstName;
        self.profile.lastName = lastName;
        
        
        ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
        
        //6
        NSUInteger j = 0;
        for (j = 0; j < ABMultiValueGetCount(emails); j++) {
            NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
            NSString *emailType = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(emails, j);
            EmailAddressHistoryModel *emailHistory = [[EmailAddressHistoryModel alloc] init];
            EmailAddressModel *emailAddress = [[EmailAddressModel alloc] init];
            emailAddress.emailAddress = email;
            emailAddress.emailType = emailType;
            emailHistory.account = emailAddress;
            [self.profile.emailAddresses addObject:emailHistory];
        }
        
        
        ABMultiValueRef addressProperty = ABRecordCopyValue(contactPerson, kABPersonAddressProperty);
        NSArray *addresses = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(addressProperty);
        NSUInteger p = 0;
        for(;p< [addresses count]; p++) {
            AddressHistoryModel *aAddressHistory = [[AddressHistoryModel alloc] init];
            AddressModel *aAddress = [[AddressModel alloc] init];
            
            NSDictionary *aPotentialAddress = (__bridge NSDictionary *)((__bridge ABRecordRef)([addresses objectAtIndex:p]));
            NSString *aAddressType = (__bridge NSString*) ABMultiValueCopyLabelAtIndex(addressProperty,p);
            
            for (NSString* key in aPotentialAddress) {
                
                NSString *value = [aPotentialAddress objectForKey:key];
                if([key isEqual: @"Country"]) {
                    aAddress.country = [aPotentialAddress objectForKey:key];
                    
                }
                
                if([key isEqual: @"Street"]) {
                    aAddress.addressLine1 = [aPotentialAddress objectForKey:key];
                }
                
                if([key isEqual:@"ZIP"]) {
                    aAddress.zipcode = [aPotentialAddress objectForKey:key];
                }
                
                if([key isEqual:@"City"]) {
                    aAddress.city = [aPotentialAddress objectForKey:key];
                }
                if([key isEqual:@"State"]) {
                    aAddress.state = [aPotentialAddress objectForKey:key];
                }
            }
            aAddress.type  = aAddressType;
            aAddressHistory.account = aAddress;
            [self.profile.addresses addObject:aAddressHistory];
        }
        
        
        ABMultiValueRef phones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);

        for (j = 0; j < ABMultiValueGetCount(phones); j++) {
            NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, j);
            NSString *phoneType = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, j);
            PhoneNumberHistoryModel *phoneHistory = [[PhoneNumberHistoryModel alloc] init];
            PhoneNumberModel *phoneAccount = [[PhoneNumberModel alloc] init];
            [phoneAccount setRawPhoneNumber:phone];
            phoneAccount.type = [NSMutableString stringWithString:phoneType];
            phoneHistory.account = phoneAccount;
            [self.profile.phoneNumbers addObject:phoneHistory];

        }
        
        
        ABMultiValueRef instantMessengerAccounts = ABRecordCopyValue(contactPerson, kABPersonInstantMessageProperty);
        
        for (j = 0; j < ABMultiValueGetCount(instantMessengerAccounts); j++) {
            NSDictionary *instantMessengerAccount = (__bridge_transfer NSDictionary *)ABMultiValueCopyValueAtIndex(instantMessengerAccounts, j);
            InstantMessengerAccountHistoryModel *imHistory = [[InstantMessengerAccountHistoryModel alloc] init];
            InstantMessengerModel *imAccount = [[InstantMessengerModel alloc] init];
            imAccount.username = [instantMessengerAccount objectForKey:@"username"];
            imAccount.serverType = [instantMessengerAccount objectForKey:@"service"];
            imHistory.account = imAccount;
            [self.profile.instantMessengerAccounts addObject:imHistory];
        }
    }
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.profile forKey:@"profile"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"profileSelected" object:nil userInfo:userInfo];
    
    NSDictionary *userInfo1 = [NSDictionary dictionaryWithObject:selectedRecordIds forKey:@"contactId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"processContacts" object:nil userInfo:userInfo1];
    
}



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger theCount = [self.parsedContacts count];
    return theCount;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect labelFrame1 = CGRectMake(25, 80, self.view.frame.size.width - 25, 18);
    UILabel *justSoYouKnowLabel = [[UILabel alloc] initWithFrame:labelFrame1];
    [justSoYouKnowLabel setFont:[UIFont fontWithName:@"Didot" size:30]];
    [justSoYouKnowLabel setText:@"Who are you"];
    [justSoYouKnowLabel setTextColor:[UIColor whiteColor]];
    [justSoYouKnowLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:justSoYouKnowLabel];
    
    CGSize maxiToDoMeetingSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    CGRect expectedLabelSize = [justSoYouKnowLabel.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:justSoYouKnowLabel.font} context:nil ];
    
    CGRect newFrame = justSoYouKnowLabel.frame;
    newFrame.size.height = expectedLabelSize.size.height;
    newFrame.size.width = expectedLabelSize.size.width;
    newFrame.origin.x = 20;
    newFrame.origin.y = 20;
    justSoYouKnowLabel.frame = newFrame;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelection = YES;
    [self.view addSubview:self.tableView];
    
    UIButton *doneButton = [[UIButton alloc] init];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    doneButton.titleLabel.textColor = [UIColor whiteColor];
    doneButton.backgroundColor = [UIColor colorWithRed:104.0/255.0 green:137.0/255.0 blue:179.0/255.0 alpha:1.0];
    doneButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [doneButton sizeToFit];
    [doneButton addTarget:self action:@selector(onDoneTouch:) forControlEvents:UIControlEventTouchUpInside];
    CGRect newButtonFrame = doneButton.frame;
    newButtonFrame.origin.y = self.view.bounds.size.height - 50;
    newButtonFrame.origin.x = 0;
    newButtonFrame.size.width = self.view.bounds.size.width;
    newButtonFrame.size.height = 50;
    doneButton.frame = newButtonFrame;
    
    [self.view addSubview:doneButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
