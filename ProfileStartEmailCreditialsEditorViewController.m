//
//  ProfileStartEmailCreditialsEditorViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 7/19/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ProfileStartEmailCreditialsEditorViewController.h"

@interface ProfileStartEmailCreditialsEditorViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *header;

@property (nonatomic, strong) UITextField *nameInput;
@property (nonatomic, strong) UITextField *emailInput;
@property (nonatomic, strong) UITextField *passwordInput;
@property (nonatomic, strong) UITextField *descriptionInput;
@end

@implementation ProfileStartEmailCreditialsEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addEmailAccount:(EmailAddressHistoryModel *)emailAccount {
    self.emailAccount = emailAccount;
    
    NSArray *emailSplit = [self.emailAccount.account.emailAddress componentsSeparatedByString:@"@"];
    NSString *emaiType = emailSplit[1];
    emailSplit = nil;
    
    if([emaiType  isEqual: @"@gmail.com"]) {
        [self createGmailAccountScreen];
    } else if([emaiType isEqual:@"@aol.com"]) {
        [self createAOLAccountScreen];
    } else if([emaiType isEqual:@"@hotmail.com"]) {
        [self createHotmailAccountScreen];
    } else if([emaiType isEqual:@"@yahoo.com"]) {
        [self createYahooAccountScreen];
    } else {
        [self createUnkownEmailScreen];
    }
    
    emaiType = nil;
}

-(void)addIMAccount:(InstantMessengerAccountHistoryModel *)instantMessengerAccount{
    self.instantMessengerAccount = instantMessengerAccount;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    CGRect labelFrame1 = CGRectMake(25, 80, self.view.frame.size.width - 25, 18);
    UILabel *justSoYouKnowLabel = [[UILabel alloc] initWithFrame:labelFrame1];
    [justSoYouKnowLabel setFont:[UIFont fontWithName:@"Didot" size:30]];
    if(self.emailAccount!=nil) {
        [justSoYouKnowLabel setText:@"Email Account!"];
    } else {
        [justSoYouKnowLabel setText:@"Instant Messenger Account"];
    }
    
    [justSoYouKnowLabel setTextColor:[UIColor whiteColor]];
    [justSoYouKnowLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:justSoYouKnowLabel];
    
    CGSize maxiToDoMeetingSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    CGRect expectedLabelSize = [justSoYouKnowLabel.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:justSoYouKnowLabel.font} context:nil ];
    
    CGRect newFrame = justSoYouKnowLabel.frame;
    newFrame.size.height = expectedLabelSize.size.height;
    newFrame.size.width = expectedLabelSize.size.width;
    newFrame.origin.x = 20;
    newFrame.origin.y = 50;
    justSoYouKnowLabel.frame = newFrame;
    
    NSString *welcomeText = @"Magna brunch asymmetrical dolore Kickstarter. Kitsch food truck cardigan Etsy, direct trade PBR viral put a bird on it.";
    
    
    
    
}

-(void)createGmailAccountScreen {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];

    [self createHeader];
    [self createTitle:self.emailAccount.account.emailAddress];
    [self createBody:@"Magna brunch asymmetrical dolore Kickstarter. Kitsch food truck cardigan Etsy, direct trade PBR viral put a bird on it."];
    
    
    [self createSaveSkipButtons];
}

-(void)createAOLAccountScreen {
    
    [self createSaveSkipButtons];
}

-(void)createHotmailAccountScreen {
    
    [self createSaveSkipButtons];
}

-(void)createYahooAccountScreen {
    
    [self createSaveSkipButtons];
}

-(void)createUnkownEmailScreen {
    
    [self createSaveSkipButtons];
}

-(void)createSaveSkipButtons {
    self.saveButton = [[UIButton alloc] init];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setBackgroundColor:[UIColor colorWithRed:104.0/255.0 green:137.0/255.0 blue:179.0/255.0 alpha:1.0]];
    self.saveButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [self.saveButton sizeToFit];
    [self.saveButton addTarget:self action:@selector(onSubmit:) forControlEvents:UIControlEventTouchUpInside];
    CGRect saveButtonFrame = self.saveButton.frame;
    saveButtonFrame.origin.y = self.view.bounds.size.height - 50;
    saveButtonFrame.origin.x = 0;
    saveButtonFrame.size.width = self.view.bounds.size.width/2;
    saveButtonFrame.size.height = 50;
    self.saveButton.frame = saveButtonFrame;
    [self.view addSubview:self.saveButton];
    
    self.skipButton = [[UIButton alloc] init];
    [self.skipButton setTitle:@"Skip this" forState:UIControlStateNormal];
    self.skipButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [self.skipButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.skipButton setBackgroundColor: [UIColor whiteColor]];
    self.skipButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [self.skipButton addTarget:self action:@selector(onSkip1:) forControlEvents:UIControlEventTouchUpInside];
    CGRect skipButtonFrame = self.skipButton.frame;
    skipButtonFrame.origin.y = saveButtonFrame.origin.y;
    skipButtonFrame.origin.x = self.view.bounds.size.width/2;
    skipButtonFrame.size.width = self.view.bounds.size.width/2;
    skipButtonFrame.size.height = 50;
    self.skipButton.frame = skipButtonFrame;
    [self.view addSubview:self.skipButton];
}

-(void)createHeader {
    self.header = [[UIView alloc] init];
    self.header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.header;
}

-(void)createTitle:(NSString *)title {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 80, self.view.frame.size.width - 25, 18)];
    [self.titleLabel setFont:[UIFont fontWithName:@"Didot" size:30]];
    self.titleLabel.text = title;
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.header addSubview:self.titleLabel];
}

-(void)createBody:(NSString *)body {
    unichar chr[1] = {'\n'};
    NSString *cr = [NSString stringWithCharacters:(const unichar *)chr length:1];
    CGRect bodyFrame = CGRectMake(25, 100, self.view.frame.size.width - 50, 500);
    self.bodyLabel = [[UILabel alloc] initWithFrame:bodyFrame];
    [self.bodyLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [self.bodyLabel setText: [NSString stringWithFormat:body, cr]];
    [self.bodyLabel setTextColor:[UIColor whiteColor]];
    [self.bodyLabel setBackgroundColor:[UIColor clearColor]];
    [self.bodyLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.bodyLabel setNumberOfLines:0];
    
    CGSize maxiBodyLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    CGRect expectedBodyLabelSize = [self.bodyLabel.text boundingRectWithSize:CGSizeMake(maxiBodyLabelSize.width, maxiBodyLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.bodyLabel.font} context:nil ];
    CGRect bodyLabelFrame = self.bodyLabel.frame;
    bodyLabelFrame.origin.x = 10;
    bodyLabelFrame.origin.y = self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y - 5;
    bodyLabelFrame.size.width = expectedBodyLabelSize.size.width;
    bodyLabelFrame.size.height = expectedBodyLabelSize.size.height;
    self.bodyLabel.frame = bodyLabelFrame;
    [self.header addSubview:self.bodyLabel];
}

-(IBAction)onSubmit:(id)sender {
    if(self.emailAccount!=nil) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.emailAccount forKey:@"account"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"emailAccountFixed" object:nil userInfo:userInfo];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.emailAccount forKey:@"account"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"instantMessengerAccountFixed" object:nil userInfo:userInfo];
    }
}

-(IBAction)onSkip1:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"accountSkipped" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
