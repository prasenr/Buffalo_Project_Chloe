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
@end

@implementation WhoAreYouContactListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)addProfile:(UserProfileModel *)userProfile {
    self.profile = userProfile;
    NSLog(@"profile id2: %@", self.profile.profileID);
}

-(id) init {
    
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
            NSLog(@"record id aprsing: %d", recordID);
            NSLog(@"profile record id: %@", person.contactId);
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //NSSortDescriptor *sortFirstName = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
            //NSSortDescriptor *sortLastName = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
            //self.parsedContacts=[self.parsedContacts sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortFirstName, sortLastName, nil]];
            [self.tableView reloadData];
        });
    });
    
    return self;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    WhoAreYouPersonModel *cellData = [self.parsedContacts objectAtIndex:indexPath.row];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        self.firstNameCellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 30)];
        self.firstNameCellLabel.textColor = [UIColor blackColor];
        self.firstNameCellLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.firstNameCellLabel.adjustsFontSizeToFitWidth = NO;
        [cell.contentView addSubview:self.firstNameCellLabel];

    }
    
    self.firstNameCellLabel.text = cellData.fullName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"index : %ld", (long)indexPath.row);
    WhoAreYouPersonModel *selectedContact = [self.parsedContacts objectAtIndex:indexPath.row];
    ABRecordID recordId = (ABRecordID)[selectedContact.contactId intValue];//*(selectedContact.contactId);
    NSLog(@"record id : %d", recordId);
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    ABRecordRef contactPerson = ABAddressBookGetPersonWithRecordID(addressBookRef,recordId);
    //UserProfileModel *profile = [[UserProfileModel alloc] init];
    
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
    NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
    
    self.profile.firstName = firstName;
    self.profile.lastName = lastName;
    
    self.profile.emailAddresses = [[NSMutableArray alloc] init];
    ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
    
    //6
    NSUInteger j = 0;
    for (j = 0; j < ABMultiValueGetCount(emails); j++) {
        NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
        EmailAddressHistoryModel *emailHistory = [[EmailAddressHistoryModel alloc] init];
        EmailAddressModel *emailAddress = [[EmailAddressModel alloc] init];
        emailAddress.emailAddress = email;
        emailHistory.account = emailAddress;
        [self.profile.emailAddresses addObject:emailHistory];
    }
    
    self.profile.addresses = [[NSMutableArray alloc] init];
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
        aAddressHistory.account = aAddress;
        [self.profile.addresses addObject:aAddressHistory];
    }
    
    self.profile.phoneNumbers = [[NSMutableArray alloc] init];
    ABMultiValueRef phoneProperty = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
    NSArray *phoneNumberArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
    p = 0;
    for(;p< [phoneNumberArray count]; p++) {

        NSString *aPhoneType = (__bridge NSString*) ABMultiValueCopyLabelAtIndex(phoneProperty,p);
        PhoneNumberHistoryModel *aPhoneHistory = [[PhoneNumberHistoryModel alloc] init];
        PhoneNumberModel *aPhoneNumber = [[PhoneNumberModel alloc] init];
        [aPhoneNumber setRawPhoneNumber:[phoneNumberArray objectAtIndex:p]];
        aPhoneHistory.account = aPhoneNumber;
        aPhoneNumber.type = aPhoneType;
        [self.profile.phoneNumbers addObject:aPhoneHistory];
    }
    
    self.profile.instantMessengerAccounts = [[NSMutableArray alloc] init];
    ABMultiValueRef instantMessengerProperty = ABRecordCopyValue(contactPerson, kABPersonInstantMessageProperty);
    NSArray *instantMessengerArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(instantMessengerProperty);
    p = 0;
    for(;p<[instantMessengerArray count];p++) {
        NSString *aInstantMessengerType = (__bridge NSString*) ABMultiValueCopyLabelAtIndex(instantMessengerProperty,p);
        InstantMessengerAccountHistoryModel *aInstantMessengerHistory = [[InstantMessengerAccountHistoryModel alloc] init];
        InstantMessengerModel *aInstantMessenger = [[InstantMessengerModel alloc] init];
        aInstantMessenger.username = [instantMessengerArray objectAtIndex:p];
        aInstantMessenger.type = aInstantMessengerType;
        aInstantMessengerHistory.account = aInstantMessenger;
        
        [self.profile.instantMessengerAccounts addObject:aInstantMessengerHistory];
    }
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.profile forKey:@"profile"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"profileSelected" object:nil userInfo:userInfo];
    
    NSDictionary *userInfo1 = [NSDictionary dictionaryWithObject:selectedContact forKey:@"contactId"];
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

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
