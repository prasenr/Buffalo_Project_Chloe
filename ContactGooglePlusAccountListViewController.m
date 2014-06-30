//
//  ContactGooglePlusAccountListViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/16/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ContactGooglePlusAccountListViewController.h"
#import "NSObject+PersonModel.h"
#import "GooglePlusAccountModel.h"
#import "GooglePlusAccountHistoryModel.h"

@interface ContactGooglePlusAccountListViewController ()
@property (nonatomic, strong) PersonModel *person;
@property (nonatomic, strong) UIView *noAccountsView;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UILabel *accountLabel;
@end

@implementation ContactGooglePlusAccountListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) person:(PersonModel *)person {
    self.person = person;
    
    if([person.googlePlusAccounts count]>0) {
        [self.noAccountsView removeFromSuperview];
    } else {
        [self.view addSubview:self.noAccountsView];
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    GooglePlusAccountHistoryModel *aAccountHistory = [self.person.googlePlusAccounts objectAtIndex:indexPath.row];
    GooglePlusAccountModel *aAccountModel = aAccountHistory.account;
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        self.accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        
        [cell.contentView addSubview:self.accountLabel];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    self.accountLabel.text = aAccountModel.username;
    self.accountLabel.font = [UIFont fontWithName:@"Colaborate" size:12];
    self.accountLabel.textColor = [UIColor whiteColor];
    
    CGRect relationshipFrame = self.accountLabel.frame;
    relationshipFrame.origin.x = 20;
    relationshipFrame.origin.y = 20;
    
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.person.googlePlusAccounts count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    headerView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    headerLabel.text = @"Google+ Accounts";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.numberOfLines = 0;
    headerLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:21];
    
    CGSize maxiToDoMeetingSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
    CGRect expectedLabelSize1 = [headerLabel.text boundingRectWithSize:maxiToDoMeetingSummaryLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:headerLabel.font} context:nil];
    
    
    CGRect newFrame = headerLabel.frame;
    newFrame.size.height = expectedLabelSize1.size.height;
    newFrame.origin.y = (headerView.bounds.size.height/2) - (newFrame.size.height/2);
    headerLabel.frame = newFrame;
    [headerView addSubview:headerLabel];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 5, 50, 50)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelCloseButton.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelButton];
    
    return headerView;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GooglePlusAccountModel *contactGooglePlusAccount = [self.person.googlePlusAccounts objectAtIndex:indexPath.row];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:contactGooglePlusAccount forKey:@"address"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactGooglePlusEditor" object:nil userInfo:userInfo];
    
}

-(void) createNoAccountsView {
    
    self.noAccountsView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.noAccountsView.backgroundColor = [UIColor blackColor];
    
    UILabel *noAccountSummaryLabel = [[UILabel alloc] init];
    noAccountSummaryLabel.backgroundColor = [UIColor clearColor];
    noAccountSummaryLabel.textColor = [UIColor whiteColor];
    noAccountSummaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    noAccountSummaryLabel.numberOfLines = 0;
    noAccountSummaryLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:18];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:1.5f];
    
    NSAttributedString *noAccountString = [[NSAttributedString alloc] initWithString:@"Trust fund skateboard PBR&B kale chips photo booth cliche. Meggings Brooklyn gentrify, single-origin coffee YOLO." attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Colaborate-Thin" size:18],NSForegroundColorAttributeName :[UIColor whiteColor], NSParagraphStyleAttributeName:style}];
    noAccountSummaryLabel.attributedText = noAccountString;
    
    
    CGSize maxiToDoMeetingSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    CGRect expectedLabelSize1 = [noAccountSummaryLabel.text boundingRectWithSize:maxiToDoMeetingSummaryLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Colaborate-Thin" size:18],NSForegroundColorAttributeName :[UIColor whiteColor], NSParagraphStyleAttributeName:style} context:nil];
    
    
    CGRect newFrame = noAccountSummaryLabel.frame;
    newFrame.size.height = expectedLabelSize1.size.height;
    newFrame.size.width = expectedLabelSize1.size.width;
    newFrame.origin.x = 20;
    newFrame.origin.y = (self.view.bounds.size.height/2) - (newFrame.size.height/2);
    noAccountSummaryLabel.frame = newFrame;
    [self.noAccountsView addSubview:noAccountSummaryLabel];
    
    UIButton *addAccountButton = [[UIButton alloc] init];
    [addAccountButton setImage:[UIImage imageNamed:@"plusWhite.png"] forState:UIControlStateNormal];
    [addAccountButton setTitle:@"  add google+ account" forState:UIControlStateNormal];
    addAccountButton.titleLabel.font = [UIFont fontWithName:@"Didot" size:18];
    [addAccountButton sizeToFit];
    [addAccountButton addTarget:self action:@selector(addAccountClicked:) forControlEvents:UIControlEventTouchUpInside];
    CGRect buttonFrame = addAccountButton.frame;
    
    buttonFrame.origin.x = (self.view.bounds.size.width/2) - (addAccountButton.frame.size.width/2);
    buttonFrame.origin.y = noAccountSummaryLabel.frame.size.height + noAccountSummaryLabel.frame.origin.y + 20;
    addAccountButton.frame = buttonFrame;
    [self.noAccountsView addSubview:addAccountButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 5, 50, 50)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelCloseButton.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.noAccountsView addSubview:cancelButton];
    
    
    
    if([self.person.googlePlusAccounts count]>0) {
        [self.noAccountsView removeFromSuperview];
    } else {
        [self.view addSubview:self.noAccountsView];
    }
}

-(IBAction)addAccountClicked:(id)sender {
    GooglePlusAccountHistoryModel *contactGooglePlusAccount = [[GooglePlusAccountHistoryModel alloc] init];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:contactGooglePlusAccount forKey:@"googlePlusAccount"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactGooglePlusEditor" object:nil userInfo:userInfo];
}

-(IBAction)onCancelClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelContactGooglePlusAccountsList" object:nil];
}

-(void) addGooglePlusAccount:(GooglePlusAccountHistoryModel *)googlePlusAccount {
    
    [self.person.googlePlusAccounts addObject:googlePlusAccount];
    [self.listTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 60)];
    self.listTableView.delegate = self;
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.showsVerticalScrollIndicator = NO;
    self.listTableView.frame = self.view.bounds;
    [self.view addSubview:self.listTableView];
    
    UIView *bottomContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60, self.view.bounds.size.width, 60)];
    bottomContainer.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomContainer];
    
    UIButton *addAddressButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2) - 9, 30 - 9, 18, 18)];
    [addAddressButton setBackgroundImage:[UIImage imageNamed:@"plusWhite.png"] forState:UIControlStateNormal];
    [addAddressButton addTarget:self action:@selector(addAccountClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomContainer addSubview:addAddressButton];
    
    [self createNoAccountsView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
