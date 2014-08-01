//
//  TodayViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/28/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "TodayViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "NSObject+WeatherController.h"
#import "NSObject+TodaySummary_Controller.h"
#import "NSObject+TodaySummaryListItems.h"
#import "MeetingsController.h"
#import "NSObject+MeetingModel.h"
#import "ToDoController.h"
#import "ToDoModel.h"
#import <QuartzCore/QuartzCore.h>

@interface TodayViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *summaryBlurBackground;
@property (nonatomic, strong) UILabel *justSoYouKnowLabel;
@property (nonatomic, strong) UILabel *justSoYouKnowDetails;

@property (nonatomic, strong) UILabel *todoMeetingSummaryLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UILabel *conditionsLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) NSTimer* weatherTimer;
@property (nonatomic, strong) UITapGestureRecognizer *singleFingerTap;
@property (nonatomic, assign) BOOL isWeatherLoaded;
@property (nonatomic, assign) BOOL isTodaySummaryLoaded;
@property (nonatomic, assign) BOOL isTodaySummaryListLoaded;
@property (nonatomic, assign) BOOL isFirstLaunch;
@property (nonatomic, assign) BOOL isBackgroundLoaded;
@property (nonatomic, assign) BOOL isTodayShowing;

@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) NSMutableAttributedString *detailAttributedString;

@end

static NSDateFormatter *dateFormatter = nil;
@implementation TodayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isWeatherLoaded = NO;
        self.isTodaySummaryLoaded = NO;
        self.isTodaySummaryListLoaded = NO;
        self.isFirstLaunch = YES;
        self.isBackgroundLoaded = NO;
        self.isTodayShowing = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.view.backgroundColor = [[UIColor alloc] initWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    
    // UIImage *background = [UIImage imageNamed:@"fall.jpg"];
    
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.alpha = 0;
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.view addSubview:self.blurredImageView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alpha = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.hidden = TRUE;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.summaryBlurBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.summaryBlurBackground.alpha = 0;
    self.summaryBlurBackground.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.summaryBlurBackground];
    
    [self createJustSoYouKnowLabel];
    [self createJustSoYouKnowDetail];
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    
    CGFloat inset = 20.0;
    
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    
    
    CGRect temperatureFrame = CGRectMake(inset, headerFrame.size.height - (temperatureHeight + hiloHeight), headerFrame.size.width - (2 * inset), temperatureHeight);
    
    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - (iconHeight - 10), iconHeight, iconHeight);
    
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
    conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    self.todoMeetingSummaryLabel = [[UILabel alloc] init];
    self.todoMeetingSummaryLabel.backgroundColor = [UIColor clearColor];
    self.todoMeetingSummaryLabel.textColor = [UIColor whiteColor];
    self.todoMeetingSummaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.todoMeetingSummaryLabel.numberOfLines = 0;
    self.todoMeetingSummaryLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:18];
    
    CGSize maxiToDoMeetingSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
    CGRect expectedLabelSize1 = [self.todoMeetingSummaryLabel.text boundingRectWithSize:maxiToDoMeetingSummaryLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.todoMeetingSummaryLabel.font} context:nil];
    
    
    CGRect newFrame = self.todoMeetingSummaryLabel.frame;
    newFrame.size.height = expectedLabelSize1.size.height;
    self.todoMeetingSummaryLabel.frame = newFrame;
    
    [header addSubview:self.todoMeetingSummaryLabel];
    
    self.temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    self.temperatureLabel.backgroundColor = [UIColor clearColor];
    self.temperatureLabel.textColor = [UIColor whiteColor];
    self.temperatureLabel.text = @"0";
    UIFont *myFont = [UIFont fontWithName:@"Colaborate-Thin" size:120];
    self.temperatureLabel.font = myFont;
    [header addSubview:self.temperatureLabel];
    
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.text = @"Loading ...";
    self.cityLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:6];
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:self.cityLabel];
    
    self.conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    self.conditionsLabel.backgroundColor = [UIColor clearColor];
    self.conditionsLabel.textColor = [UIColor whiteColor];
    self.conditionsLabel.font =[UIFont fontWithName:@"Colaborate-Thin" size:18];
    [header addSubview:self.conditionsLabel];
    
    self.iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.backgroundColor = [UIColor clearColor];
    [header addSubview:self.iconView];
    
}

-(void)fetchWeather {
    [[RACObserve([WeatherController sharedManager], currentCondition)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(WeatherCondition *newCondition) {
         self.temperatureLabel.text = [NSString stringWithFormat:@"%.0f°", newCondition.temperature.floatValue];
         self.conditionsLabel.text = [newCondition.conditionDescription[0] capitalizedString];
         self.cityLabel.alpha = 0;
         self.iconView.image = [UIImage imageNamed: [newCondition imageName]];
         [self setTodayLayout];
         self.isWeatherLoaded = YES;
         
         [self isReadyToLaunch];
     }];
    
    [[WeatherController sharedManager] findCurrentLocation];
    
    [[RACObserve([TodaySummary_Controller sharedManager], currentTodaySummary)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(TodaySummaryItems *newTodaySummary) {
         [self.justSoYouKnowLabel setText:@"Just so you know"];
         [self.justSoYouKnowDetails setText:newTodaySummary.whatWeDid];
         
         CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
         CGRect expectedLabelSize = [self.justSoYouKnowDetails.text boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.justSoYouKnowDetails.font} context:nil];
         CGRect newFrame = self.justSoYouKnowDetails.frame;
         newFrame.size.height = expectedLabelSize.size.height;
         newFrame.size.width = expectedLabelSize.size.width;
         newFrame.origin.y = self.justSoYouKnowLabel.frame.origin.y + 17;
         self.justSoYouKnowDetails.frame = newFrame;
         
         [self.todoMeetingSummaryLabel setText:newTodaySummary.todosMeetingSummary];
         NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:newTodaySummary.weatherImagePath]];
         UIImage* image = [[UIImage alloc] initWithData:imageData];
         [self setTodayLayout];
         [self performSelectorOnMainThread:@selector(backgroundImageLoaded:) withObject:image waitUntilDone:YES];
         self.isTodaySummaryLoaded = YES;
         [self isReadyToLaunch];
     }];
    
     [[TodaySummary_Controller sharedManager] fetchTodaySummary];
}

-(void)fetchTodosAndMeetings {

    
    
    [[RACObserve([TodaySummary_Controller sharedManager], todaySummaryListItems)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSMutableArray *newTodaySummaryListItem) {
         [self.tableView reloadData];
         self.isTodaySummaryListLoaded = YES;
         [self isReadyToLaunch];
     }];
    
    [[RACObserve([MeetingsController sharedManager], meetings)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSMutableArray *newMeetings) {
         [self.tableView reloadData];
         [[TodaySummary_Controller sharedManager] addMeetings:newMeetings];
     }];
    
    [[RACObserve([ToDoController sharedManager], todos)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSMutableArray *newToDos) {
         [self.tableView reloadData];
         [[TodaySummary_Controller sharedManager] addToDos:newToDos];
     }];
    
   
    [[MeetingsController sharedManager] fetchMeetings];
    [[ToDoController sharedManager] fetchToDos];
    
    //The event handling method
    
    
}

-(void)backgroundImageLoaded:(UIImage *)image {
    
    if(image){
        [self.backgroundImageView setImage:image];
        [self.blurredImageView setImageToBlur:image blurRadius:10 completionBlock:nil];
        self.isBackgroundLoaded = YES;
        [self isReadyToLaunch];
    }
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    [self showToday];
}

-(void) weatherTimerFired:(NSTimer*)timer {
    
    [self showToday];
}

-(void) showToday {
    
    if(!self.isTodayShowing) {
        self.isTodayShowing = YES;
        [self.weatherTimer invalidate];
        self.weatherTimer = nil;
        while ([self.view.gestureRecognizers count] > 0) {
            [self.view removeGestureRecognizer:[self.view.gestureRecognizers objectAtIndex:0]];
        }
        
        [self.view addSubview: self.tableView];
        self.tableView.hidden = FALSE;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.justSoYouKnowLabel.alpha = 0;
        self.justSoYouKnowDetails.alpha = 0;
        self.tableView.alpha = 1;
        self.summaryBlurBackground.alpha = 0;
        [UIView commitAnimations];
    }
}

-(void) createJustSoYouKnowLabel {
    NSString *myText = @"";
    
    CGRect labelFrame = CGRectMake(25, 240, self.view.frame.size.width - 25, 18);
    self.justSoYouKnowLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [self.justSoYouKnowLabel setFont:[UIFont fontWithName:@"Colaborate-Medium" size:18]];
    [self.justSoYouKnowLabel setText:myText];
    [self.justSoYouKnowLabel setTextColor:[UIColor whiteColor]];
    [self.justSoYouKnowLabel setBackgroundColor:[UIColor clearColor]];
    self.justSoYouKnowLabel.alpha = 0;
    [self.view addSubview:self.justSoYouKnowLabel];
}

-(void) createJustSoYouKnowDetail {
    NSString *myText = @"";
    unichar chr[1] = {'\n'};
    NSString *cr = [NSString stringWithCharacters:(const unichar *)chr length:1];
    CGRect labelFrame = CGRectMake(25, 70, self.view.frame.size.width - 50, 500);
    self.justSoYouKnowDetails = [[UILabel alloc] initWithFrame:labelFrame];
    [self.justSoYouKnowDetails setFont:[UIFont fontWithName:@"Colaborate-Thin" size:17]];
    [self.justSoYouKnowDetails setText: [NSString stringWithFormat:myText, cr]];
    [self.justSoYouKnowDetails setTextColor:[UIColor whiteColor]];
    [self.justSoYouKnowDetails setBackgroundColor:[UIColor clearColor]];
    [self.justSoYouKnowDetails setLineBreakMode:NSLineBreakByWordWrapping];
    [self.justSoYouKnowDetails setNumberOfLines:0];
    self.justSoYouKnowDetails.alpha = 0;
    [self.view addSubview:self.justSoYouKnowDetails];
}

-(void) setTodayLayout {
    
    CGSize maxiToDoMeetingSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
    CGRect expectedLabelSize = [self.todoMeetingSummaryLabel.text boundingRectWithSize:CGSizeMake(maxiToDoMeetingSummaryLabelSize.width, maxiToDoMeetingSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.todoMeetingSummaryLabel.font} context:nil ];
    
    CGRect newFrame = self.todoMeetingSummaryLabel.frame;
    newFrame.size.height = expectedLabelSize.size.height;
    newFrame.size.width = expectedLabelSize.size.width;
    newFrame.origin.x = 10;
    newFrame.origin.y = self.screenHeight - (newFrame.size.height + 10);
    self.todoMeetingSummaryLabel.frame = newFrame;
    
    CGSize maxTemperatureLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
    CGRect expectedTempLabelSize = [self.temperatureLabel.text boundingRectWithSize:CGSizeMake(maxTemperatureLabelSize.width, maxTemperatureLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.temperatureLabel.font} context:nil];
    
    CGRect temperatureFrame = self.temperatureLabel.frame;
    temperatureFrame.size.height = expectedTempLabelSize.size.height;
    temperatureFrame.size.width = expectedTempLabelSize.size.width;
    temperatureFrame.origin.x = 10;
    temperatureFrame.origin.y = newFrame.origin.y - (expectedTempLabelSize.size.height - 20);
    self.temperatureLabel.frame = temperatureFrame;
    
    CGFloat inset = 20.0;
    CGFloat iconHeight = 30;
    
    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - (iconHeight - 20), iconHeight, iconHeight);
    self.iconView.frame = iconFrame;;
    
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
    conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
    conditionsFrame.origin.y = iconFrame.origin.y + 7;
    self.conditionsLabel.frame = conditionsFrame;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[TodaySummary_Controller sharedManager].todaySummaryListItems count];
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
    
    CGRect detailFrame = self.detailTextLabel.frame;
    
    NSString *className = NSStringFromClass([[[TodaySummary_Controller sharedManager].todaySummaryListItems objectAtIndex:indexPath.row] class]);
    
    if(dateFormatter == nil){
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mma"];
    }

    if([className  isEqual: @"MeetingModel"]) {
        MeetingModel *cellData = [[TodaySummary_Controller sharedManager].todaySummaryListItems objectAtIndex:indexPath.row];
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
    } else {
        NSLog(@"make a todo");
        ToDoModel *cellData = [[TodaySummary_Controller sharedManager].todaySummaryListItems objectAtIndex:indexPath.row];
        if(cellData.startDate != [[NSDate alloc] initWithTimeIntervalSinceNow:0]) {
            self.endTimeLabel.frame = CGRectMake(10, 10, 110, 12);
            self.endTimeLabel.text = @"BY";
            self.startTimeLabel.frame = CGRectMake(10, (self.endTimeLabel.frame.origin.y + self.endTimeLabel.frame.size.height) - 2, 110, 30);
            self.startTimeLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:cellData.startDate]];
            self.detailTextLabel.frame = CGRectMake(20, 30, self.view.frame.size.width - 40, 100);
        } else {
            self.startTimeLabel.frame = CGRectMake(20, 10, 110, 30);
            self.startTimeLabel.textAlignment = NSTextAlignmentLeft;
            self.startTimeLabel.text = @"TODAY";
            self.detailTextLabel.frame = CGRectMake(20, 20, self.view.frame.size.width - 40, 100);
        }
        
        if(cellData.isComplete) {
            self.detailAttributedString = [[NSMutableAttributedString alloc] initWithString:cellData.todo];
            [self.detailAttributedString addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, [self.detailAttributedString length])];
            self.detailTextLabel.attributedText = self.detailAttributedString;
            self.detailTextLabel.alpha = 0.25;
            self.startTimeLabel.alpha = 0.25;
            self.endTimeLabel.alpha = 0.25;
        } else {
            if(self.detailAttributedString){
                self.detailTextLabel.attributedText = nil;
                self.detailTextLabel.alpha = 1.0;
                self.startTimeLabel.alpha = 1.0;
                self.endTimeLabel.alpha = 1.0;
            }
        }
        
        self.detailTextLabel.text = cellData.todo;
        
        CGSize maxDetailLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
        CGRect expectedDetailLabelSize = [self.detailTextLabel.text boundingRectWithSize:CGSizeMake(maxDetailLabelSize.width, maxDetailLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.detailTextLabel.font} context:nil];
        
        self.detailTextLabel.frame = expectedDetailLabelSize;
        
        detailFrame = self.detailTextLabel.frame;
        detailFrame.origin.y = 52;
        detailFrame.origin.x = 20;
        self.detailTextLabel.frame = detailFrame;
        
        if(cellData.startDate != [[NSDate alloc] initWithTimeIntervalSinceNow:0]) {
            
            detailFrame.origin.y = 48;
        } else {
            detailFrame.origin.y = 38;
        }
        self.detailTextLabel.frame = detailFrame;
    }
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *className = NSStringFromClass([[[TodaySummary_Controller sharedManager].todaySummaryListItems objectAtIndex:indexPath.row] class]);
    
    if([className  isEqual: @"MeetingModel"]) {
        MeetingModel *cellData = [[TodaySummary_Controller sharedManager].todaySummaryListItems objectAtIndex:indexPath.row];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:cellData forKey:@"meeting"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editMeeting" object:nil userInfo:userInfo];
    } else {
        ToDoModel *cellData = [[TodaySummary_Controller sharedManager].todaySummaryListItems objectAtIndex:indexPath.row];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:cellData forKey:@"todo"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editToDo" object:nil userInfo:userInfo];
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: Need to determine height;
    return 200;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    CGFloat bgPercent = MIN(position/ self.screenHeight, 1.0);
    self.blurredImageView.alpha = percent;
    self.summaryBlurBackground.alpha = 0.55*bgPercent;
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = NSStringFromClass([[[TodaySummary_Controller sharedManager].todaySummaryListItems objectAtIndex:indexPath.row] class]);
    
    NSString *textString;
    CGRect expectedDetailLabelSize;
    
    if([className  isEqual: @"MeetingModel"]) {
        MeetingModel *cellData = [[TodaySummary_Controller sharedManager].todaySummaryListItems objectAtIndex:indexPath.row];
        textString = cellData.meetingDescription;
        CGSize maxDetailLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
        expectedDetailLabelSize = [textString boundingRectWithSize:CGSizeMake(maxDetailLabelSize.width, maxDetailLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Colaborate-Thin" size:16]} context:nil];
        expectedDetailLabelSize.size.height += 52;
    } else {
        ToDoModel *cellData = [[TodaySummary_Controller sharedManager].todaySummaryListItems objectAtIndex:indexPath.row];
        textString = cellData.todo;
        CGSize maxDetailLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
        expectedDetailLabelSize = [textString boundingRectWithSize:CGSizeMake(maxDetailLabelSize.width, maxDetailLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Colaborate-Thin" size:16]} context:nil];
        if(cellData.startDate != [[NSDate alloc] initWithTimeIntervalSinceNow:0]) {
            expectedDetailLabelSize.size.height += 48;
        } else {
            expectedDetailLabelSize.size.height += 38;
        }
    }
    
    //For padding
    expectedDetailLabelSize.size.height += 30;
    return expectedDetailLabelSize.size.height;
}

-(void)updateList {
    [self.tableView reloadData];
}

-(void) isReadyToLaunch {
   // if(self.isWeatherLoaded == YES && self.isTodaySummaryLoaded == YES && self.isTodaySummaryListLoaded == YES && self.isFirstLaunch && YES && self.isBackgroundLoaded == YES) {
    if(self.isWeatherLoaded== YES && self.isBackgroundLoaded == YES) {
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(startWeatherTimer:finished:context:)];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.backgroundImageView.alpha = 1;
        self.justSoYouKnowDetails.alpha = 1;
        self.justSoYouKnowLabel.alpha = 1;
        self.summaryBlurBackground.alpha = 0.3;
        [UIView commitAnimations];
        
    }
}

-(void)startWeatherTimer:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    NSArray *spaceCount = [self.justSoYouKnowDetails.text componentsSeparatedByString:@" "];
    CGFloat timerTime = [spaceCount count]/2;
    
    if(timerTime<5) {
        timerTime = 5;
    }
    
    self.weatherTimer = [NSTimer scheduledTimerWithTimeInterval:timerTime target:self selector:@selector(weatherTimerFired:) userInfo:nil repeats:NO];
    
    //The setup code (in viewDidLoad in your view controller)
    NSLog(@"tap added");
    self.singleFingerTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:self.singleFingerTap];
    self.isFirstLaunch = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"todayIsShowing" object:nil userInfo:nil];
}



@end
