//
//  ProfileStartInstantMessengerCreditialsEditorViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 7/19/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ProfileStartInstantMessengerCreditialsEditorViewController.h"

@interface ProfileStartInstantMessengerCreditialsEditorViewController ()

@end

@implementation ProfileStartInstantMessengerCreditialsEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addAccount:(InstantMessengerAccountHistoryModel *)instantMessengerAccount {
    self.instantMessengerAccount = instantMessengerAccount;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect labelFrame1 = CGRectMake(25, 80, self.view.frame.size.width - 25, 18);
    UILabel *justSoYouKnowLabel = [[UILabel alloc] initWithFrame:labelFrame1];
    [justSoYouKnowLabel setFont:[UIFont fontWithName:@"Didot" size:30]];
    [justSoYouKnowLabel setText:@"Say cheese!"];
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
    [self.view addSubview:justSoYouKnowDetails];
    
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"Let's picture" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:104.0/255.0 green:137.0/255.0 blue:179.0/255.0 alpha:1.0]];
    loginButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [loginButton sizeToFit];
    [loginButton addTarget:self action:@selector(onSubmit:) forControlEvents:UIControlEventTouchUpInside];
    CGRect loginFrame = loginButton.frame;
    loginFrame.origin.y =justSoYouKnowDetails.frame.origin.y + justSoYouKnowDetails.frame.size.height + 30;
    loginFrame.origin.x = 0;
    loginFrame.size.width = self.view.bounds.size.width/2;
    loginFrame.size.height = 50;
    loginButton.frame = loginFrame;
    [self.view addSubview:loginButton];
    
    UIButton *skipButton = [[UIButton alloc] init];
    [skipButton setTitle:@"Skip this" forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [skipButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [skipButton setBackgroundColor: [UIColor whiteColor]];
    skipButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [skipButton addTarget:self action:@selector(onSkip:) forControlEvents:UIControlEventTouchUpInside];
    CGRect oldSchoolFrame = skipButton.frame;
    oldSchoolFrame.origin.y = loginFrame.origin.y;
    oldSchoolFrame.origin.x = self.view.bounds.size.width/2;
    oldSchoolFrame.size.width = self.view.bounds.size.width/2;
    oldSchoolFrame.size.height = 50;
    skipButton.frame = oldSchoolFrame;
    [self.view addSubview:skipButton];
    
}

-(IBAction)onSubmit:(id)sender {
    
}

-(IBAction)onSkip:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
