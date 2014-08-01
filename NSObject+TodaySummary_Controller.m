//
//  NSObject+TodaySummary_Controller.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "NSObject+TodaySummary_Controller.h"
#import "NSObject+TodaySummaryClient.h"
#import "NSObject+TodaySummaryItems.h"
#import "NSObject+UserUtil.h"
#import "NSObject+MeetingModel.h"
#import "ToDoModel.h"
#import <TSMessages/TSMessage.h>

@interface TodaySummary_Controller()
@property(nonatomic, strong, readwrite)TodaySummaryItems *currentTodaySummary;
@property(nonatomic, strong, readwrite)NSMutableArray *todaySummaryListItems;
@property(nonatomic, strong, readwrite)NSNumber *fetchTodaySummaryTrigger;
@property(nonatomic, strong, readwrite)NSMutableArray *rawMeetings;
@property(nonatomic, strong, readwrite)NSMutableDictionary *allMeetingsSorted;
@property(nonatomic, strong, readwrite)NSMutableArray *rawToDos;
@property(nonatomic, strong, readwrite)NSMutableDictionary *allToDosSorted;
@property(nonatomic, strong, readwrite)NSMutableArray *contacts;
@property(nonatomic, strong) NSMutableArray *selectedProfileIds;

@property (nonatomic, strong) TodaySummaryClient *client;
@property (nonatomic, strong) UserUtil *userUtil;


@end

static NSDateFormatter *dateFormatter = nil;
static NSDateFormatter *timeFormatter = nil;
@implementation TodaySummary_Controller :NSObject

+(instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(id)init {
    if (self= [super init]) {
        
        self.fetchTodaySummaryTrigger = 0;
        self.todaySummaryListItems = [[NSMutableArray alloc] init];
        self.allMeetingsSorted = [[NSMutableDictionary alloc] init];
        self.allToDosSorted = [[NSMutableDictionary alloc] init];
        self.contacts = [[NSMutableArray alloc] init];
        
        _client = [[TodaySummaryClient alloc] init];
        
        [[[[RACObserve(self, fetchTodaySummaryTrigger)
            ignore:nil]
           
           flattenMap:^(TodaySummaryItems *newTodaySummaryItem) {
               return [RACSignal merge:@[
                                         [self updateTodaySummary]
                                         ]];
               
           }] deliverOn:RACScheduler.mainThreadScheduler]
         
         subscribeError:^(NSError *error) {
             [TSMessage showNotificationWithTitle:@"Error" subtitle:@"There was a problem fetching today summary" type:TSMessageNotificationTypeError];
         }];
    }
    return self;
}

-(RACSignal *) updateTodayWeather {
    return [[self.client fetchTodayWeather:[self.userUtil getUserDWKey] :[self.userUtil getUserPublicKey] ] doNext:^(TodaySummaryItems *todaySummaryItems){
        self.currentTodaySummary = todaySummaryItems;
    }];
}

-(RACSignal *) updateTodaySummary {
    return [[self.client fetchTodaySummary] doNext:^(TodaySummaryItems *todaySummaryItems) {
        self.currentTodaySummary = todaySummaryItems;
    }];
}

-(void)addMeetings:(NSMutableArray *)meetings {
    self.rawMeetings = meetings;
    [self createTodayTodosMeetings];
    [self sortMeetings];
    
}

-(void)addToDos:(NSMutableArray *)todos {
    self.rawToDos = todos;
    
    /*NSSortDescriptor *startDateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
     NSSortDescriptor *endDateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
     NSArray *sortArray = [[NSArray alloc] initWithObjects:startDateSortDescriptor, nil];
     [self.rawToDos sortUsingDescriptors:sortArray];*/
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //NSArray *sortedArray;
    
    self.rawToDos = [[NSMutableArray alloc] initWithArray:[self.rawToDos sortedArrayUsingDescriptors:sortDescriptors] copyItems:YES];
    // NSArray *reverseToDos = [[self.rawToDos reverseObjectEnumerator] allObjects];
    
    //self.rawToDos = [[NSMutableArray alloc] initWithArray:reverseToDos copyItems:NO];
    
    [self createTodayTodosMeetings];
    self.allToDosSorted = [[NSMutableDictionary alloc] init];
    [self sortToDos];
    
    NSSortDescriptor *keySortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"key"
                                                                      ascending:YES];
    NSArray *keySortDescriptors = [[NSArray alloc] initWithObjects:keySortDescriptor, nil];
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    for(NSString *aKey in [self.allToDosSorted allKeys]) {
        NSDictionary *aDateDict = [self.allToDosSorted valueForKey:aKey];
        /*keySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"key" ascending:YES comparator:^(id obj1, id obj2) {
         
         if (obj1 > obj2) {
         return (NSComparisonResult)NSOrderedDescending;
         }
         if (obj1 < obj2) {
         return (NSComparisonResult)NSOrderedAscending;
         }
         return (NSComparisonResult)NSOrderedSame;
         }];*/
        
        
        NSArray *allTimeKeys = [aDateDict allKeys];
        
        // sortedArray = [anArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]
        NSArray *sortedKeys = [allTimeKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSMutableDictionary *orderedDictionary = [NSMutableDictionary dictionary];
        
        for (NSString *index in sortedKeys) {
            [orderedDictionary setObject:[aDateDict objectForKey:index] forKey:index];
        }
        
        [tempDict setObject:orderedDictionary forKey:aKey];
        //[self.allToDosSorted setObject:orderedDictionary forKey:aKey];
    }
    
    NSLog(@"Hello");
}

-(void)completeToDo:(ToDoModel *)listItem {
    int i = 0;
    for(;i<[self.todaySummaryListItems count];i++) {
        NSString *className = NSStringFromClass([[self.todaySummaryListItems objectAtIndex:i] class]);
        if([className  isEqual: @"ToDoModel"]) {
            ToDoModel *possibleListItem =[self.todaySummaryListItems objectAtIndex:i];
            if(possibleListItem.todoid == listItem.todoid) {
                possibleListItem = listItem;
            }
        }
    }
    
    for(ToDoModel __strong *possibleListItem in self.rawToDos) {
        if(listItem.todoid == possibleListItem.todoid) {
            possibleListItem = listItem;
        }
    }
}

-(void)deleteToDo:(ToDoModel *)listItem {
    int i = 0;
    for(;i<[self.todaySummaryListItems count];i++) {
        NSString *className = NSStringFromClass([[self.todaySummaryListItems objectAtIndex:i] class]);
        if([className  isEqual: @"ToDoModel"]) {
            ToDoModel *possibleListItem =[self.todaySummaryListItems objectAtIndex:i];
            if(listItem.todoid == possibleListItem.todoid) {
                [self.todaySummaryListItems removeObjectAtIndex:i];
                break;
            }
        }
        i++;
    }
    
    i = 0;
    
    for(ToDoModel __strong *possibleListItem in self.rawToDos) {
        if(listItem.todoid == possibleListItem.todoid) {
            [self.rawToDos removeObjectAtIndex:i];
            break;
        }
    }
}

-(void)completeMeeting:(MeetingModel *)meeting {
    int i = 0;
    for(;i<[self.todaySummaryListItems count];i++) {
        NSString *className = NSStringFromClass([[self.todaySummaryListItems objectAtIndex:i] class]);
        if([className  isEqual: @"MeetingModel"]) {
            MeetingModel *possibleListItem =[self.todaySummaryListItems objectAtIndex:i];
            if(possibleListItem.meetingId == meeting.meetingId) {
                possibleListItem = meeting;
            }
        }
    }
    
    for(MeetingModel __strong *possibleListItem in self.rawMeetings) {
        if(meeting.meetingId == possibleListItem.meetingId) {
            possibleListItem = meeting;
        }
    }
}

-(void)deleteMeeting:(MeetingModel *)meeting{
    int i = 0;
    for(;i<[self.todaySummaryListItems count];i++) {
        NSString *className = NSStringFromClass([[self.todaySummaryListItems objectAtIndex:i] class]);
        if([className  isEqual: @"MeetingModel"]) {
            MeetingModel *possibleListItem =[self.todaySummaryListItems objectAtIndex:i];
            if(meeting.meetingId == possibleListItem.meetingId) {
                [self.todaySummaryListItems removeObjectAtIndex:i];
                break;
            }
        }
        i++;
    }
    
    i = 0;
    
    for(MeetingModel __strong *possibleListItem in self.rawMeetings) {
        if(meeting.meetingId == possibleListItem.meetingId) {
            [self.rawMeetings removeObjectAtIndex:i];
            break;
        }
    }
}

-(void)helpMe {
    NSLog(@"you mmama");
}

-(void) fetchTodaySummary {
    
    int value = [self.fetchTodaySummaryTrigger intValue];
    self.fetchTodaySummaryTrigger = [NSNumber numberWithInt:value + 1];
}

-(void)createTodayTodosMeetings {
    
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyy"];
    }
    
    self.todaySummaryListItems = [[NSMutableArray alloc] init];
    
    NSDate *today = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSDate *beginningOfTime = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    
    for (MeetingModel *possibleMeeting in self.rawMeetings) {
        NSString *todayFormatted = [dateFormatter stringFromDate:today];
        NSString *startDateFormatted = [dateFormatter stringFromDate:possibleMeeting.startDate];
        NSString *begininngOfTimeFormatted = [dateFormatter stringFromDate:beginningOfTime];
        
        if([todayFormatted isEqualToString: startDateFormatted] || [startDateFormatted isEqualToString:begininngOfTimeFormatted]){
            [self.todaySummaryListItems addObject:possibleMeeting];
        }
    }
    
    for(ToDoModel *possibleToDo in self.rawToDos) {
        NSString *todayFormatted = [dateFormatter stringFromDate:today];
        NSString *startDateFormatted = [dateFormatter stringFromDate:possibleToDo.startDate];
        NSString *begininngOfTimeFormatted = [dateFormatter stringFromDate:beginningOfTime];
        if([todayFormatted isEqualToString: startDateFormatted] || [startDateFormatted isEqualToString:begininngOfTimeFormatted]) {
            [self.todaySummaryListItems addObject:possibleToDo];
        }
    }
    
    NSSortDescriptor *startDateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
    NSSortDescriptor *endDateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:startDateSortDescriptor, endDateSortDescriptor, nil];
    [self.todaySummaryListItems sortUsingDescriptors:sortArray];
}

-(NSInteger) daysBetweenDate: (NSDate *)firstDate andDate: (NSDate *)secondDate{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components: NSDayCalendarUnit
                                                      fromDate: firstDate
                                                        toDate: secondDate
                                                       options: 0];
    
    NSInteger days = [components day];
    return days;
}

-(void)sortToDos {
    
    if(timeFormatter == nil){
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"hh:mma"];
    }
    
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyy"];
    }
    
    for(ToDoModel *newToDo in self.rawToDos) {
        [self aToDoStartDate:[dateFormatter stringFromDate:newToDo.startDate] aToDoStartTime:[timeFormatter stringFromDate:newToDo.startDate] aNewTodo:newToDo];
    }
}

-(void)aToDoStartDate:(NSString *)aDate aToDoStartTime:(NSString*)aTime aNewTodo:(ToDoModel *)newToDo {
    
    if([self.allToDosSorted valueForKey:aDate]==nil) {
        [self.allToDosSorted setObject:[[NSMutableDictionary alloc] init] forKey:aDate];
    }
    
    if([[self.allToDosSorted valueForKey:aDate] valueForKey:aTime] == nil) {
        [[self.allToDosSorted valueForKey:aDate] setObject:[[NSMutableArray alloc] init] forKey:aTime];
    }
    [[[self.allToDosSorted valueForKey:aDate] valueForKey:aTime] addObject:newToDo];
}

-(void)sortMeetings {
    if(timeFormatter == nil){
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"hh:mma"];
    }
    
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyy"];
    }
    
    for(MeetingModel *newMeeting in self.rawMeetings) {
        [self aMeetingStartDate:[dateFormatter stringFromDate:newMeeting.startDate] aMeetingStartTime:[timeFormatter stringFromDate:newMeeting.startDate] aNewMeeting:newMeeting];
    }
}

-(void)aMeetingStartDate:(NSString*)aDate aMeetingStartTime:(NSString*)aTime aNewMeeting:(MeetingModel *)newMeeting{
    
    if([self.allMeetingsSorted valueForKey:aDate]==nil) {
        [self.allMeetingsSorted setObject:[[NSMutableDictionary alloc] init] forKey:aDate];
    }
    
    if([[self.allMeetingsSorted valueForKey:aDate] valueForKey:aTime] == nil) {
        [[self.allMeetingsSorted valueForKey:aDate] setObject:[[NSMutableArray alloc] init] forKey:aTime];
    }
    [[[self.allMeetingsSorted valueForKey:aDate] valueForKey:aTime] addObject:newMeeting];
}

-(BOOL) isASelectedId:(int *)possibleMatchId {
    
    NSInteger i = 0;
    BOOL found = false;
    for(i = 0;i<[self.selectedProfileIds count]; i++) {
        NSNumber *selectedProfileId = [self.selectedProfileIds objectAtIndex:i];
        // int value = [self.fetchTodaySummaryTrigger intValue];
        int value = [selectedProfileId intValue];
        if(value == possibleMatchId) {
            found = true;
        }
    }
    
    return found;
}

-(void)processContacts:(NSMutableArray *)userProfileIds {
    
    NSMutableDictionary *tempContacts = [[NSMutableDictionary alloc] init];
    self.selectedProfileIds = userProfileIds;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    NSArray *allContacts = [[NSArray alloc] init];
    allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.buffaloproject.contactsBGqueue", NULL);
    
    dispatch_async(backgroundQueue, ^(void) {
        NSUInteger i = 0;
        int k = 40;
        for (i = 0; i < [allContacts count]; i++)
        {
            PersonModel *profile;
            //ABRecordRef contactPerson = ABAddressBookGetPersonWithRecordID(addressBookRef,recordId);
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            ABRecordID recordID = ABRecordGetRecordID(contactPerson);
            if(![self isASelectedId:&recordID])
            {
                NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                NSString *fullName = [NSString stringWithFormat:@"%@%@", firstName, lastName];
                
                if([tempContacts valueForKey:fullName]!=nil)
                {
                    
                    profile = [tempContacts valueForKey:fullName];
                    
                    ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
                    
                    NSUInteger j = 0;
                    for (j = 0; j < ABMultiValueGetCount(emails); j++) {
                        NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                        EmailAddressHistoryModel *emailHistory = [[EmailAddressHistoryModel alloc] init];
                        EmailAddressModel *emailAddress = [[EmailAddressModel alloc] init];
                        emailAddress.emailAddress = [[NSMutableString alloc] initWithString: email];
                        emailHistory.account = emailAddress;
                        [profile.emailAddresses addObject:emailHistory];
                    }
                    
                    profile.addresses = [[NSMutableArray alloc] init];
                    ABMultiValueRef addressProperty = ABRecordCopyValue(contactPerson, kABPersonAddressProperty);
                    NSArray *addresses = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(addressProperty);
                    NSUInteger p = 0;
                    for(;p< [addresses count]; p++)
                    {
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
                        [profile.addresses addObject:aAddressHistory];
                    }
                    
                    profile.phoneNumbers = [[NSMutableArray alloc] init];
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
                        [profile.phoneNumbers addObject:aPhoneHistory];
                    }
                    
                    profile.instantMessengerAccounts = [[NSMutableArray alloc] init];
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
                        
                        [profile.instantMessengerAccounts addObject:aInstantMessengerHistory];
                    }
                } else {
                    
                    profile = [[PersonModel alloc] init];
                    
                    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                    NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                    
                    if(firstName !=nil || lastName!=nil) {
                        
                        profile.firstName = [[NSMutableString alloc] initWithString: firstName];
                        profile.lastName = lastName;
                        
                        NSArray *names = [[NSArray alloc] initWithObjects:@"Shane Landry", @"Adrienne Fisher", @"Claire Cunningham", @"Darrell Simien", @"Kelley Bogdan", @"Maddie Hill", @"Allison DiMartino", @"Matt Smith", @"Leslie Simein", @"Justin Watkins", @"Jessica Cox", @"Paul Gordon", @"Zach Frank", @"John Tenjack", @"Lindsey Patterson", @"Megan Voepel", nil];
                        
                        NSString *longName = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
                        NSLog(@"name: %@", longName);
                        
                        BOOL found = false;
                        
                        NSUInteger m = 0;
                        
                        for (m = 0; m < [names count]; m++) {
                            if([longName isEqualToString:[names objectAtIndex:m]]) {
                                profile.numberOfConversations = [NSNumber numberWithInt:k];
                                k--;
                                found = true;
                            }
                        }
                        
                        if(!found) {
                            profile.numberOfConversations = 0;
                        }
                        
                        
                        profile.personBigImage = [self getBigImage:[NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName]];
                        profile.personImage = [self getImage:[NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName]];
                        
                        profile.emailAddresses = [[NSMutableArray alloc] init];
                        ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
                        
                        //6
                        NSUInteger j = 0;
                        for (j = 0; j < ABMultiValueGetCount(emails); j++) {
                            NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                            NSString *emailType = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(emails, j);
                            EmailAddressHistoryModel *emailHistory = [[EmailAddressHistoryModel alloc] init];
                            EmailAddressModel *emailAddress = [[EmailAddressModel alloc] init];
                            emailAddress.emailAddress = email;
                            emailHistory.account = emailAddress;
                            [profile.emailAddresses addObject:emailHistory];
                        }
                        
                        profile.addresses = [[NSMutableArray alloc] init];
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
                            [profile.addresses addObject:aAddressHistory];
                        }
                        
                        profile.phoneNumbers = [[NSMutableArray alloc] init];
                        ABMultiValueRef phones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                        
                        for (j = 0; j < ABMultiValueGetCount(phones); j++) {
                            NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, j);
                            NSString *phoneType = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, j);
                            PhoneNumberHistoryModel *phoneHistory = [[PhoneNumberHistoryModel alloc] init];
                            PhoneNumberModel *phoneAccount = [[PhoneNumberModel alloc] init];
                            [phoneAccount setRawPhoneNumber:phone];
                            phoneAccount.type = [NSMutableString stringWithFormat:phoneType];
                            phoneHistory.account = phoneAccount;
                            [profile.phoneNumbers addObject:phoneHistory];
                            
                        }
                        
                        profile.instantMessengerAccounts = [[NSMutableArray alloc] init];
                        ABMultiValueRef instantMessengerAccounts = ABRecordCopyValue(contactPerson, kABPersonInstantMessageProperty);
                        
                        for (j = 0; j < ABMultiValueGetCount(instantMessengerAccounts); j++) {
                            NSDictionary *instantMessengerAccount = (__bridge_transfer NSDictionary *)ABMultiValueCopyValueAtIndex(instantMessengerAccounts, j);
                            InstantMessengerAccountHistoryModel *imHistory = [[InstantMessengerAccountHistoryModel alloc] init];
                            InstantMessengerModel *imAccount = [[InstantMessengerModel alloc] init];
                            imAccount.username = [instantMessengerAccount objectForKey:@"username"];
                            imAccount.serverType = [instantMessengerAccount objectForKey:@"service"];
                            imHistory.account = imAccount;
                            [profile.instantMessengerAccounts addObject:imHistory];
                        }
                        [tempContacts setValue:profile forKey:fullName];
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [TSMessage showNotificationWithTitle:@"Contact Done" subtitle:@"We have all of your contacts.  We are working on getting you their up-to-date information." type:TSMessageNotificationTypeMessage];
            
            NSArray *allKeys = [tempContacts allKeys];
            
            for(NSString *aKey in allKeys) {
                PersonModel *tempPerson = [tempContacts valueForKey:aKey];
                [self.contacts addObject:tempPerson];
            }
            
            
            NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"numberOfConversations" ascending:NO];
            
            NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,  nil];
            
            self.contacts = [[NSMutableArray alloc] initWithArray:[self.contacts sortedArrayUsingDescriptors:sortDescriptors]];
            
            NSDictionary *userInfo1 = [NSDictionary dictionaryWithObject:self.contacts forKey:@"contacts"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"contactsProcessed" object:nil userInfo:userInfo1];
        });
    });
}

-(NSString *)getBigImage:(NSString *)name {
    if([name  isEqual: @"Shane Landry"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/shane.png";
    } else if([name  isEqual: @"Adrienne Fisher"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/adrienne.png";
    } else if([name  isEqual: @"Claire Cunningham"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/claire.png";
    } else if([name  isEqual: @"Darrell Simien"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/darrell.png";
    } else if ([name  isEqual: @"Kelley Bogdan"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/kelley.png";
    } else if ([name  isEqual: @"Maddie Hill"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/maddie.png";
    } else if ([name  isEqual: @"Allison DiMartino"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/allison.png";
    } else if([name  isEqual: @"Matt Smith"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/matt.png";
    } else if([name  isEqual: @"Leslie Simein"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/leslie.png";
    } else if([name  isEqual: @"Justin Watkins"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/justin.png";
    } else if([name  isEqual: @"Jessica Cox"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/jessica.png";
    } else if([name  isEqual: @"Paul Gordon"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/paul.png";
    } else if([name  isEqual: @"Zach Frank"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/zach.png";
    } else if([name  isEqual: @"John Tenjack"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/jt.png";
    } else if([name  isEqual: @"Lindsey Patterson"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/lindsey.png";
    } else if([name isEqual:@"Megan Voepel"]){
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/megan.png";
    }else {
        NSMutableString *filePath = [[NSMutableString alloc] init];
        [filePath appendString:@"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/profiledetail/"];
        [filePath appendString:[name substringToIndex:1].lowercaseString];
        [filePath appendString:@".png"];
        return filePath;
    }
}

-(NSString *)getImage:(NSString *)name {
    
    if([name  isEqual: @"Shane Landry"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/shane.png";
    } else if([name  isEqual: @"Adrienne Fisher"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/adrienne.png";
    } else if([name  isEqual: @"Claire Cunningham"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/claire.png";
    } else if([name  isEqual: @"Darrell Simien"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/darrell.png";
    } else if ([name  isEqual: @"Kelley Bogdan"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/kelley.png";
    } else if ([name  isEqual: @"Maddie Hill"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/maddie.png";
    } else if ([name  isEqual: @"Allison DiMartino"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/allison.png";
    } else if([name  isEqual: @"Matt Smith"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/matt.png";
    } else if([name  isEqual: @"Leslie Simein"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/leslie.png";
    } else if([name  isEqual: @"Justin Watkins"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/watkins.png";
    } else if([name  isEqual: @"Jessica Cox"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/jessica.png";
    } else if([name  isEqual: @"Paul Gordon"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/paul.png";
    } else if([name  isEqual: @"Zach Frank"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/zach.png";
    } else if([name  isEqual: @"John Tenjack"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/jt.png";
    } else if([name  isEqual: @"Lindsey Patterson"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/lindsey.png";
    } else if([name isEqual:@"Megan Voepel"]) {
        return @"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/megan.png";
    }else {
        NSMutableString *filePath = [[NSMutableString alloc] init];
        [filePath appendString:@"https://s3-us-west-2.amazonaws.com/buffaloprofileimages/grid/"];
        [filePath appendString:[name substringToIndex:1].lowercaseString];
        [filePath appendString:@".png"];
        return filePath;
    }
}

@end
