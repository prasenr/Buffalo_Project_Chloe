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
    
    if([emaiType  isEqual: @"gmail.com"]) {
        [self createGmailAccountScreen];
    } else if([emaiType isEqual:@"aol.com"]) {
        [self createAOLAccountScreen];
    } else if([emaiType isEqual:@"hotmail.com"]) {
        [self createHotmailAccountScreen];
    } else if([emaiType isEqual:@"yahoo.com"]) {
        [self createYahooAccountScreen];
    } else {
        [self createUnkownEmailScreen];
    }
    
    emaiType = nil;
}

-(void)addIMAccount:(InstantMessengerAccountHistoryModel *)instantMessengerAccount{
    self.instantMessengerAccount = instantMessengerAccount;
    
    [self createSaveSkipButtons];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

}

-(void)createGmailAccountScreen {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];

    [self createHeader];
    [self createTitle:self.emailAccount.account.emailAddress];
    [self createBody:@"Magna brunch asymmetrical dolore Kickstarter. Kitsch food truck cardigan Etsy, direct trade PBR viral put a bird on it."];
    [self createNameLabel];
    [self createEmailLabel];
    [self createPasswordLabel];
    [self createDescriptionLabel];
    
    [self createSaveSkipButtons];
    
    self.header.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.descriptionInput.frame.origin.y + self.descriptionInput.frame.size.height + 20);
}

-(void)createAOLAccountScreen {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self createHeader];
    [self createTitle:self.emailAccount.account.emailAddress];
    [self createBody:@"Magna brunch asymmetrical dolore Kickstarter. Kitsch food truck cardigan Etsy, direct trade PBR viral put a bird on it."];
    [self createNameLabel];
    [self createEmailLabel];
    [self createPasswordLabel];
    [self createDescriptionLabel];
    
    [self createSaveSkipButtons];
    
    self.header.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.descriptionInput.frame.origin.y + self.descriptionInput.frame.size.height + 20);
}

-(void)createHotmailAccountScreen {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self createHeader];
    [self createTitle:self.emailAccount.account.emailAddress];
    [self createBody:@"Magna brunch asymmetrical dolore Kickstarter. Kitsch food truck cardigan Etsy, direct trade PBR viral put a bird on it."];
    [self createNameLabel];
    [self createEmailLabel];
    [self createPasswordLabel];
    [self createDescriptionLabel];
    
    [self createSaveSkipButtons];
    
    self.header.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.descriptionInput.frame.origin.y + self.descriptionInput.frame.size.height + 20);
}

-(void)createYahooAccountScreen {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self createHeader];
    [self createTitle:self.emailAccount.account.emailAddress];
    [self createBody:@"Magna brunch asymmetrical dolore Kickstarter. Kitsch food truck cardigan Etsy, direct trade PBR viral put a bird on it."];
    [self createNameLabel];
    [self createEmailLabel];
    [self createPasswordLabel];
    [self createDescriptionLabel];
    
    [self createSaveSkipButtons];
    
    self.header.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.descriptionInput.frame.origin.y + self.descriptionInput.frame.size.height + 20);
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
    self.header = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.header;
}

-(void)createTitle:(NSString *)title {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 25, 18)];
    [self.titleLabel setFont:[UIFont fontWithName:@"Didot" size:20]];
    self.titleLabel.text = title;
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.header addSubview:self.titleLabel];
}

-(void)createBody:(NSString *)body {
    unichar chr[1] = {'\n'};
    NSString *cr = [NSString stringWithCharacters:(const unichar *)chr length:1];
    CGRect bodyFrame = CGRectMake(20, 100, self.view.frame.size.width - 50, 500);
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
    bodyLabelFrame.origin.x = 20;
    bodyLabelFrame.origin.y = self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y - 0;
    bodyLabelFrame.size.width = expectedBodyLabelSize.size.width;
    bodyLabelFrame.size.height = expectedBodyLabelSize.size.height;
    self.bodyLabel.frame = bodyLabelFrame;
    [self.header addSubview:self.bodyLabel];
}

-(void)createNameLabel {
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, self.bodyLabel.frame.origin.y + self.bodyLabel.frame.size.height +10, self.view.bounds.size.width - 40, 30)];
    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [labelTitle setText: @"Name"];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [self.header addSubview:labelTitle];
    
    self.nameInput = [[UITextField alloc] initWithFrame:CGRectMake(20, labelTitle.frame.origin.y + labelTitle.frame.size.height, self.view.bounds.size.width-40, 50)];
    self.nameInput.text = self.emailAccount.account.emailAddress;
    self.nameInput.tag = 99;
    self.nameInput.delegate  = self;
    self.nameInput.keyboardType = UIKeyboardTypeDefault;
    self.nameInput.returnKeyType = UIReturnKeyDone;
    self.nameInput.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.nameInput.textColor = [UIColor blackColor];
    self.nameInput.backgroundColor = [UIColor whiteColor];
    self.nameInput.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.nameInput.autocorrectionType = UITextAutocorrectionTypeYes;
    [self.header addSubview:self.nameInput];
}

-(void)createEmailLabel {
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, self.nameInput.frame.origin.y + self.nameInput.frame.size.height +10, self.view.bounds.size.width - 20, 30)];
    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [labelTitle setText: @"Email"];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [self.header addSubview:labelTitle];
    
    self.emailInput = [[UITextField alloc] initWithFrame:CGRectMake(20, labelTitle.frame.origin.y + labelTitle.frame.size.height, self.view.bounds.size.width-40, 50)];
    self.emailInput.text = self.emailAccount.account.emailAddress;
    self.emailInput.tag = 100;
    self.emailInput.delegate = self;
    self.emailInput.keyboardType = UIKeyboardTypeDefault;
    self.emailInput.returnKeyType = UIReturnKeyDone;
    self.emailInput.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.emailInput.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    self.emailInput.backgroundColor = [UIColor whiteColor];
    self.emailInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailInput.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailInput.enabled = false;
    [self.header addSubview:self.emailInput];
}

-(void)createPasswordLabel {
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, self.emailInput.frame.origin.y + self.emailInput.frame.size.height +10, self.view.bounds.size.width - 20, 30)];
    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [labelTitle setText: @"Password"];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [self.header addSubview:labelTitle];
    
    self.passwordInput = [[UITextField alloc] initWithFrame:CGRectMake(20, labelTitle.frame.origin.y + labelTitle.frame.size.height, self.view.bounds.size.width-40, 50)];
    self.passwordInput.placeholder = @"your password";
    self.passwordInput.tag = 101;
    self.passwordInput.delegate = self;
    self.passwordInput.keyboardType = UIKeyboardTypeDefault;
    self.passwordInput.returnKeyType = UIReturnKeyDone;
    self.passwordInput.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.passwordInput.textColor = [UIColor blackColor];
    self.passwordInput.backgroundColor = [UIColor whiteColor];
    self.passwordInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordInput.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordInput.secureTextEntry = YES;
    [self.header addSubview:self.passwordInput];
}

-(void)createDescriptionLabel {
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, self.passwordInput.frame.origin.y + self.passwordInput.frame.size.height +10, self.view.bounds.size.width - 20, 30)];
    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [labelTitle setText: @"Description"];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [self.header addSubview:labelTitle];
    
    self.descriptionInput = [[UITextField alloc] initWithFrame:CGRectMake(20, labelTitle.frame.origin.y + labelTitle.frame.size.height, self.view.bounds.size.width-40, 50)];
    self.descriptionInput.placeholder = @"Description";
    self.descriptionInput.tag = 100;
    self.descriptionInput.delegate = self;
    self.descriptionInput.keyboardType = UIKeyboardTypeDefault;
    self.descriptionInput.returnKeyType = UIReturnKeyDone;
    self.descriptionInput.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.descriptionInput.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    self.descriptionInput.backgroundColor = [UIColor whiteColor];
    self.descriptionInput.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.descriptionInput.autocorrectionType = UITextAutocorrectionTypeYes;
    [self.header addSubview:self.descriptionInput];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.nameInput resignFirstResponder];
    [self.emailInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
    [self.descriptionInput resignFirstResponder];
    
    return YES;
}

@end
