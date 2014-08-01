//
//  MeetingsViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "MeetingsViewController.h"
#import "NSObject+MeetingModel.h"
#import "NSObject+TodaySummary_Controller.h"

@interface MeetingsViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *noAccountView;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) NSMutableAttributedString *detailAttributedString;
@end

static NSDateFormatter *dateFormatter = nil;
@implementation MeetingsViewController

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
    
    UILabel *contactsHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 50)];
    contactsHeader.backgroundColor = [UIColor clearColor];
    contactsHeader.textColor = [UIColor blackColor];
    contactsHeader.text = @"Meetings";
    contactsHeader.textAlignment = NSTextAlignmentCenter;
    contactsHeader.font = [UIFont fontWithName:@"Colaborate-Thin" size:20];;
    [self.view addSubview:contactsHeader];
    
    if([[TodaySummary_Controller sharedManager].allMeetingsSorted count]>0) {
        [self createTableView];
    } else {
        [self createNoAccountsView];
    }
    
}

-(void)createNoAccountsView {
    
    self.noAccountView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.noAccountView];
    self.noAccountView.backgroundColor = [UIColor clearColor];
    
    CGSize maxiToDoMeetingSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    
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
    newFrame1.origin.y = 100;
    newFrame1.size.width = expectedLabelSize1.size.width;
    newFrame1.size.height = expectedLabelSize1.size.height;
    justSoYouKnowDetails.frame = newFrame1;
    [self.noAccountView addSubview:justSoYouKnowDetails];
    
    UIButton *getProfilePictureButton = [[UIButton alloc] init];
    [getProfilePictureButton setTitle:@"Add an account" forState:UIControlStateNormal];
    getProfilePictureButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [getProfilePictureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getProfilePictureButton setBackgroundColor:[UIColor colorWithRed:104.0/255.0 green:137.0/255.0 blue:179.0/255.0 alpha:1.0]];
    getProfilePictureButton.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [getProfilePictureButton sizeToFit];
    [getProfilePictureButton addTarget:self action:@selector(onAddAnAccount:) forControlEvents:UIControlEventTouchUpInside];
    CGRect getProfilePictureFrame = getProfilePictureButton.frame;
    getProfilePictureFrame.origin.y =justSoYouKnowDetails.frame.origin.y + justSoYouKnowDetails.frame.size.height + 30;
    getProfilePictureFrame.origin.x = 0;
    getProfilePictureFrame.size.width = self.view.bounds.size.width/2;
    getProfilePictureFrame.size.height = 50;
    getProfilePictureButton.frame = getProfilePictureFrame;
    [self.noAccountView addSubview:getProfilePictureButton];
    
    UIButton *skipPickProfilePicture = [[UIButton alloc] init];
    [skipPickProfilePicture setTitle:@"Add a meeting" forState:UIControlStateNormal];
    skipPickProfilePicture.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    [skipPickProfilePicture setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [skipPickProfilePicture setBackgroundColor: [UIColor whiteColor]];
    skipPickProfilePicture.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [skipPickProfilePicture addTarget:self action:@selector(onAddAMeeting:) forControlEvents:UIControlEventTouchUpInside];
    CGRect skipPickProfilePictureFrame = skipPickProfilePicture.frame;
    skipPickProfilePictureFrame.origin.y = getProfilePictureFrame.origin.y;
    skipPickProfilePictureFrame.origin.x = self.view.bounds.size.width/2;
    skipPickProfilePictureFrame.size.width = self.view.bounds.size.width/2;
    skipPickProfilePictureFrame.size.height = 50;
    skipPickProfilePicture.frame = skipPickProfilePictureFrame;
    [self.noAccountView addSubview:skipPickProfilePicture];
}

-(IBAction)onAddAnAccount:(id)sender {
    
}

-(IBAction)onAddAMeeting:(id)sender {
    
}

-(void)createTableView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view from its nib.
    
    
    
    self.calendarHeader = [[CalendarHeaderViewController alloc] init];
    [self.view addSubview:self.calendarHeader.view];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        self.startTimeLabel = [[UILabel alloc] init];
        self.endTimeLabel = [[UILabel alloc] init];
        self.detailTextLabel = [[UILabel alloc] init];
        
        self.startTimeLabel.textColor = [UIColor whiteColor];
        self.startTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:30];
        self.startTimeLabel.adjustsFontSizeToFitWidth = NO;
        self.startTimeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.startTimeLabel.textAlignment = NSTextAlignmentRight;
        
        self.endTimeLabel.textColor = [UIColor whiteColor];
        self.endTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        self.endTimeLabel.adjustsFontSizeToFitWidth = NO;
        self.endTimeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.endTimeLabel.textAlignment = NSTextAlignmentRight;
        
        
        self.detailTextLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:16];
        
        self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.detailTextLabel.numberOfLines = 0;
        [self.detailTextLabel sizeToFit];
        
        [cell.contentView addSubview:self.startTimeLabel];
        [cell.contentView addSubview:self.endTimeLabel];
        [cell.contentView addSubview:self.detailTextLabel];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    if(dateFormatter == nil){
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mma"];
    }
    
    CGRect detailFrame = self.detailTextLabel.frame;
    
    NSString *todayString = [dateFormatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0]];
    
    MeetingModel *cellData = [[[TodaySummary_Controller sharedManager].allMeetingsSorted valueForKey:todayString] objectAtIndex:indexPath.row];
    self.startTimeLabel.frame = CGRectMake(10, 10, 110, 30);
    self.startTimeLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:cellData.startDate]];
    self.endTimeLabel.frame = CGRectMake(10, (self.startTimeLabel.frame.origin.y + self.startTimeLabel.frame.size.height) - 5, 110, 20);
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:cellData.endDate]];
    self.detailTextLabel.frame = CGRectMake(20, 40, self.view.frame.size.width - 40, 100);
    
    if(self.detailAttributedString){
        self.detailTextLabel.attributedText = nil;
        self.detailTextLabel.alpha = 1.0;
        self.startTimeLabel.alpha = 1.0;
        self.endTimeLabel.alpha = 1.0;
    }
    self.detailTextLabel.text = cellData.meetingDescription;
    
    CGSize maxDetailLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    CGRect expectedDetailLabelSize = [self.detailTextLabel.text boundingRectWithSize:CGSizeMake(maxDetailLabelSize.width, maxDetailLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.detailTextLabel.font} context:nil];
    
    self.detailTextLabel.frame = expectedDetailLabelSize;
    
    detailFrame = self.detailTextLabel.frame;
    detailFrame.origin.y = 52;
    detailFrame.origin.x = 20;
    self.detailTextLabel.frame = detailFrame;
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MeetingModel *cellData = [[TodaySummary_Controller sharedManager].rawMeetings objectAtIndex:indexPath.row];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:cellData forKey:@"meeting"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editMeeting" object:nil userInfo:userInfo];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: Need to determine height;
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *textString;
    CGRect expectedDetailLabelSize;
    
        MeetingModel *cellData = [[TodaySummary_Controller sharedManager].rawMeetings objectAtIndex:indexPath.row];
        textString = cellData.meetingDescription;
        CGSize maxDetailLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
        expectedDetailLabelSize = [textString boundingRectWithSize:CGSizeMake(maxDetailLabelSize.width, maxDetailLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Colaborate-Thin" size:16]} context:nil];
        expectedDetailLabelSize.size.height += 52;
        
        expectedDetailLabelSize.size.height += 30;
        return expectedDetailLabelSize.size.height;
}

/*- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
 }*/

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[TodaySummary_Controller sharedManager].rawMeetings count];
}

-(void)updateMeetings {
    if([[TodaySummary_Controller sharedManager].allMeetingsSorted count] >0) {
        if(self.tableView == nil) {
            [self createTableView];
            self.tableView.alpha = 0;
            [self.tableView reloadData];
            [UIView animateWithDuration:0.25
                                  delay: 0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.tableView.alpha = 1;
                                 self.noAccountView.alpha = 0;
                                 
                             }completion:^(BOOL finished){
                                 [self.noAccountView removeFromSuperview];
                                 self.noAccountView = nil;
                             }];
        } else {
            [self.tableView reloadData];
        }
        
    } else {
        if(self.noAccountView == nil) {
            [self createNoAccountsView];
            if(self.tableView) {
                [UIView animateWithDuration:0.25
                                      delay: 0.0
                                    options: UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     self.tableView.alpha = 0;
                                     self.noAccountView.alpha = 1;
                                     
                                 }completion:^(BOOL finished){
                                     [self.tableView removeFromSuperview];
                                     self.tableView = nil;
                                 }];
            } else {
                [UIView animateWithDuration:0.25
                                      delay: 0.0
                                    options: UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     self.noAccountView.alpha = 1;
                                     
                                 }completion:^(BOOL finished){}];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
