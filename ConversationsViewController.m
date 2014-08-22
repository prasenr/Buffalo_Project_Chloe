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
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UILabel *fromLabel;
@property (nonatomic, strong)UIImage *fromPicture;
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
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        self.fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, self.view.bounds.size.width-80, 50)];
        self.fromLabel.textColor = [UIColor blackColor];
        [self.fromLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18]];
        
        self.subject = [[UILabel alloc] initWithFrame:CGRectMake(70, 27, self.view.bounds.size.width-80, 50)];
        self.subject.textColor = [UIColor blackColor];
        [self.subject setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16]];
        
        self.message = [[UILabel alloc] initWithFrame:CGRectMake(70, 65, self.view.bounds.size.width-80, 50)];
        self.message.textColor = [UIColor blackColor];
        self.message.adjustsFontSizeToFitWidth = NO;
        self.message.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.message setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        self.message.numberOfLines = 3;
        
        [cell.contentView addSubview:self.fromLabel];
        [cell.contentView addSubview:self.subject];
        [cell.contentView addSubview:self.message];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    
    
    ConversationModel *cellConversations = [[TodaySummary_Controller sharedManager].conversations objectAtIndex:indexPath.row];
    YoMessage *lastMessage = [cellConversations.messages objectAtIndex:0];
    NSLog(@"hello subject: %@", lastMessage.subject);
    
    self.fromLabel.text = @"fromEmail@yoho.com";
    
    self.subject.text = lastMessage.subject;
    
    MessageBodyModel *messageBody = lastMessage.plainTextMessage;
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

-(void)reloadConversations {
    [self.tableView reloadData];
}

@end
