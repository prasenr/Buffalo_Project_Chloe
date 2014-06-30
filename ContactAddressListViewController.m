//
//  ContactAddressListViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/16/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ContactAddressListViewController.h"
#import "NSObject+PersonModel.h"
#import "AddressModel.h"
#import "AddressHistoryModel.h"

@interface ContactAddressListViewController ()
@property (nonatomic, strong) PersonModel *person;
@property (nonatomic, strong) UIView *noAccountsView;
@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) UILabel *addressLine1;
@property (nonatomic, strong) UILabel *addressLine2;
@property (nonatomic, strong) UILabel *city;
@property (nonatomic, strong) UILabel *state;
@property (nonatomic, strong) UILabel *zipCode;
@end

@implementation ContactAddressListViewController

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
    
    if([person.addresses count]>0) {
        [self.noAccountsView removeFromSuperview];
        [self.listTableView reloadData];
    } else {
        [self.view addSubview:self.noAccountsView];
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    AddressHistoryModel *aAddressHistory = [self.person.addresses objectAtIndex:indexPath.row];
    AddressModel *aAddress = aAddressHistory.account;
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        self.addressLine1 = [[UILabel alloc] init];
        self.addressLine2 = [[UILabel alloc] init];
        self.city = [[UILabel alloc] init];
        self.state = [[UILabel alloc] init];
        self.zipCode = [[UILabel alloc] init];
        [cell.contentView addSubview:self.addressLine1];
        [cell.contentView addSubview:self.addressLine2];
        [cell.contentView addSubview:self.city];
        [cell.contentView addSubview:self.state];
        [cell.contentView addSubview:self.zipCode];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

    AddressModel *cellData = aAddress;
    
    int totalHeight = 0;
    
    if([aAddress.addressLine1 length]>0) {
        UILabel *addressLine1Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        addressLine1Label.text = cellData.addressLine1;
        addressLine1Label.font = [UIFont fontWithName:@"Colaborate" size:12];
        addressLine1Label.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [aAddress.addressLine1 boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:addressLine1Label.font} context:nil];
        CGRect newFrame = addressLine1Label.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        addressLine1Label.frame = newFrame;
        totalHeight = totalHeight + addressLine1Label.frame.size.height;
        [cell.contentView addSubview:addressLine1Label];
    }
    
    if([aAddress.addressLine2 length]>0) {
        UILabel *addressLine2Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        addressLine2Label.text = cellData.addressLine2;
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
        [cell.contentView addSubview:addressLine2Label];
    }
    
    int currentWidth = 0;
    
    if([aAddress.city length]>0) {
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        cityLabel.text = cellData.city;
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
        [cell.contentView addSubview:cityLabel];
    }
    
    if([aAddress.state length]>0) {
        NSMutableString *stateString = [[NSMutableString alloc] init];
        if([aAddress.city length]>0) {
            [stateString appendString:@", "];
        }
        
        [stateString appendString:cellData.state];
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        stateLabel.text = stateString;
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
        [cell.contentView addSubview:stateLabel];
    }
    
    if([aAddress.zipcode length]>0) {
        UILabel *zipCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        zipCodeLabel.text = cellData.zipcode;
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
        [cell.contentView addSubview:zipCodeLabel];
    }

    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.person.addresses count];
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
    headerLabel.text = @"Addresses";
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
    AddressModel *address = [self.person.addresses objectAtIndex:indexPath.row];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:address forKey:@"address"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAddressEditor" object:nil userInfo:userInfo];
            
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
    [addAccountButton setTitle:@"  add address" forState:UIControlStateNormal];
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
    
    
    
    if([self.person.addresses count]>0) {
        [self.noAccountsView removeFromSuperview];
    } else {
        [self.view addSubview:self.noAccountsView];
    }
}



-(IBAction)addAccountClicked:(id)sender {
    AddressHistoryModel *contactAddress = [[AddressHistoryModel alloc] init];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:contactAddress forKey:@"Address"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactAddressEditor" object:nil userInfo:userInfo];
}

-(IBAction)onCancelClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelContactAddressesList" object:nil];
}

-(void) addAddress:(AddressHistoryModel *)address {
    [self.person.addresses addObject:address];
    [self.listTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
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
