//
//  TwitterEditorViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/23/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "TwitterEditorViewController.h"
#import "NSString+URLEncoding.h"

@interface TwitterEditorViewController ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) TwitterAccountHistoryModel *account;
@property (nonatomic, strong) UITextField *accountInput;
@end

@implementation TwitterEditorViewController

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
    
    /*NSMutableString *DST = [[NSMutableString alloc] init];
    [DST appendString:@"OAuth "];
    
    NSString *consumerKey = @"FV93gmcwUhLmbSpoxG5MGO9pB";
    NSString *encodedConsumerKey = [self urlEncodeUsingEncoding:consumerKey];
    NSString *consumerSecret = @"4bv6Dq2UtB7V3CBxGfCUJusLoQiuTTaIfXRU9y3ep3p8uurQl2";
    NSString *encodedConsumerSecret = [self urlEncodeUsingEncoding:consumerSecret];
    
    [DST appendString:[@"oauth_consumer_key" urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    [DST appendString:@"="];
    [DST appendString:@"\""];
    [DST appendString:[@"FV93gmcwUhLmbSpoxG5MGO9pB" urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    [DST appendString:@"\""];     */
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:header];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.view.bounds.size.width, 50)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:22];;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.text = @"Add Twitter Account";
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
    self.accountInput.placeholder = @"twitter account";
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
        TwitterAccountHistoryModel *twitterHistory = [[TwitterAccountHistoryModel alloc] init];
        TwitterAccountModel *twitterAccount = [[TwitterAccountModel alloc] init];
        twitterAccount.username = [NSMutableString stringWithString:self.accountInput.text];
        twitterHistory.account = twitterAccount;
    
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:twitterHistory forKey:@"twitterAccount"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addTwitterAccount" object:nil userInfo:userInfo];
    }
    return YES;
}

-(IBAction)onCancelClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelTwitterEditor" object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
