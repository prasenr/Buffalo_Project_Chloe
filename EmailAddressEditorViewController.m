//
//  EmailAddressEditorViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/26/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "EmailAddressEditorViewController.h"
#import "EmailAddressHistoryModel.h"
#import "EmailAddressModel.h"

@interface EmailAddressEditorViewController ()
@property (nonatomic, strong) EmailAddressHistoryModel *account;
@property (nonatomic, strong) UITextField *accountInput;
@end

@implementation EmailAddressEditorViewController

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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:header];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.view.bounds.size.width, 50)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:22];;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.text = @"Add Email Account";
    [header addSubview:headerLabel];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 5, 50, 50)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelCloseButtonDark.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancelButton];
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 50)];
    background.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:background];
    
    self.accountInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, self.view.bounds.size.width - 20, 30)];
    self.accountInput.delegate = self;
    self.accountInput.placeholder = @"email address";
    self.accountInput.keyboardType = UIKeyboardTypeDefault;
    self.accountInput.returnKeyType = UIReturnKeyDone;
    self.accountInput.font = [UIFont fontWithName:@"Colaborate-Thin" size:18];
    self.accountInput.textColor = [UIColor blackColor];
    self.accountInput.backgroundColor = [UIColor whiteColor];
    self.accountInput.autocapitalizationType = UITextAutocorrectionTypeNo;
    self.accountInput.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:self.accountInput];
    
    [self.accountInput becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([self.accountInput.text length] > 0) {
        EmailAddressHistoryModel *emailAddressHistory = [[EmailAddressHistoryModel alloc] init];
        EmailAddressModel *emailAccount = [[EmailAddressModel alloc] init];
        emailAccount.emailAddress = [NSMutableString stringWithString:self.accountInput.text];
        emailAddressHistory.account = emailAccount;
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:emailAddressHistory forKey:@"emailAddress"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addEmailAddress" object:nil userInfo:userInfo];
    }
    return YES;
}

-(IBAction)onCancelClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelEmailAddressEditor" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end