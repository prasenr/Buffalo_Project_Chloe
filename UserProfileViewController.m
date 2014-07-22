//
//  UserProfileViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 7/10/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "UserProfileViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "AddressModel.h"
#import "AddressHistoryModel.h"
#import "PhoneNumberModel.h"
#import "PhoneNumberHistoryModel.h"
#import "ContactAddressSearchViewController.h"
#import "WhoAreYouContactListViewController.h"

@interface UserProfileViewController ()
@property (nonatomic, strong) UIView *profileWizardContainer;
@property (nonatomic, strong) UIView *profileContainer;
@property (nonatomic, strong) UIView *welcomeContainer;
@property (nonatomic, strong) UIView *createUserPassword;
@property (nonatomic, strong) UITextField *usernameInput;
@property (nonatomic, strong) UITextField *passwordInput;
@property (nonatomic, strong) UIView *accessContacts;
@property (nonatomic, strong) WhoAreYouContactListViewController *whoAreYou;
@property (nonatomic, strong) UIView *pickAPicture;
@property (nonatomic, strong) UIView *confirmPicture;
@property (nonatomic, strong) UIImageView *profilePicture;
@property (nonatomic, assign) int *currentMissingInformationScreen;
@property (nonatomic, strong) NSMutableArray *missingInformationScreensArray;
@property (nonatomic, strong) UIView *missingInformationWelcome;
@property (nonatomic, strong) UserProfileModel *profile;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UIView *tableParentContainer;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UILabel *profileSectionLabel;
@property (nonatomic, strong) UIImageView *profileSectionIcon;
@property (nonatomic, strong) UserProfileModel *userProfileModel;
@property (nonatomic, strong) NSMutableArray *nameLabelArray;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *nameContent;
@property (nonatomic, strong) UIView *addressContent;
@property (nonatomic, strong) UIView *buttonContent;
@property (nonatomic, strong) UIImageView *loaderImage;
@property (nonatomic, strong) ContactAddressSearchViewController *addressSearchResults;
@end

static NSDateFormatter *dateFormatter = nil;
@implementation UserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProfileSelected:) name:@"profileSelected" object:nil];
    }
    return self;
}

-(void)addProfile:(UserProfileModel *)userProfile{
    self.userProfileModel = userProfile;
}


-(void)createNewProfile {
    self.userProfileModel = [[UserProfileModel alloc] init];
    
    self.profileContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.profileContainer];
    [self.profileContainer setBackgroundColor:[UIColor blackColor]];
    
    self.welcomeContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    self.welcomeContainer.backgroundColor = [UIColor whiteColor];
    [self.profileContainer addSubview:self.welcomeContainer];
    
    
    NSString *welcomeTitleText = @"Hello";
    
    CGRect labelFrame1 = CGRectMake(25, 80, self.view.frame.size.width - 25, 18);
    UILabel *justSoYouKnowLabel = [[UILabel alloc] initWithFrame:labelFrame1];
    [justSoYouKnowLabel setFont:[UIFont fontWithName:@"Didot" size:45]];
    [justSoYouKnowLabel setText:welcomeTitleText];
    [justSoYouKnowLabel setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
    [justSoYouKnowLabel setBackgroundColor:[UIColor clearColor]];
    [self.welcomeContainer addSubview:justSoYouKnowLabel];
    
    CGSize maxiToDoMeetingSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    CGRect expectedLabelSize = [justSoYouKnowLabel.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:justSoYouKnowLabel.font} context:nil ];
    
    CGRect newFrame = justSoYouKnowLabel.frame;
    newFrame.size.height = expectedLabelSize.size.height;
    newFrame.size.width = expectedLabelSize.size.width;
    newFrame.origin.x = 20;
    newFrame.origin.y = 250;
    justSoYouKnowLabel.frame = newFrame;
    
    NSString *welcomeText = @"Magna brunch asymmetrical dolore Kickstarter. Kitsch food truck cardigan Etsy, direct trade PBR viral put a bird on it. Minim ad direct trade est nostrud, keytar duis. Adipisicing Carles Blue Bottle, distillery Etsy lo-fi messenger bag selvage meggings magna sint skateboard.";
    unichar chr[1] = {'\n'};
    NSString *cr = [NSString stringWithCharacters:(const unichar *)chr length:1];
    CGRect labelFrame = CGRectMake(25, 100, self.view.frame.size.width - 50, 500);
    UILabel *justSoYouKnowDetails = [[UILabel alloc] initWithFrame:labelFrame];
    [justSoYouKnowDetails setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [justSoYouKnowDetails setText: [NSString stringWithFormat:welcomeText, cr]];
    [justSoYouKnowDetails setTextColor:[UIColor colorWithRed:110.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0]];
    [justSoYouKnowDetails setBackgroundColor:[UIColor clearColor]];
    [justSoYouKnowDetails setLineBreakMode:NSLineBreakByWordWrapping];
    [justSoYouKnowDetails setNumberOfLines:0];
    
    CGRect expectedLabelSize1 = [justSoYouKnowDetails.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:justSoYouKnowDetails.font} context:nil ];
    CGRect newFrame1 = justSoYouKnowDetails.frame;
    newFrame1.origin.x = 20;
    newFrame1.origin.y = (justSoYouKnowLabel.frame.size.height + justSoYouKnowLabel.frame.origin.y) - 5;
    newFrame1.size.width = expectedLabelSize1.size.width;
    newFrame1.size.height = expectedLabelSize1.size.height;
    justSoYouKnowDetails.frame = newFrame1;
    [self.welcomeContainer addSubview:justSoYouKnowDetails];
    
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
    loginButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [loginButton sizeToFit];
    [loginButton addTarget:self action:@selector(onLoginTouch:) forControlEvents:UIControlEventTouchUpInside];
    CGRect loginFrame = loginButton.frame;
    loginFrame.origin.y = self.view.bounds.size.height - 50;
    loginFrame.origin.x = self.view.bounds.size.width/2;
    loginFrame.size.width = self.view.bounds.size.width/2;
    loginFrame.size.height = 50;
    loginButton.frame = loginFrame;
    
    [self.welcomeContainer addSubview:loginButton];
    
    UIButton *createNewProfileButton = [[UIButton alloc] init];
    [createNewProfileButton setTitle:@"Create Profile" forState:UIControlStateNormal];
    createNewProfileButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    createNewProfileButton.titleLabel.textColor = [UIColor whiteColor];
    createNewProfileButton.backgroundColor = [UIColor colorWithRed:104.0/255.0 green:137.0/255.0 blue:179.0/255.0 alpha:1.0];
    createNewProfileButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [createNewProfileButton sizeToFit];
    [createNewProfileButton addTarget:self action:@selector(onCreateNewProfileTouch:) forControlEvents:UIControlEventTouchUpInside];
    CGRect newButtonFrame = createNewProfileButton.frame;
    newButtonFrame.origin.y = loginButton.frame.origin.y;
    newButtonFrame.origin.x = 0;
    newButtonFrame.size.width = self.view.bounds.size.width/2;
    newButtonFrame.size.height = 50;
    createNewProfileButton.frame = newButtonFrame;
    
    [self.welcomeContainer addSubview:createNewProfileButton];
}

-(IBAction)onLoginTouch:(id)sender {
    
}

-(IBAction)onCreateNewProfileTouch:(id)sender {
    
    self.createUserPassword = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];

    [self.profileContainer addSubview:self.createUserPassword];
    CGRect labelFrame1 = CGRectMake(25, 80, self.view.frame.size.width - 25, 18);
    UILabel *justSoYouKnowLabel = [[UILabel alloc] initWithFrame:labelFrame1];
    [justSoYouKnowLabel setFont:[UIFont fontWithName:@"Didot" size:30]];
    [justSoYouKnowLabel setText:@"Creditials"];
    [justSoYouKnowLabel setTextColor:[UIColor whiteColor]];
    [justSoYouKnowLabel setBackgroundColor:[UIColor clearColor]];
    [self.createUserPassword addSubview:justSoYouKnowLabel];
    
    CGSize maxiToDoMeetingSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    CGRect expectedLabelSize = [justSoYouKnowLabel.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:justSoYouKnowLabel.font} context:nil ];
    
    CGRect newFrame = justSoYouKnowLabel.frame;
    newFrame.size.height = expectedLabelSize.size.height;
    newFrame.size.width = expectedLabelSize.size.width;
    newFrame.origin.x = 20;
    newFrame.origin.y = 20;
    justSoYouKnowLabel.frame = newFrame;
    
    NSString *welcomeText = @"Magna brunch asymmetrical dolore Kickstarter. Kitsch food truck cardigan Etsy, direct trade PBR viral put a bird on it.";
    unichar chr[1] = {'\n'};
    NSString *cr = [NSString stringWithCharacters:(const unichar *)chr length:1];
    CGRect labelFrame = CGRectMake(25, 100, self.view.frame.size.width - 50, 500);
    UILabel *justSoYouKnowDetails = [[UILabel alloc] initWithFrame:labelFrame];
    [justSoYouKnowDetails setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [justSoYouKnowDetails setText: [NSString stringWithFormat:welcomeText, cr]];
    [justSoYouKnowDetails setTextColor:[UIColor whiteColor]];
    [justSoYouKnowDetails setBackgroundColor:[UIColor clearColor]];
    [justSoYouKnowDetails setLineBreakMode:NSLineBreakByWordWrapping];
    [justSoYouKnowDetails setNumberOfLines:0];
    
    CGRect expectedLabelSize1 = [justSoYouKnowDetails.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:justSoYouKnowDetails.font} context:nil ];
    CGRect newFrame1 = justSoYouKnowDetails.frame;
    newFrame1.origin.x = 20;
    newFrame1.origin.y = justSoYouKnowLabel.frame.size.height + justSoYouKnowLabel.frame.origin.y - 5;
    newFrame1.size.width = expectedLabelSize1.size.width;
    newFrame1.size.height = expectedLabelSize1.size.height;
    justSoYouKnowDetails.frame = newFrame1;
    [self.createUserPassword addSubview:justSoYouKnowDetails];
    
    UILabel *usernameTitle = [[UILabel alloc] initWithFrame:self.view.bounds];
    [usernameTitle setFont: [UIFont fontWithName:@"HelveticaNeue" size:16]];
    [usernameTitle setText:@"Username"];
    [usernameTitle setTextColor:[UIColor whiteColor]];
    [usernameTitle setBackgroundColor:[UIColor clearColor]];
    [self.createUserPassword addSubview:usernameTitle];
    
    CGRect expectedLabelSize2 = [usernameTitle.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:usernameTitle.font} context:nil ];
    CGRect usernameTitleFrame = usernameTitle.frame;
    usernameTitleFrame.origin.x = 20;
    usernameTitleFrame.origin.y = justSoYouKnowDetails.frame.origin.y + justSoYouKnowDetails.frame.size.height + 30;
    usernameTitleFrame.size = expectedLabelSize2.size;
    usernameTitle.frame = usernameTitleFrame;
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    self.usernameInput = [[UITextField alloc] initWithFrame:CGRectMake(20, usernameTitleFrame.origin.y + usernameTitleFrame.size.height + 2, self.view.bounds.size.width - 40, 50)];
    self.usernameInput.tag = 100;
    self.usernameInput.delegate = self;
    self.usernameInput.placeholder = @"your username";
    self.usernameInput.keyboardType = UIKeyboardTypeDefault;
    self.usernameInput.returnKeyType = UIReturnKeyNext;
    self.usernameInput.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.usernameInput.textColor = [UIColor blackColor];
    self.usernameInput.backgroundColor = [UIColor whiteColor];
    self.usernameInput.autocapitalizationType = UITextAutocorrectionTypeNo;
    self.usernameInput.autocorrectionType = UITextAutocorrectionTypeNo;
   // [self.usernameInput setLeftViewMode:UITextFieldViewModeAlways];
    //[self.usernameInput setLeftView:spacerView];
    [self.createUserPassword addSubview:self.usernameInput];
    
    UILabel *passwordTitle = [[UILabel alloc] initWithFrame:self.view.bounds];
    [passwordTitle setFont: [UIFont fontWithName:@"HelveticaNeue" size:16]];
    [passwordTitle setText:@"Password"];
    [passwordTitle setTextColor:[UIColor whiteColor]];
    [usernameTitle setBackgroundColor:[UIColor clearColor]];
    [self.createUserPassword addSubview:passwordTitle];
    
    CGRect expectedLabelSize3 = [passwordTitle.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:passwordTitle.font} context:nil ];
    
    CGRect passwordTitleFrame = passwordTitle.frame;
    passwordTitleFrame.origin.x = 20;
    passwordTitleFrame.origin.y = self.usernameInput.frame.size.height + self.usernameInput.frame.origin.y + 20;
    passwordTitleFrame.size = expectedLabelSize3.size;
    passwordTitle.frame = passwordTitleFrame;
    
    self.passwordInput = [[UITextField alloc] initWithFrame:CGRectMake(20, passwordTitleFrame.origin.y + passwordTitleFrame.size.height + 2, self.view.bounds.size.width - 40, 50)];
    self.passwordInput.placeholder = @"your password";
    self.passwordInput.tag = 101;
    self.passwordInput.delegate = self;
    self.passwordInput.keyboardType = UIKeyboardTypeDefault;
    self.passwordInput.returnKeyType = UIReturnKeyDone;
    self.passwordInput.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.passwordInput.textColor = [UIColor blackColor];
    self.passwordInput.backgroundColor = [UIColor whiteColor];
    self.passwordInput.autocapitalizationType = UITextAutocorrectionTypeNo;
    self.passwordInput.autocorrectionType = UITextAutocorrectionTypeNo;
    //[self.passwordInput setLeftViewMode:UITextFieldViewModeAlways];
    //[self.passwordInput setLeftView:spacerView];
    self.passwordInput.secureTextEntry = YES;
    [self.createUserPassword addSubview:self.passwordInput];
    
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"Create my creditials" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:104.0/255.0 green:137.0/255.0 blue:179.0/255.0 alpha:1.0]];
    loginButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [loginButton sizeToFit];
    [loginButton addTarget:self action:@selector(onCreateCreditalsTouch:) forControlEvents:UIControlEventTouchUpInside];
    CGRect loginFrame = loginButton.frame;
    loginFrame.origin.y =self.passwordInput.frame.origin.y + self.passwordInput.frame.size.height + 30;
    loginFrame.origin.x = 20;
    loginFrame.size.width = self.view.bounds.size.width - 40 ;
    loginFrame.size.height = 50;
    loginButton.frame = loginFrame;

    [self.createUserPassword addSubview:loginButton];
    
    
    CGRect welcomeTo = self.welcomeContainer.frame;
    welcomeTo.origin.x = -self.view.bounds.size.width;
    CGRect userNamePasswordTo = self.createUserPassword.frame;
    userNamePasswordTo.origin.x = 0;
    
    
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.createUserPassword.frame = userNamePasswordTo;
                         self.welcomeContainer.frame = welcomeTo;
                         
                     }completion:^(BOOL finished){
                         NSLog(@"yada");
                     }];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.tag == 100) {
        [self.usernameInput resignFirstResponder];
        [self.passwordInput becomeFirstResponder];
    }
    
    if(textField.tag == 101) {
        [self.passwordInput resignFirstResponder];
    }
    
    return YES;
}

-(IBAction)onCreateCreditalsTouch:(id)sender {
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.usernameInput.text,@"username", self.passwordInput.text, @"password", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"request: %@", jsonString);
    
    
    NSURL *url = [NSURL URLWithString:@"http://api.buffalop.com/profiles/"];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.buffalop.com/profiles/"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:jsonData];
    
    NSURLResponse *response = nil;
    NSError *requestError = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&requestError];
    
    if (requestError == nil) {
        NSString *returnString = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
        NSLog(@"returnString: %@", returnString);
        self.profile =[MTLJSONAdapter modelOfClass: [UserProfileModel class] fromJSONDictionary:json error:nil];// [[UserProfileModel alloc] initWithString:returnString error:nil];
        [self onCredititalsCreated];
    } else {
        NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
    }
}

-(void)onCredititalsCreated {

    
    self.accessContacts = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.profileContainer addSubview:self.accessContacts];
    
    CGRect labelFrame1 = CGRectMake(25, 80, self.view.frame.size.width - 25, 18);
    UILabel *justSoYouKnowLabel = [[UILabel alloc] initWithFrame:labelFrame1];
    [justSoYouKnowLabel setFont:[UIFont fontWithName:@"Didot" size:30]];
    [justSoYouKnowLabel setText:@"Who are you?"];
    [justSoYouKnowLabel setTextColor:[UIColor whiteColor]];
    [justSoYouKnowLabel setBackgroundColor:[UIColor clearColor]];
    [self.accessContacts addSubview:justSoYouKnowLabel];
    
    CGSize maxiToDoMeetingSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    CGRect expectedLabelSize = [justSoYouKnowLabel.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:justSoYouKnowLabel.font} context:nil ];
    
    CGRect newFrame = justSoYouKnowLabel.frame;
    newFrame.size.height = expectedLabelSize.size.height;
    newFrame.size.width = expectedLabelSize.size.width;
    newFrame.origin.x = 20;
    newFrame.origin.y = 50;
    justSoYouKnowLabel.frame = newFrame;
    
    NSString *welcomeText = @"Magna brunch asymmetrical dolore Kickstarter. Kitsch food truck cardigan Etsy, direct trade PBR viral put a bird on it.";
    unichar chr[1] = {'\n'};
    NSString *cr = [NSString stringWithCharacters:(const unichar *)chr length:1];
    CGRect labelFrame = CGRectMake(25, 100, self.view.frame.size.width - 50, 500);
    UILabel *justSoYouKnowDetails = [[UILabel alloc] initWithFrame:labelFrame];
    [justSoYouKnowDetails setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [justSoYouKnowDetails setText: [NSString stringWithFormat:welcomeText, cr]];
    [justSoYouKnowDetails setTextColor:[UIColor whiteColor]];
    [justSoYouKnowDetails setBackgroundColor:[UIColor clearColor]];
    [justSoYouKnowDetails setLineBreakMode:NSLineBreakByWordWrapping];
    [justSoYouKnowDetails setNumberOfLines:0];
    
    CGRect expectedLabelSize1 = [justSoYouKnowDetails.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:justSoYouKnowDetails.font} context:nil ];
    CGRect newFrame1 = justSoYouKnowDetails.frame;
    newFrame1.origin.x = 10;
    newFrame1.origin.y = justSoYouKnowLabel.frame.size.height + justSoYouKnowLabel.frame.origin.y - 5;
    newFrame1.size.width = expectedLabelSize1.size.width;
    newFrame1.size.height = expectedLabelSize1.size.height;
    justSoYouKnowDetails.frame = newFrame1;
    [self.accessContacts addSubview:justSoYouKnowDetails];
    
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"Let's find me" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:104.0/255.0 green:137.0/255.0 blue:179.0/255.0 alpha:1.0]];
    loginButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [loginButton sizeToFit];
    [loginButton addTarget:self action:@selector(onContactAccessClicked:) forControlEvents:UIControlEventTouchUpInside];
    CGRect loginFrame = loginButton.frame;
    loginFrame.origin.y =justSoYouKnowDetails.frame.origin.y + justSoYouKnowDetails.frame.size.height + 30;
    loginFrame.origin.x = 0;
    loginFrame.size.width = self.view.bounds.size.width/2;
    loginFrame.size.height = 50;
    loginButton.frame = loginFrame;
    [self.accessContacts addSubview:loginButton];
    
    UIButton *goOldSchool = [[UIButton alloc] init];
    [goOldSchool setTitle:@"Do it manually" forState:UIControlStateNormal];
    goOldSchool.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [goOldSchool setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [goOldSchool setBackgroundColor: [UIColor whiteColor]];
    goOldSchool.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [goOldSchool addTarget:self action:@selector(onGoOldSchool:) forControlEvents:UIControlEventTouchUpInside];
    CGRect oldSchoolFrame = goOldSchool.frame;
    oldSchoolFrame.origin.y = loginFrame.origin.y;
    oldSchoolFrame.origin.x = self.view.bounds.size.width/2;
    oldSchoolFrame.size.width = self.view.bounds.size.width/2;
    oldSchoolFrame.size.height = 50;
    goOldSchool.frame = oldSchoolFrame;
    [self.accessContacts addSubview:goOldSchool];
    
    
    
    CGRect userNamePasswordTo = self.createUserPassword.frame;
    userNamePasswordTo.origin.x = -self.view.bounds.size.width;
    CGRect accessContactsTo = self.accessContacts.frame;
    accessContactsTo.origin.x = 0;
    
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.createUserPassword.frame = userNamePasswordTo;
                         self.accessContacts.frame = accessContactsTo;
                         
                     }completion:^(BOOL finished){}];
}

-(IBAction)onContactAccessClicked:(id)sender {
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self showContactToPick];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self showContactToPick];
        
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
}

-(void) showContactToPick {
    
    self.whoAreYou = [[WhoAreYouContactListViewController alloc] init];
    CGRect whoAreFrame = self.whoAreYou.view.frame;
    whoAreFrame.origin.x = self.view.bounds.size.width;
    whoAreFrame.origin.y = 0;
    whoAreFrame.size.width = self.view.bounds.size.width;
    whoAreFrame.size.height = self.view.bounds.size.height;
    self.whoAreYou.view.frame = whoAreFrame;
    
    [self.profileContainer addSubview:self.whoAreYou.view];
    
    CGRect accessContactTo = self.accessContacts.frame;
    accessContactTo.origin.x = -self.view.bounds.size.width;
    CGRect whoAreTo = self.whoAreYou.view.frame;
    whoAreTo.origin.x = 0;
    
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.whoAreYou.view.frame = whoAreTo;
                         self.accessContacts.frame = accessContactTo;
                         
                     }completion:^(BOOL finished){}];
}

-(IBAction)onSubmitProfileTouch:(id)sender {


    NSURL *url = [NSURL URLWithString:@"http://api.buffalop.com/profiles/"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSDictionary *dictionary = @{@"profile": self.userProfileModel};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:kNilOptions error:&error];
    
    if (!error) {
        // 4
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                      // self.userProfileModel = [[UserProfileModel alloc] initWithData:data error:nil];
                                                                   }];
        
        // 5
        [uploadTask resume];
    }
}

-(void) onProfileSelected:(NSNotification *)notification {
    self.profile = [[notification userInfo] valueForKey:@"profile"];
    
    self.pickAPicture = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.profileContainer addSubview:self.pickAPicture];
    
    CGRect labelFrame1 = CGRectMake(25, 80, self.view.frame.size.width - 25, 18);
    UILabel *justSoYouKnowLabel = [[UILabel alloc] initWithFrame:labelFrame1];
    [justSoYouKnowLabel setFont:[UIFont fontWithName:@"Didot" size:30]];
    [justSoYouKnowLabel setText:@"Say cheese!"];
    [justSoYouKnowLabel setTextColor:[UIColor whiteColor]];
    [justSoYouKnowLabel setBackgroundColor:[UIColor clearColor]];
    [self.pickAPicture addSubview:justSoYouKnowLabel];
    
    CGSize maxiToDoMeetingSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    CGRect expectedLabelSize = [justSoYouKnowLabel.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:justSoYouKnowLabel.font} context:nil ];
    
    CGRect newFrame = justSoYouKnowLabel.frame;
    newFrame.size.height = expectedLabelSize.size.height;
    newFrame.size.width = expectedLabelSize.size.width;
    newFrame.origin.x = 20;
    newFrame.origin.y = 50;
    justSoYouKnowLabel.frame = newFrame;
    
    NSString *welcomeText = @"Magna brunch asymmetrical dolore Kickstarter. Kitsch food truck cardigan Etsy, direct trade PBR viral put a bird on it.";
    unichar chr[1] = {'\n'};
    NSString *cr = [NSString stringWithCharacters:(const unichar *)chr length:1];
    CGRect labelFrame = CGRectMake(25, 100, self.view.frame.size.width - 50, 500);
    UILabel *justSoYouKnowDetails = [[UILabel alloc] initWithFrame:labelFrame];
    [justSoYouKnowDetails setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [justSoYouKnowDetails setText: [NSString stringWithFormat:welcomeText, cr]];
    [justSoYouKnowDetails setTextColor:[UIColor whiteColor]];
    [justSoYouKnowDetails setBackgroundColor:[UIColor clearColor]];
    [justSoYouKnowDetails setLineBreakMode:NSLineBreakByWordWrapping];
    [justSoYouKnowDetails setNumberOfLines:0];
    
    CGRect expectedLabelSize1 = [justSoYouKnowDetails.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:justSoYouKnowDetails.font} context:nil ];
    CGRect newFrame1 = justSoYouKnowDetails.frame;
    newFrame1.origin.x = 10;
    newFrame1.origin.y = justSoYouKnowLabel.frame.size.height + justSoYouKnowLabel.frame.origin.y - 5;
    newFrame1.size.width = expectedLabelSize1.size.width;
    newFrame1.size.height = expectedLabelSize1.size.height;
    justSoYouKnowDetails.frame = newFrame1;
    [self.pickAPicture addSubview:justSoYouKnowDetails];
    
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"Get a picture" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:104.0/255.0 green:137.0/255.0 blue:179.0/255.0 alpha:1.0]];
    loginButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [loginButton sizeToFit];
    [loginButton addTarget:self action:@selector(onPickProfilePicture:) forControlEvents:UIControlEventTouchUpInside];
    CGRect loginFrame = loginButton.frame;
    loginFrame.origin.y =justSoYouKnowDetails.frame.origin.y + justSoYouKnowDetails.frame.size.height + 30;
    loginFrame.origin.x = 0;
    loginFrame.size.width = self.view.bounds.size.width/2;
    loginFrame.size.height = 50;
    loginButton.frame = loginFrame;
    [self.pickAPicture addSubview:loginButton];
    
    UIButton *goOldSchool = [[UIButton alloc] init];
    [goOldSchool setTitle:@"Skip this" forState:UIControlStateNormal];
    goOldSchool.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [goOldSchool setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [goOldSchool setBackgroundColor: [UIColor whiteColor]];
    goOldSchool.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [goOldSchool addTarget:self action:@selector(onSkipProfilePicture:) forControlEvents:UIControlEventTouchUpInside];
    CGRect oldSchoolFrame = goOldSchool.frame;
    oldSchoolFrame.origin.y = loginFrame.origin.y;
    oldSchoolFrame.origin.x = self.view.bounds.size.width/2;
    oldSchoolFrame.size.width = self.view.bounds.size.width/2;
    oldSchoolFrame.size.height = 50;
    goOldSchool.frame = oldSchoolFrame;
    [self.pickAPicture addSubview:goOldSchool];
    
    CGRect whoAreTo = self.whoAreYou.view.frame;
    whoAreTo.origin.x = -self.view.bounds.size.width;
    CGRect sayCheeseTo = self.pickAPicture.frame;
    sayCheeseTo.origin.x = 0;
    
    
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.whoAreYou.view.frame = whoAreTo;
                         self.pickAPicture.frame = sayCheeseTo;
                         
                     }completion:^(BOOL finished){}];
}

-(IBAction)onPickProfilePicture:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"tempProfilePicture.png"];
    UIImage *image = chosenImage; // imageView is my image from camera
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    CGRect sayCheeseFrame = self.pickAPicture.frame;
    sayCheeseFrame.origin.x = -self.view.frame.size.width;
    self.pickAPicture.frame = sayCheeseFrame;
    
    self.confirmPicture = [[UIView alloc] initWithFrame:self.view.bounds];
    self.profilePicture = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.profilePicture.image = chosenImage;
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    [self.confirmPicture addSubview:self.profilePicture];
    [self.profileContainer addSubview:self.confirmPicture];

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    //NSData *data = UIImageJPEGRepresentation(chosenImage, 1.0);
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"tempProfilePicture.png"];
    NSURL *tempURL = [[NSURL alloc] initFileURLWithPath:getImagePath];
    
    
    
    
    BFTask *task = [BFTask taskWithResult:nil];
    
    AWSCognitoCredentialsProvider *credentialsProvider = [AWSCognitoCredentialsProvider
                                                          credentialsWithRegionType:AWSRegionUSEast1
                                                          accountId:@"203816133875"
                                                          identityPoolId:@"us-east-1:bbdd5ff5-0fe9-4978-b24f-ccc9db938244"
                                                          unauthRoleArn:@"arn:aws:iam::203816133875:role/Cognito_BuffaloProjectYoUnauth_DefaultRole"
                                                          authRoleArn:@"arn:aws:iam::203816133875:role/Cognito_BuffaloProjectYoAuth_DefaultRole"];
    
    [[credentialsProvider getIdentityId] continueWithSuccessBlock:^id(BFTask *task){
        NSString* cognitoId = credentialsProvider.identityId;
        return nil;
    }];
    
    AWSServiceConfiguration *configuration = [AWSServiceConfiguration configurationWithRegion:AWSRegionUSEast1
                                                                          credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    //AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    //AWSS3 *transferManager = [[AWSS3 alloc] initWithConfiguration:configuration];

    /*AWSS3PutObjectRequest *por = [AWSS3PutObjectRequest new];
    por.contentType = @"image/jpeg";
    por.bucket = @"buffaloprofileimages";
    por.body = chosenImage;*/

    AWSS3TransferManagerUploadRequest *request = [AWSS3TransferManagerUploadRequest new];
    request.bucket = @"buffaloimages";
    request.contentType = @"image/png";
    request.body = tempURL;
    request.key =  self.profile.profileID;;
    
    
    [[transferManager upload:request] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        if (task.error != nil) {
            NSLog(@"Error: [%@]", task.error);
            //self.uploadStatusLabel.text = StatusLabelFailed;
        } else {
            NSLog(@"Success");
            //self.uploadStatusLabel.text = StatusLabelCompleted;
            [self getMissingCreditials];
        }
        return nil;
    }];
    
}

-(void)getMissingCreditials {

    self.currentMissingInformationScreen = -1;
    
    NSUInteger p = 0;
    for(;p< [self.profile.emailAddresses count]; p++) {
        ProfileStartEmailCreditialsEditorViewController *tempEmailCreditialsEditor = [[ProfileStartEmailCreditialsEditorViewController alloc] init];
        [tempEmailCreditialsEditor addAccount:[self.profile.emailAddresses objectAtIndex:p]];
        [self.missingInformationScreensArray addObject:tempEmailCreditialsEditor];
    }
    
    for(;p< [self.profile.instantMessengerAccounts count]; p++) {
        ProfileStartInstantMessengerCreditialsEditorViewController *tempInstantMessengerCreditialsEditor =[[ProfileStartInstantMessengerCreditialsEditorViewController alloc] init];
        [tempInstantMessengerCreditialsEditor addAccount:[self.profile.instantMessengerAccounts objectAtIndex:p]];
        [self.missingInformationScreensArray addObject:tempInstantMessengerCreditialsEditor];
    }

    self.missingInformationWelcome = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.missingInformationWelcome];
    
    CGRect labelFrame1 = CGRectMake(25, 80, self.view.frame.size.width - 25, 18);
    UILabel *justSoYouKnowLabel = [[UILabel alloc] initWithFrame:labelFrame1];
    [justSoYouKnowLabel setFont:[UIFont fontWithName:@"Didot" size:30]];
    [justSoYouKnowLabel setText:@"Lets get started"];
    [justSoYouKnowLabel setTextColor:[UIColor whiteColor]];
    [justSoYouKnowLabel setBackgroundColor:[UIColor clearColor]];
    [self.missingInformationWelcome addSubview:justSoYouKnowLabel];
    
    CGSize maxiToDoMeetingSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    CGRect expectedLabelSize = [justSoYouKnowLabel.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:justSoYouKnowLabel.font} context:nil ];
    
    CGRect newFrame = justSoYouKnowLabel.frame;
    newFrame.size.height = expectedLabelSize.size.height;
    newFrame.size.width = expectedLabelSize.size.width;
    newFrame.origin.x = 20;
    newFrame.origin.y = 50;
    justSoYouKnowLabel.frame = newFrame;
    
    NSString *welcomeText = @"Magna brunch asymmetrical dolore Kickstarter. Kitsch food truck cardigan Etsy, direct trade PBR viral put a bird on it.";
    unichar chr[1] = {'\n'};
    NSString *cr = [NSString stringWithCharacters:(const unichar *)chr length:1];
    CGRect labelFrame = CGRectMake(25, 100, self.view.frame.size.width - 50, 500);
    UILabel *justSoYouKnowDetails = [[UILabel alloc] initWithFrame:labelFrame];
    [justSoYouKnowDetails setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [justSoYouKnowDetails setText: [NSString stringWithFormat:welcomeText, cr]];
    [justSoYouKnowDetails setTextColor:[UIColor whiteColor]];
    [justSoYouKnowDetails setBackgroundColor:[UIColor clearColor]];
    [justSoYouKnowDetails setLineBreakMode:NSLineBreakByWordWrapping];
    [justSoYouKnowDetails setNumberOfLines:0];
    
    CGRect expectedLabelSize1 = [justSoYouKnowDetails.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:justSoYouKnowDetails.font} context:nil ];
    CGRect newFrame1 = justSoYouKnowDetails.frame;
    newFrame1.origin.x = 10;
    newFrame1.origin.y = justSoYouKnowLabel.frame.size.height + justSoYouKnowLabel.frame.origin.y - 5;
    newFrame1.size.width = expectedLabelSize1.size.width;
    newFrame1.size.height = expectedLabelSize1.size.height;
    justSoYouKnowDetails.frame = newFrame1;
    [self.missingInformationWelcome addSubview:justSoYouKnowDetails];
    
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"Lets do it" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:104.0/255.0 green:137.0/255.0 blue:179.0/255.0 alpha:1.0]];
    loginButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [loginButton sizeToFit];
    [loginButton addTarget:self action:@selector(onStartMissingInformation:) forControlEvents:UIControlEventTouchUpInside];
    CGRect loginFrame = loginButton.frame;
    loginFrame.origin.y =self.passwordInput.frame.origin.y + self.passwordInput.frame.size.height + 30;
    loginFrame.origin.x = 20;
    loginFrame.size.width = self.view.bounds.size.width - 40 ;
    loginFrame.size.height = 50;
    loginButton.frame = loginFrame;
    
    [self.missingInformationWelcome addSubview:loginButton];
    
    CGRect profilePictureTo = self.whoAreYou.view.frame;
    profilePictureTo.origin.x = -self.view.bounds.size.width;
    CGRect missingWelcomeTo = self.pickAPicture.frame;
    missingWelcomeTo.origin.x = 0;
    
    
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.confirmPicture.frame = profilePictureTo;
                         self.missingInformationWelcome.frame = missingWelcomeTo;
                     }completion:^(BOOL finished){}];
}

-(IBAction)onStartMissingInformation:(id)sender {
    [self showNextMissingInformationScreen];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccountFixed:) name:@"accountFixed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccountSkipped:) name:@"accountSkipped" object:nil];
}

-(void) onAccountFixed:(NSNotification *)notification {
    [self showNextMissingInformationScreen];
}

-(void) onAccountSkipped:(NSNotification *)notification {
    [self showNextMissingInformationScreen];
}

-(void)showNextMissingInformationScreen {
    self.currentMissingInformationScreen++;
    
    if(self.currentMissingInformationScreen != ([self.missingInformationScreensArray count]-1)) {
        [self.profileContainer addSubview:[self.missingInformationScreensArray objectAtIndex:self.currentMissingInformationScreen]];
        if(self.currentMissingInformationScreen == 0) {
            
            CGRect missingWelcomeTo = self.missingInformationWelcome.frame;
            missingWelcomeTo.origin.x = self.view.bounds.size.width;
            missingWelcomeTo.origin.x = -self.view.bounds.size.width;
            EmailAddressEditorViewController *tempAccountEditor = [self.missingInformationScreensArray objectAtIndex:self.currentMissingInformationScreen];
            CGRect missingScreenTo = tempAccountEditor.view.frame;
            missingScreenTo.origin.x = self.view.bounds.size.width;
            [self.profileContainer addSubview:tempAccountEditor.view];
            missingScreenTo.origin.x = 0;
            
            [UIView animateWithDuration:0.25
                                  delay: 0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.missingInformationWelcome.frame = missingWelcomeTo;
                                 tempAccountEditor.view.frame = missingScreenTo;
                             }completion:^(BOOL finished){}];
        } else {
            EmailAddressEditorViewController *tempAccountEditor1 = [self.missingInformationScreensArray objectAtIndex:self.currentMissingInformationScreen-1];
            CGRect missingScreen1To = tempAccountEditor1.view.frame;
            missingScreen1To.origin.x = -self.view.bounds.size.width;
            
            EmailAddressEditorViewController *tempAccountEditor2 = [self.missingInformationScreensArray objectAtIndex:self.currentMissingInformationScreen];
            CGRect missingScreen2To = tempAccountEditor2.view.frame;
            missingScreen2To.origin.x = self.view.bounds.size.width;
            [self.profileContainer addSubview:tempAccountEditor2.view];
            missingScreen2To.origin.x = 0;
            
            [UIView animateWithDuration:0.25
                                  delay: 0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 tempAccountEditor1.view.frame = missingScreen1To;
                                 tempAccountEditor2.view.frame = missingScreen2To;
                             }completion:^(BOOL finished){}];
        }
        
    } else {
        [self doneWithProfile];
    }
}

-(void)doneWithProfile {
    EmailAddressEditorViewController *tempAccountEditor = [self.missingInformationScreensArray objectAtIndex:self.currentMissingInformationScreen];
    CGRect missingScreenTo = tempAccountEditor.view.frame;
    missingScreenTo.origin.x = -self.view.bounds.size.width;
    
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         tempAccountEditor.view.frame = missingScreenTo;
                     }completion:^(BOOL finished){}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void) showProfileWizard {
    
}

-(void) showProfileView {
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //UIImage *background = [UIImage imageNamed:@"fall.jpg"];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.alpha = 0;
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    // [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    self.tableParentContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableParentContainer];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableParentContainer addSubview:self.tableView];
    
    CGRect headerFrame = self.view.bounds;
    self.header = [[UIView alloc] initWithFrame:headerFrame];
    self.header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.header;
    
    self.nameContent = [[UIView alloc] init];
    [self.header addSubview:self.nameContent];
    
    int yPos = 0;
    [self createNameLabels];
    yPos = self.nameContent.frame.size.height;
    
    if([self.userProfileModel.addresses count]>0) {
        self.addressContent = [[UIView alloc] init];
        [self createAddressLabel];
        NSLog(@"ypos intial old %d", yPos);
        yPos = yPos + self.addressContent.frame.size.height;
        NSLog(@"ypos intial new %d", yPos);
        [self.header addSubview:self.addressContent];
    }
   /* self.buttonContent = [[UIView alloc] init];
    [self.header addSubview:self.buttonContent];
    [self createButtons];*/
    yPos = yPos + 40;
    
    
    
    yPos = self.view.frame.size.height -  yPos;
    
    CGRect newFrame = self.nameContent.frame;
    newFrame.origin.y = yPos;
    self.nameContent.frame = newFrame;
    
    if([self.userProfileModel.addresses count]>0) {
        yPos = yPos + self.nameContent.frame.size.height;
        yPos = yPos - 10;
        
        CGRect addressFrame = self.addressContent.frame;
        addressFrame.origin.y = yPos;
        self.addressContent.frame = addressFrame;
        NSLog(@"ypos old %d", yPos);
        yPos = yPos + self.addressContent.frame.size.height + 10;
        NSLog(@"ypos new %d", yPos);
        CGRect buttonFrame = self.buttonContent.frame;
        buttonFrame.origin.y = self.view.bounds.size.height - 40;
        self.buttonContent.frame = buttonFrame;
    } else {
        yPos = yPos + self.nameContent.frame.size.height;
        newFrame = self.buttonContent.frame;
        newFrame.origin.y = yPos;
        self.buttonContent.frame = newFrame;
    }
    
    NSMutableString *filePath = [[NSMutableString alloc] init];
    [filePath appendString:@"big"];
    [filePath appendString:[self.userProfileModel.firstName substringToIndex:1].lowercaseString];
    [filePath appendString:@".png"];
    
    self.loaderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filePath]];
    self.loaderImage.frame = self.view.bounds;
    self.loaderImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.loaderImage];
    
    
    __block NSData *imageData;
    dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.buffaloproject.profileImageBGqueue", NULL);
    
    dispatch_async(backgroundQueue, ^(void) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.userProfileModel.personBigImage]];
        UIImage *imageLoad;
        imageLoad = [[UIImage alloc] initWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.backgroundImageView setImage:imageLoad];
            [self.blurredImageView setImageToBlur:imageLoad blurRadius:10 completionBlock:nil];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:.5];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            self.backgroundImageView.alpha = 1;
            self.loaderImage.alpha = 0;
            [UIView commitAnimations];
        });
    });
    
    [self addAddressListeners];
}

-(void) addAddressListeners {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactAddressesListView:) name:@"showContactAddressesList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactAddressListView:) name:@"cancelContactAddressesList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactAddressEditorView:) name:@"showContactAddressEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactAddressEditorView:) name:@"cancelAddressEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowAddressSearchResults:) name:@"searchForContactAddress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddContactAddress:) name:@"addContactAddress" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactPhoneNumbersListView:) name:@"showContactPhoneNumbersList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactPhoneNumbersListView:) name:@"cancelContactPhoneNumbersList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactPhoneNumberEditorView:) name:@"showContactPhoneNumberEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactPhoneNumberEditorView:) name:@"cancelPhoneNumberEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddPhoneNumber:) name:@"addPhoneNumber" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactEmailAddressesListView:) name:@"showContactEmailAddressesList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactEmailAddressesListView:) name:@"cancelContactEmailAddressesList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactEmailAddressEditorView:) name:@"showContactEmailAddressEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactEmailAddressEditorView:) name:@"cancelEmailAddressEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddEmailAddressAccount:) name:@"addEmailAddress" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactInstantMessengerAccountsListView:) name:@"showContactInstantMessengerAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactInstantMessengerAccountsListView:) name:@"cancelContactInstantMessengerAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactInstantMessengerEditorView:) name:@"showContactInstantMessengerEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactInstantMessengerEditorView:) name:@"cancelInstantMessengerEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddInstantMessengerAccount:) name:@"addInstantMessengerAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowEditContactBirthdayView:) name:@"showContactBirthdayEditScreen" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactFacebookAccountsListView:) name:@"showContactFacebookAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactFacebookAccountsListView:) name:@"cancelContactFacebookAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactFacebookEditorView:) name:@"showContactFacebookEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactFacebookEditorView:) name:@"cancelFacebookEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddFacebookAccount:) name:@"addFacebookAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactGooglePlusAccountsListView:) name:@"showContactGooglePlusAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactGooglePlusAccountsListView:) name:@"cancelContactGooglePlusAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactGooglePlusEditorView:) name:@"showContactGooglePlusEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactGooglePlusEditorView:) name:@"cancelGooglePlusEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddGooglePlusAccount:) name:@"addGooglePlusAccount" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactLinkedInAccountsListView:) name:@"showContactLinkedInAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactLinkedInAccountsListView:) name:@"cancelContactLinkedInAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactLinkedInEditorView:) name:@"showContactLinkedInEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactLinkedInEditorView:) name:@"cancelLinkedInEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddLinkedInAccount:) name:@"addLinkedInAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactTwitterAccountsListView:) name:@"showTwitterAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactTwitterAccountsListView:) name:@"cancelTwitterAccountsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactTwitterEditorView:) name:@"showContactTwitterEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContacttwitterEditorView:) name:@"cancelTwitterEditor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddTwitterAccount:) name:@"addTwitterAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowContactRelationshipsListView:) name:@"showRelationshipsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancelContactRelationshipsListView:) name:@"cancelContactRelationshipsList" object:nil];
}


-(void) backgroundImage1Loaded:(UIImage *)image {
    if(image) {
        NSLog(@"image loaded");
        [self.backgroundImageView setImage:image];
        [self.blurredImageView setImageToBlur:image blurRadius:10 completionBlock:nil];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    self.blurredImageView.alpha = percent;
}

//ADDRESSES
-(void) onShowContactAddressesListView:(NSNotification *)notification {
    
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactAddressListView = [[ContactAddressListViewController alloc] init];
    CGRect addressListFrame = contactAddressListView.view.frame;
    addressListFrame.origin.x = self.view.bounds.size.width;
    contactAddressListView.view.frame = addressListFrame;
    [contactAddressListView person:person];
    [self.view addSubview:contactAddressListView.view];
    
    CGRect profileListTo = CGRectMake(-self.view.bounds.size.width, 0, addressListFrame.size.width, addressListFrame.size.height);
    CGRect addressListTo = CGRectMake(0, 0, addressListFrame.size.width, addressListFrame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.tableParentContainer.frame = profileListTo;
    contactAddressListView.view.frame = addressListTo;
    
    [UIView commitAnimations];
}

-(void) onCancelContactAddressListView:(NSNotification *)notification {
    CGRect profileListTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect addressListTo = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeAddressListView:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.tableParentContainer.frame = profileListTo;
    contactAddressListView.view.frame = addressListTo;
    [UIView commitAnimations];
}

-(void)removeAddressListView:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [contactAddressListView.view removeFromSuperview];
}

-(void) onShowContactAddressEditorView:(NSNotification *)notification {
    contactAddressEditorView = [[AddressEditorViewController alloc] init];
    CGRect editorFrame = contactAddressEditorView.view.frame;
    editorFrame.origin.x = self.view.bounds.size.width;
    contactAddressEditorView.view.frame = editorFrame;
    [self.view addSubview:contactAddressEditorView.view];
    
    CGRect addressEditorTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect addressListTo = CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    contactAddressEditorView.view.frame = addressEditorTo;
    contactAddressListView.view.frame = addressListTo;
    [UIView commitAnimations];
}

-(void) onCancelContactAddressEditorView:(NSNotification *)notification {
    CGRect addressEditorTo = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect addressListTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeAddressEditorView:finished:context:)];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    contactAddressEditorView.view.frame = addressEditorTo;
    contactAddressListView.view.frame = addressListTo;
    [UIView commitAnimations];
}

-(void)removeAddressEditorView:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    [contactAddressEditorView.view removeFromSuperview];
}


-(void)onShowAddressSearchResults:(NSNotification *)notification {
    NSString *searchText = [[notification userInfo] valueForKey:@"searchText"];
    self.addressSearchResults = [[ContactAddressSearchViewController alloc] initWithSearch:searchText initWithNibName:@"ContactAddressSearchViewController" bundle:nil];
    
    CGRect initalFrame = self.addressSearchResults.view.frame;
    initalFrame.origin.x = self.view.bounds.size.width;
    self.addressSearchResults.view.frame = initalFrame;
    [self.view addSubview:self.addressSearchResults.view];
    
    CGRect editorTo = CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect resultsTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    contactAddressEditorView.view.frame = editorTo;
    self.addressSearchResults.view.frame = resultsTo;
    [UIView commitAnimations];
}

-(void)onAddContactAddress:(NSNotification *)notification {
    
    AddressHistoryModel *addressHistory = [[notification userInfo] valueForKey:@"addressHistory"];
    
    CGRect resultsTo = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect listTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
    ;
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         contactAddressListView.view.frame = listTo;
                         self.addressSearchResults.view.frame = resultsTo;
                     }
                     completion:^(BOOL finished){
                         [contactAddressListView addAddress:addressHistory];
                         [contactAddressListView.view removeFromSuperview];
                         [contactAddressEditorView.view removeFromSuperview];
                     }];
}

-(void) onShowContactPhoneNumbersListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactPhoneNumberListView = [[ContactPhoneNumberListViewViewController alloc] init];
    [contactPhoneNumberListView person:person];
    
    [self.view addSubview:contactPhoneNumberListView.view];
}

-(void) onCancelContactPhoneNumbersListView:(NSNotification *)notification {
    [contactPhoneNumberListView.view removeFromSuperview];
}

-(void) onShowContactPhoneNumberEditorView:(NSNotification *)notification {
    contactPhoneNumberEditorView = [[PhoneNumberEditorViewController alloc] init];
    
    [self.view addSubview:contactPhoneNumberEditorView.view];
}

-(void) onCancelContactPhoneNumberEditorView:(NSNotification *)notification {
    [contactPhoneNumberEditorView.view removeFromSuperview];
}

-(void) onAddPhoneNumber:(NSNotification *)notification {
    
    PhoneNumberHistoryModel *newPhoneNumber = [[notification userInfo] valueForKey:@"phoneNumber"];
    
    CGRect resultsTo = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect listTo = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
    ;
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         contactAddressListView.view.frame = listTo;
                         self.addressSearchResults.view.frame = resultsTo;
                     }
                     completion:^(BOOL finished){
                         
                         //[contactAddressListView addAddress:addressHistory];
                         //[contactAddressListView.view removeFromSuperview];
                         //[contactAddressEditorView.view removeFromSuperview];
                     }];
    
    [contactPhoneNumberListView addPhoneNumber:newPhoneNumber];
    
    [contactPhoneNumberEditorView.view removeFromSuperview];
}

-(void)onShowContactEmailAddressesListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactEmailListView = [[ContactEmailAddressListViewController alloc] init];
    [contactEmailListView person:person];
    
    [self.view addSubview:contactEmailListView.view];
}

-(void) onCancelContactEmailAddressesListView:(NSNotification *)notification {
    [contactEmailListView.view removeFromSuperview];
}

-(void) onShowContactEmailAddressEditorView:(NSNotification *)notification {
    contactEmailAddressEditor = [[EmailAddressEditorViewController alloc] init];
    
    [self.view addSubview:contactEmailAddressEditor.view];
}

-(void) onCancelContactEmailAddressEditorView:(NSNotification *)notification {
    [contactEmailAddressEditor.view removeFromSuperview];
}

-(void) onAddEmailAddressAccount:(NSNotification *)notification {
    
    EmailAddressHistoryModel *newEmailAddress = [[notification userInfo] valueForKey:@"emailAddress"];
    [contactEmailListView addEmailAddress:newEmailAddress];
    
    [contactEmailAddressEditor.view removeFromSuperview];
}

-(void)onShowContactInstantMessengerAccountsListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactInstantMessengerListView = [[ContactInstantMessengerListViewController alloc] init];
    [contactInstantMessengerListView person:person];
    
    [self.view addSubview:contactInstantMessengerListView.view];
}

-(void) onCancelContactInstantMessengerAccountsListView:(NSNotification *)notification {
    [contactInstantMessengerListView.view removeFromSuperview];
}

-(void) onShowContactInstantMessengerEditorView:(NSNotification *)notification {
    contactInstantMessengerEditorView = [[InstantMessengerEditorViewController alloc] init];
    
    [self.view addSubview:contactInstantMessengerEditorView.view];
}

-(void) onCancelContactInstantMessengerEditorView:(NSNotification *)notification {
    [contactInstantMessengerEditorView.view removeFromSuperview];
}

-(void) onAddInstantMessengerAccount:(NSNotification *)notification {
    
    InstantMessengerAccountHistoryModel *newInstantMessengerAccount = [[notification userInfo] valueForKey:@"instantMessengerAccount"];
    [contactInstantMessengerListView addInstantMessengerAccount:newInstantMessengerAccount];
    
    [contactInstantMessengerEditorView.view removeFromSuperview];
}

-(void) onShowContactLinkedInAccountsListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactLinkedInListView = [[ContactLinkedInAccountListViewController alloc] init];
    [contactLinkedInListView person:person];
    
    [self.view addSubview:contactLinkedInListView.view];
}

-(void) onCancelContactLinkedInAccountsListView:(NSNotification *)notification {
    [contactLinkedInListView.view removeFromSuperview];
}

-(void) onShowContactLinkedInEditorView:(NSNotification *)notification {
    contactLinkedInEditorView = [[LinkedInEditorViewController alloc] init];
    
    [self.view addSubview:contactLinkedInEditorView.view];
}

-(void) onCancelContactLinkedInEditorView:(NSNotification *)notification {
    [contactLinkedInEditorView.view removeFromSuperview];
}

-(void) onAddLinkedInAccount:(NSNotification *)notification {
    LinkedInAccountHistoryModel *newLinkedInAccount = [[notification userInfo] valueForKey:@"linkedInAccount"];
    [contactLinkedInListView addLinkedInAccount:newLinkedInAccount];
    
    [contactLinkedInEditorView.view removeFromSuperview];
}

-(void) onShowContactGooglePlusAccountsListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactGooglePlusListView = [[ContactGooglePlusAccountListViewController alloc] init];
    [contactGooglePlusListView person:person];
    
    [self.view addSubview:contactGooglePlusListView.view];
}

-(void) onCancelContactGooglePlusAccountsListView:(NSNotification *)notification {
    [contactGooglePlusListView.view removeFromSuperview];
}

-(void) onShowContactGooglePlusEditorView:(NSNotification *)notification {
    contactGooglePlusEditorView = [[GooglePlusEditorViewController alloc] init];
    
    [self.view addSubview:contactGooglePlusEditorView.view];
}

-(void) onCancelContactGooglePlusEditorView:(NSNotification *)notification {
    [contactGooglePlusEditorView.view removeFromSuperview];
}

-(void) onAddGooglePlusAccount:(NSNotification *)notification {
    
    GooglePlusAccountHistoryModel *newGooglePlusAccount = [[notification userInfo] valueForKey:@"googlePlusAccount"];
    [contactGooglePlusListView addGooglePlusAccount:newGooglePlusAccount];
    
    [contactGooglePlusEditorView.view removeFromSuperview];
}

-(void) onShowContactFacebookAccountsListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactFacebookListView = [[ContactFacebookAccountListViewController alloc] init];
    [contactFacebookListView person:person];
    
    [self.view addSubview:contactFacebookListView.view];
}

-(void) onCancelContactFacebookAccountsListView:(NSNotification *)notification {
    [contactFacebookListView.view removeFromSuperview];
}

-(void) onShowContactFacebookEditorView:(NSNotification *)notification {
    contactFacebookEditorView = [[FacebookEditorViewController alloc] init];
    
    [self.view addSubview:contactFacebookEditorView.view];
}

-(void) onCancelContactFacebookEditorView:(NSNotification *)notification {
    [contactFacebookEditorView.view removeFromSuperview];
}

-(void) onAddFacebookAccount:(NSNotification *)notification {
    
    FacebookAccountHistoryModel *newFacebookAccount = [[notification userInfo] valueForKey:@"facebookAccount"];
    [contactFacebookListView addFacebookAccount:newFacebookAccount];
    
    [contactFacebookEditorView.view removeFromSuperview];
}

-(void)onShowContactTwitterAccountsListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactTwitterListView = [[ContactTwitterAccountListViewController alloc] init];
    [contactTwitterListView person:person];
    
    [self.view addSubview:contactTwitterListView.view];
}

-(void) onCancelContactTwitterAccountsListView:(NSNotification *)notification {
    [contactTwitterListView.view removeFromSuperview];
}

-(void) onShowContactTwitterEditorView:(NSNotification *)notification {
    contactTwitterEditorView = [[TwitterEditorViewController alloc] init];
    
    [self.view addSubview:contactTwitterEditorView.view];
}

-(void) onCancelContacttwitterEditorView:(NSNotification *)notification {
    [contactTwitterEditorView.view removeFromSuperview];
}

-(void) onAddTwitterAccount:(NSNotification *)notification {
    TwitterAccountHistoryModel *newTwitterAccount = [[notification userInfo] valueForKey:@"twitterAccount"];
    [contactTwitterListView addTwitterAccount:newTwitterAccount];
    
    [contactTwitterEditorView.view removeFromSuperview];
}

-(void)onShowContactRelationshipsListView:(NSNotification *)notification {
    PersonModel *person = [[notification userInfo] valueForKey:@"person"];
    contactRelationshipsListView = [[ContactRelationshipsListViewController alloc] init];
    [contactRelationshipListView person:person];
    
    [self.view addSubview:contactRelationshipListView.view];
}

-(void) onCancelContactRelationshipsListView:(NSNotification *)notification {
    [contactRelationshipListView.view removeFromSuperview];
}



//TOOD

//GENERAL

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];

        self.profileSectionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [cell.contentView addSubview:self.profileSectionIcon];
        
        self.profileSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, self.view.bounds.size.width - 20, 30)];
        self.profileSectionLabel.textColor = [UIColor whiteColor];
        self.profileSectionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.profileSectionLabel.adjustsFontSizeToFitWidth = NO;
        self.profileSectionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:self.profileSectionLabel];
    }
    
    switch (indexPath.row) {
        case 0:
            
            if(dateFormatter == nil){
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMMM d, yyyy"];
            }
            self.profileSectionLabel.text = [dateFormatter stringFromDate: self.userProfileModel.birthday];
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"birthdayIcon.png"]];
            break;
        case 1:
            self.profileSectionLabel.text = @"Addresses";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"addressIcon.png"]];
            break;
        case 2:
            self.profileSectionLabel.text = @"Phone Numbers";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"phoneListIcon.png"]];
            break;
        case 3:
            self.profileSectionLabel.text = @"Email Addresses";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"emailIcon.png"]];
            break;
        case 4:
            self.profileSectionLabel.text = @"Instant Messenger Accounts";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"imIcon.png"]];
            break;
        case 5:
            self.profileSectionLabel.text = @"Facebook Accounts";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"facebookIcon.png"]];
            break;
        case 6:
            self.profileSectionLabel.text = @"Google+ Accounts";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"googlePlusIcon.png"]];
            break;
        case 7:
            self.profileSectionLabel.text = @"Linked In Accounts";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"linkedInIcon.png"]];
            break;
        case 8:
            self.profileSectionLabel.text = @"Twitter Accounts";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"twitterIcon.png"]];
            break;
        case 9:
            self.profileSectionLabel.text = @"Relationships";
            [self.profileSectionIcon setImage:[UIImage imageNamed:@"relationshipsIcon.png"]];
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)createNameLabels {
    
    NSArray *names = [[NSArray alloc] initWithObjects:self.userProfileModel.firstName, self.userProfileModel.lastName, nil];
    self.nameLabelArray = [[NSMutableArray alloc] init];
    int nameHeight = 0;
    for(NSString *aName in names) {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        NSMutableAttributedString *nameAttributed =  [[NSMutableAttributedString alloc] initWithString:aName attributes:
                                                      @{
                                                        NSFontAttributeName : [UIFont fontWithName:@"Didot" size:57],
                                                        NSKernAttributeName : @(-5.3f),
                                                        NSForegroundColorAttributeName :[UIColor whiteColor]
                                                        }];
        nameLabel.attributedText = nameAttributed;
        
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [aName boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nameLabel.font} context:nil];
        CGRect newFrame = nameLabel.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        nameLabel.frame = newFrame;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameHeight = nameHeight + nameLabel.frame.size.height;
        nameHeight = nameHeight - 27;
        
        [self.nameContent addSubview:nameLabel];
        [self.nameLabelArray addObject:nameLabel];
    }
    
    // UILabel *aLabel = [self.nameLabelArray objectAtIndex:0];
    
    
    
    int yPos = 0;
    for(UILabel *aNameLabel in self.nameLabelArray) {
        CGRect newFrame = aNameLabel.frame;
        newFrame.origin.y = yPos;
        aNameLabel.frame = newFrame;
        yPos = yPos + 80;
    }
    
    CGRect nameFrame = self.nameContent.frame;
    nameHeight = nameHeight + 27;
    nameFrame.size.height = yPos - 10;
    nameFrame.size.width = self.view.frame.size.width;
    self.nameContent.frame = nameFrame;
}

-(void) createAddressLabel {
    
    int totalHeight = 0;
    AddressHistoryModel *aAddressHistory = [self.userProfileModel.addresses objectAtIndex:0];
    AddressModel *aAddress = aAddressHistory.account;
    
    if([aAddress.addressLine1 length]>0) {
        UILabel *addressLine1Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        addressLine1Label.text = aAddress.addressLine1;
        addressLine1Label.font = [UIFont fontWithName:@"Colaborate" size:12];
        addressLine1Label.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [aAddress.addressLine1 boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:addressLine1Label.font} context:nil];
        CGRect newFrame = addressLine1Label.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        addressLine1Label.frame = newFrame;
        totalHeight = totalHeight + addressLine1Label.frame.size.height;
        [self.addressContent addSubview:addressLine1Label];
    }
    
    if([aAddress.addressLine2 length]>0) {
        UILabel *addressLine2Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        addressLine2Label.text = aAddress.addressLine2;
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
        [self.addressContent addSubview:addressLine2Label];
    }
    
    int currentWidth = 0;
    
    if([aAddress.city length]>0) {
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        cityLabel.text = aAddress.city;
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
        [self.addressContent addSubview:cityLabel];
    }
    
    if([aAddress.state length]>0) {
        NSMutableString *stateString = [[NSMutableString alloc] init];
        if([aAddress.city length]>0) {
            [stateString appendString:@", "];
        }
        
        [stateString appendString:aAddress.state];
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        stateLabel.text = aAddress.state;
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
        [self.addressContent addSubview:stateLabel];
    }
    
    if([aAddress.zipcode length]>0) {
        UILabel *zipCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        zipCodeLabel.text = aAddress.state;
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
        [self.addressContent addSubview:zipCodeLabel];
    }
    
    CGRect addressContentFrame = self.addressContent.frame;
    addressContentFrame.size.height = totalHeight;
    addressContentFrame.size.width = self.view.frame.size.width;
    self.addressContent.frame = addressContentFrame;
}

-(void) createButtons {
    
    UIButton *phoneCallButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    [phoneCallButton setBackgroundImage:[UIImage imageNamed:@"phoneIcon"] forState:UIControlStateNormal];
    [phoneCallButton addTarget:self action:@selector(onPhoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    CGRect newFrame = self.buttonContent.frame;
    newFrame.size.height = 40;
    self.buttonContent.frame = newFrame;
    [self.buttonContent addSubview:phoneCallButton];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.view.bounds.size.height/10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.userProfileModel forKey:@"person"];
    switch (indexPath.row) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactBirthdayEditScreen" object:nil userInfo:userInfo];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactAddressesList" object:nil userInfo:userInfo];
            break;
        case 2:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactPhoneNumbersList" object:nil userInfo:userInfo];
            break;
        case 3:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactEmailAddressesList" object:nil userInfo:userInfo];
            break;
        case 4:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactInstantMessengerAccountsList" object:nil userInfo:userInfo];
            break;
        case 5:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactFacebookAccountsList" object:nil userInfo:userInfo];
            break;
        case 6:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactGooglePlusAccountsList" object:nil userInfo:userInfo];
            break;
        case 7:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showContactLinkedInAccountsList" object:nil userInfo:userInfo];
            break;
        case 8:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showTwitterAccountsList" object:nil userInfo:userInfo];
            break;
        case 9:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showRelationshipsList" object:nil userInfo:userInfo];
            break;
        default:
            break;
    }
}

-(IBAction)onPhoneButtonClick:(id)sender {
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
    self.welcomeContainer.frame = bounds;
    self.createUserPassword.frame = bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
