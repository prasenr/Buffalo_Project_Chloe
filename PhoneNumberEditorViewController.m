//
//  PhoneNumberEditorViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/26/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "PhoneNumberEditorViewController.h"
#import "PhoneNumberHistoryModel.h"
#import "PhoneNumberModel.h"

@interface PhoneNumberEditorViewController ()
@property (nonatomic, strong) PhoneNumberHistoryModel *account;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UIView *confirmationView;
@property (nonatomic, strong) UIView *confirmationLabel;
@property (nonatomic, strong) UIButton *confirmationYesButton;
@property (nonatomic, strong) UIButton *confirmationNoButton;
@property (nonatomic, strong) UITextField *accountInput;
@end

@implementation PhoneNumberEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:header];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.view.bounds.size.width, 50)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:22];;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.text = @"Add Phone Number";
    [header addSubview:headerLabel];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 5, 50, 50)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelCloseButtonDark.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancelButton];
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 50)];
    background.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:background];
    
    self.inputView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.inputView];
    
    self.accountInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, self.view.bounds.size.width - 20, 30)];
    self.accountInput.delegate = self;
    self.accountInput.placeholder = @"phone number";
    self.accountInput.keyboardType = UIKeyboardTypeDefault;
    self.accountInput.returnKeyType = UIReturnKeyDone;
    self.accountInput.font = [UIFont fontWithName:@"Colaborate-Thin" size:18];
    self.accountInput.textColor = [UIColor blackColor];
    self.accountInput.backgroundColor = [UIColor whiteColor];
    self.accountInput.autocapitalizationType = UITextAutocorrectionTypeNo;
    self.accountInput.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.inputView addSubview:self.accountInput];
    
    [self.accountInput becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([self.accountInput.text length] > 0) {
        if(!self.confirmationView) {
            self.confirmationView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            [self.view addSubview:self.confirmationView];
            
            self.confirmationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, self.view.bounds.size.width - 40, 50)];
            [self.confirmationView addSubview:self.confirmationLabel];
            
            self.confirmationYesButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
            [self.confirmationYesButton setBackgroundImage:[UIImage imageNamed:@"yesButton"] forState:UIControlStateNormal];
            [self.confirmationYesButton addTarget:self action:@selector(onConfirmationYesClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.confirmationView addSubview:self.confirmationYesButton];
            
            
            self.confirmationNoButton = [[UIButton alloc] initWithFrame:CGRectMake(175, 100, 100, 100)];
            [self.confirmationNoButton setBackgroundImage:[UIImage imageNamed:@"noButton"] forState:UIControlStateNormal];
            [self.confirmationNoButton addTarget:self action:@selector(onConfirmationNoClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.confirmationView addSubview:self.confirmationNoButton];
        }
        
        CGRect inputTo = CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        CGRect confirmationTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        
        [UIView animateWithDuration:0.25
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.inputView.frame = inputTo;
                             self.confirmationView.frame = confirmationTo;
                         }completion:^(BOOL finished){}];
    }
    return YES;
}

-(IBAction)onConfirmationYesClick:(id)sender {
    
    PhoneNumberHistoryModel *phoneNumberHistory = [[PhoneNumberHistoryModel alloc] init];
    PhoneNumberModel *phoneNumber = [[PhoneNumberModel alloc] init];
    phoneNumber.phoneNumber = [NSMutableString stringWithString:self.accountInput.text];
    phoneNumberHistory.account = phoneNumber;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:phoneNumberHistory forKey:@"phoneNumber"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addPhoneNumber" object:nil userInfo:userInfo];
}

-(IBAction)onConfirmationNoClick:(id)sender {
    CGRect inputTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect confirmationTo = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.inputView.frame = inputTo;
                         self.confirmationView.frame = confirmationTo;
                     }completion:^(BOOL finished){
                     self.accountInput.text = @"";
                     }];
}

-(IBAction)onCancelClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelPhoneNumberEditor" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
