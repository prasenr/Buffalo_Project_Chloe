//
//  ConversationsViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ConversationsViewController.h"
#import "ConversationModel.h"
#import "YoMessage.h"
#import "NSObject+TodaySummary_Controller.h"
#import "MessageBodyModel.h"

@interface ConversationsViewController ()
@property (nonatomic, strong)UIView *firstMessageFetchedStatus;
@property (nonatomic, strong)UILabel *firstMessageFetchStatusLabel;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UILabel *fromLabel;
@property (nonatomic, strong)UIImageView *fromPicture;
@property (nonatomic, strong)UILabel *subject;
@property (nonatomic, strong)UILabel *message;
@end

@implementation ConversationsViewController

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
    // Do any additional setup after loading the view from its nib.
    
    UILabel *contactsHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 50)];
    contactsHeader.backgroundColor = [UIColor clearColor];
    contactsHeader.textColor = [UIColor blackColor];
    contactsHeader.text = @"Conversations";
    contactsHeader.textAlignment = NSTextAlignmentCenter;
    contactsHeader.font = [UIFont fontWithName:@"Colaborate-Thin" size:20];;
    [self.view addSubview:contactsHeader];
    
     self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-50)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    self.firstMessageFetchedStatus = [[UIView alloc] initWithFrame:self.view.bounds];
    self.firstMessageFetchedStatus.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    [self.view addSubview:self.firstMessageFetchedStatus];
    
    self.firstMessageFetchStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width, 50)];
    [self.firstMessageFetchStatusLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    self.firstMessageFetchStatusLabel.text = @"hello";
    self.firstMessageFetchStatusLabel.textColor = [UIColor whiteColor];
    self.firstMessageFetchStatusLabel.textAlignment = NSTextAlignmentCenter;
    [self.firstMessageFetchedStatus addSubview:self.firstMessageFetchStatusLabel];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageProcessed:) name:@"messageFetched" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAllMessagesProcessed:) name:@"messagesFetched" object:nil];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        self.fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, self.view.bounds.size.width-80, 50)];
        self.fromLabel.textColor = [UIColor blackColor];
        [self.fromLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18]];
        
        self.subject = [[UILabel alloc] initWithFrame:CGRectMake(80, 27, self.view.bounds.size.width-80, 50)];
        self.subject.textColor = [UIColor blackColor];
        [self.subject setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16]];
        
        self.message = [[UILabel alloc] initWithFrame:CGRectMake(80, 65, self.view.bounds.size.width-80, 50)];
        self.message.textColor = [UIColor blackColor];
        self.message.adjustsFontSizeToFitWidth = NO;
        self.message.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.message setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        self.message.numberOfLines = 3;
        
        self.fromPicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];

        [cell.contentView addSubview:self.fromLabel];
        [cell.contentView addSubview:self.fromLabel];
        [cell.contentView addSubview:self.subject];
        [cell.contentView addSubview:self.message];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    
    
    ConversationModel *cellConversations = [[TodaySummary_Controller sharedManager].conversations objectAtIndex:indexPath.row];
    YoMessage *lastMessage = [cellConversations.messages objectAtIndex:0];
    
    NSMutableString *from = [NSMutableString stringWithString:@""];
    PersonModel *fromProfile;
    fromProfile = lastMessage.from;
    if(fromProfile) {
        if(fromProfile.firstName) {
            [from appendString:fromProfile.firstName];
            if(fromProfile.lastName) {
                [from appendString:@" "];
                [from appendString:fromProfile.lastName];
            }
        } else if (fromProfile.lastName) {
            [from appendString:fromProfile.lastName];
        } else {
            EmailAddressHistoryModel *emailHistory = fromProfile.emailAddresses[0];
            [from appendString:emailHistory.account.emailAddress];
        }
    }
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fromProfile.conversationSummaryProfileImage]];
    UIImage *imageLoad;
    imageLoad = [[UIImage alloc] initWithData:imageData];
    [self.fromPicture setImage:imageLoad];
    
    self.fromLabel.text = from;
    
    self.subject.text = lastMessage.subject;
    
    MessageBodyModel *messageBody = [lastMessage getPlainTextMessage];
    self.message.text = messageBody.message;
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: Need to determine height;
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[TodaySummary_Controller sharedManager].conversations count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onMessageProcessed:(NSNotification *)notification {
    NSString *status = [[notification userInfo] valueForKey:@"messageProcessedStatus"];
    [self.firstMessageFetchStatusLabel setText:status];
}

-(void) onAllMessagesProcessed:(NSNotification *)notification {
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.firstMessageFetchedStatus.alpha = 0;
                     }completion:^(BOOL finished){
                         [self.firstMessageFetchStatusLabel removeFromSuperview];
                         [self.firstMessageFetchedStatus removeFromSuperview];
                         self.firstMessageFetchedStatus = nil;
                         self.firstMessageFetchStatusLabel = nil;
                         [self.tableView reloadData];
                     }];
}

@end
