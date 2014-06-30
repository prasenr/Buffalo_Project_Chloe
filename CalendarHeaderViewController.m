//
//  CalendarHeaderViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 5/1/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "CalendarHeaderViewController.h"
#import "WeeklyDateItemRendererViewController.h"

@interface CalendarHeaderViewController ()
@property (nonatomic, retain) NSDate *todayDate;
@property (nonatomic, retain) NSDate *selectedDate;
@property( nonatomic, strong) UIView *calendarBackground;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView *sevenDayContainer;
@property (nonatomic, strong) UIView *monthContainer;
@property (nonatomic, strong) NSCalendar *cal;
@property (nonatomic, strong) NSDateComponents *components;
@property (nonatomic, strong) NSMutableArray *weekArray;
@end

@implementation CalendarHeaderViewController

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
    
    self.todayDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    self.selectedDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    self.sevenDayContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 50)];
    
    
    /*self.cal = [NSCalendar currentCalendar];
    self.components = [self.cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:self.todayDate];
    
    //[self.components setHour:-[self.components hour]];
    //[self.components setMinute:-[self.components minute]];
    //[self.components setSecond:-[self.components second]];
    self.todayDate = [self.cal dateByAddingComponents:self.components toDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0] options:0];
    
    self.components = [self.cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:self.selectedDate];
    self.selectedDate = [self.cal dateByAddingComponents:self.components toDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0] options:0];*/
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.calendarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    
    [self.calendarBackground setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.calendarBackground];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 25)];
    self.headerLabel.backgroundColor = [UIColor clearColor];
    self.headerLabel.textColor = [UIColor blackColor];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:22];
    [self.calendarBackground addSubview:self.headerLabel];
    
    calendarHeaderGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderDaySwipeLeft:)];
    calendarHeaderGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    calendarHeaderGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderDaySwipeRight:)];
    calendarHeaderGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    calendarHeaderGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderDaySwipeDown:)];
    calendarHeaderGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.calendarBackground addGestureRecognizer:calendarHeaderGestureLeft];
    [self.calendarBackground addGestureRecognizer:calendarHeaderGestureRight];
    [self.calendarBackground addGestureRecognizer:calendarHeaderGestureDown];
    
    [self setHeaderWithFullDate];
}

-(IBAction)calendarHeaderDaySwipeLeft:(UIGestureRecognizer *)sender {

    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    
    self.selectedDate = [self.cal dateByAddingComponents:components toDate:self.selectedDate options:0];
    [self setHeaderWithFullDate];
}

-(IBAction)calendarHeaderDaySwipeRight:(UIGestureRecognizer *)sender {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    
    self.selectedDate = [self.cal dateByAddingComponents:components toDate:self.selectedDate options:0];
    [self setHeaderWithFullDate];
}

-(IBAction)calendarHeaderDaySwipeDown:(UIGestureRecognizer *)sender {
    
    CGRect backgroundTo = CGRectMake(0, 0, self.view.bounds.size.width, 150);
    int widthHeight = self.view.bounds.size.width/7;
    
    self.sevenDayContainer.backgroundColor = [UIColor clearColor];
    [self.calendarBackground addSubview:self.sevenDayContainer];
    
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:self.selectedDate];
    
    self.selectedDate = [calendar dateFromComponents:comps];
    self.todayDate = [calendar dateFromComponents:comps];
    
    [comps setWeekday:1]; // 2: monday
    NSDate *sundayDate = [calendar dateFromComponents:comps];
    [comps setWeekday:2]; // 2: monday
    NSDate *mondayDate = [calendar dateFromComponents:comps];
    [comps setWeekday:3]; // 2: monday
    NSDate *tuesdayDate = [calendar dateFromComponents:comps];
    [comps setWeekday:4]; // 2: monday
    NSDate *wednesdayDate = [calendar dateFromComponents:comps];
    [comps setWeekday:5]; // 2: monday
    NSDate *thursdayDate = [calendar dateFromComponents:comps];
    [comps setWeekday:6]; // 2: monday
    NSDate *fridayDate = [calendar dateFromComponents:comps];
    [comps setWeekday:7]; // 7: saturday
    NSDate *saturdayDate = [calendar dateFromComponents:comps];
    
    WeeklyDateItemRendererViewController *sundayLabel = [[WeeklyDateItemRendererViewController alloc] initWithDate:sundayDate isToday:[sundayDate isEqualToDate:self.todayDate] isSelectedDate:[sundayDate isEqualToDate:self.todayDate] initWithNibName:@"WeeklyDateItemRendererViewController" bundle:nil];
    sundayLabel.view.frame = CGRectMake(0, 0, widthHeight, widthHeight);
    [self.weekArray addObject:sundayLabel];
    [self.sevenDayContainer addSubview:sundayLabel.view];
    
    WeeklyDateItemRendererViewController *mondayLabel = [[WeeklyDateItemRendererViewController alloc] initWithDate:mondayDate isToday:[mondayDate isEqualToDate: self.todayDate] isSelectedDate:[mondayDate isEqualToDate: self.selectedDate] initWithNibName:@"WeeklyDateItemRendererViewController" bundle:nil];
    mondayLabel.view.frame = CGRectMake(widthHeight, 0, widthHeight, widthHeight);
    [self.weekArray addObject:mondayLabel];
    [self.sevenDayContainer addSubview:mondayLabel.view];
    
    WeeklyDateItemRendererViewController *tuesdayLabel = [[WeeklyDateItemRendererViewController alloc] initWithDate:tuesdayDate isToday:[tuesdayDate isEqualToDate: self.todayDate] isSelectedDate:[tuesdayDate isEqualToDate: self.selectedDate] initWithNibName:@"WeeklyDateItemRendererViewController" bundle:nil];
    tuesdayLabel.view.frame = CGRectMake(widthHeight*2, 0, widthHeight, widthHeight);
    [self.weekArray addObject:tuesdayLabel];
    [self.sevenDayContainer addSubview:tuesdayLabel.view];
    
    WeeklyDateItemRendererViewController *wednesdayLabel = [[WeeklyDateItemRendererViewController alloc] initWithDate:wednesdayDate isToday:[wednesdayDate isEqualToDate: self.todayDate] isSelectedDate:[wednesdayDate isEqualToDate: self.selectedDate] initWithNibName:@"WeeklyDateItemRendererViewController" bundle:nil];
    wednesdayLabel.view.frame = CGRectMake(widthHeight*3, 0, widthHeight, widthHeight);
    [self.weekArray addObject:wednesdayLabel];
    [self.sevenDayContainer addSubview:wednesdayLabel.view];
    
    WeeklyDateItemRendererViewController *thursdayLabel = [[WeeklyDateItemRendererViewController alloc] initWithDate:thursdayDate isToday:[thursdayDate isEqualToDate: self.todayDate] isSelectedDate:[thursdayDate isEqualToDate: self.selectedDate] initWithNibName:@"WeeklyDateItemRendererViewController" bundle:nil];
    thursdayLabel.view.frame = CGRectMake(widthHeight*4, 0, widthHeight, widthHeight);
    [self.weekArray addObject:thursdayLabel];
    [self.sevenDayContainer addSubview:thursdayLabel.view];
    
    WeeklyDateItemRendererViewController *fridayLabel = [[WeeklyDateItemRendererViewController alloc] initWithDate:fridayDate isToday:[fridayDate isEqualToDate: self.todayDate] isSelectedDate:[fridayDate isEqualToDate: self.selectedDate] initWithNibName:@"WeeklyDateItemRendererViewController" bundle:nil];
    fridayLabel.view.frame = CGRectMake(widthHeight*5, 0, widthHeight, widthHeight);
    [self.weekArray addObject:fridayLabel];
    [self.sevenDayContainer addSubview:fridayLabel.view];
    
    WeeklyDateItemRendererViewController *saturdayLabel = [[WeeklyDateItemRendererViewController alloc] initWithDate:saturdayDate isToday:[saturdayDate isEqualToDate: self.todayDate] isSelectedDate:[saturdayDate isEqualToDate: self.selectedDate] initWithNibName:@"WeeklyDateItemRendererViewController" bundle:nil];
    saturdayLabel.view.frame = CGRectMake(widthHeight*6, 0, widthHeight, widthHeight);
    [self.weekArray addObject:saturdayLabel];
    [self.sevenDayContainer addSubview:saturdayLabel.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weekdaySelected:) name:@"dateClickedFromWeek" object:nil];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(weekHeaderShowing:finished:context:)];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.calendarBackground.frame = backgroundTo;
    [UIView commitAnimations];
}

-(IBAction)calendarHeaderWeekSwipeLeft:(UIGestureRecognizer *)sender {
    
}

-(IBAction)calendarHeaderWeekSwipeRight:(UIGestureRecognizer *)sender {
    
}

-(IBAction)calendarHeaderWeekSwipeDown:(UIGestureRecognizer *)sender {
    CGRect backgroundTo = CGRectMake(0, 0, self.view.bounds.size.width, 300);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(monthHeaderShowing:finished:context:)];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.calendarBackground.frame = backgroundTo;
    [UIView commitAnimations];
}

-(IBAction)calendarHeaderWeekSwipeUp:(UIGestureRecognizer *)sender {
    CGRect backgroundTo = CGRectMake(0, 0, self.view.bounds.size.width, 60);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dayHeaderShowing:finished:context:)];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.calendarBackground.frame = backgroundTo;
    [UIView commitAnimations];
}

-(IBAction)calendarHeaderMonthSwipeLeft:(UIGestureRecognizer *)sender {
    
}

-(IBAction)calendarHeaderMonthSwipeRight:(UIGestureRecognizer *)sender {
    
}

-(IBAction)calendarHeaderMonthSwipeUp:(UIGestureRecognizer *)sender {
    CGRect backgroundTo = CGRectMake(0, 0, self.view.bounds.size.width, 150);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(weekHeaderShowing:finished:context:)];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.calendarBackground.frame = backgroundTo;
    [UIView commitAnimations];
}

-(void)dayHeaderShowing:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    
    [self.calendarBackground removeGestureRecognizer:calendarHeaderWeekGestureLeft];
    [self.calendarBackground removeGestureRecognizer:calendarHeaderWeekGestureRight];
    [self.calendarBackground removeGestureRecognizer:calendarHeaderWeekGestureUp];
    [self.calendarBackground removeGestureRecognizer:calendarHeaderWeekGestureDown];
    
    calendarHeaderGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderDaySwipeLeft:)];
    calendarHeaderGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    calendarHeaderGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderDaySwipeRight:)];
    calendarHeaderGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    calendarHeaderGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderDaySwipeDown:)];
    calendarHeaderGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.calendarBackground addGestureRecognizer:calendarHeaderGestureLeft];
    [self.calendarBackground addGestureRecognizer:calendarHeaderGestureRight];
    [self.calendarBackground addGestureRecognizer:calendarHeaderGestureDown];
}


-(void)weekHeaderShowing:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    
    [self.calendarBackground removeGestureRecognizer:calendarHeaderGestureLeft];
    [self.calendarBackground removeGestureRecognizer:calendarHeaderGestureRight];
    [self.calendarBackground removeGestureRecognizer:calendarHeaderGestureDown];
    
    calendarHeaderWeekGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderWeekSwipeLeft:)];
    calendarHeaderWeekGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    calendarHeaderWeekGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderWeekSwipeRight:)];
    calendarHeaderWeekGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    calendarHeaderWeekGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderWeekSwipeDown:)];
    calendarHeaderWeekGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    calendarHeaderWeekGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderWeekSwipeUp:)];
    calendarHeaderWeekGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    //[self.calendarBackground addGestureRecognizer:calendarHeaderWeekGestureLeft];
    //[self.calendarBackground addGestureRecognizer:calendarHeaderWeekGestureRight];
    //[self.calendarBackground addGestureRecognizer:calendarHeaderWeekGestureUp];
    //[self.calendarBackground addGestureRecognizer:calendarHeaderWeekGestureDown];
    
}

-(void)monthHeaderShowing:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context {
    
    [self.calendarBackground removeGestureRecognizer:calendarHeaderWeekGestureLeft];
    [self.calendarBackground removeGestureRecognizer:calendarHeaderWeekGestureRight];
    [self.calendarBackground removeGestureRecognizer:calendarHeaderWeekGestureUp];
    [self.calendarBackground removeGestureRecognizer:calendarHeaderWeekGestureDown];
    
    calendarHeaderMonthGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderMonthSwipeLeft:)];
    calendarHeaderMonthGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    calendarHeaderMonthGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderMonthSwipeRight:)];
    calendarHeaderMonthGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    calendarHeaderMonthGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(calendarHeaderMonthSwipeUp:)];
    calendarHeaderMonthGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    [self.calendarBackground addGestureRecognizer:calendarHeaderMonthGestureLeft];
    [self.calendarBackground addGestureRecognizer:calendarHeaderMonthGestureRight];
    [self.calendarBackground addGestureRecognizer:calendarHeaderMonthGestureUp];
}


-(void) setHeaderWithFullDate {
    //NSLog(@"value: %@",self.selectedDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm";
    
    NSTimeZone *timezone = [NSTimeZone timeZoneWithAbbreviation:@"CT"];
    [dateFormatter setTimeZone:timezone];
    NSString *timeStamp = [dateFormatter stringFromDate:self.selectedDate];
    NSMutableArray *monthArray = [NSMutableArray array];
    [monthArray addObject:@""];
    [monthArray addObject:@"January"];
    [monthArray addObject:@"February"];
    [monthArray addObject:@"March"];
    [monthArray addObject:@"April"];
    [monthArray addObject:@"May"];
    [monthArray addObject:@"June"];
    [monthArray addObject:@"July"];
    [monthArray addObject:@"August"];
    [monthArray addObject:@"September"];
    [monthArray addObject:@"October"];
    [monthArray addObject:@"November"];
    [monthArray addObject:@"December"];
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:self.selectedDate];
    
    [dateFormatter setDateFormat:@"MMM"];
    NSString *month = [dateFormatter stringFromDate:self.selectedDate];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:self.selectedDate];
    
    NSString *currentDateString = [NSString stringWithFormat:@"%@ %@, %@", month, day, year];
    
    self.headerLabel.text = currentDateString;
}

-(void) setHeaderWithMonthYear{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSMutableArray *monthArray = [NSMutableArray array];
    [monthArray addObject:@""];
    [monthArray addObject:@"January"];
    [monthArray addObject:@"February"];
    [monthArray addObject:@"March"];
    [monthArray addObject:@"April"];
    [monthArray addObject:@"May"];
    [monthArray addObject:@"June"];
    [monthArray addObject:@"July"];
    [monthArray addObject:@"August"];
    [monthArray addObject:@"September"];
    [monthArray addObject:@"October"];
    [monthArray addObject:@"November"];
    [monthArray addObject:@"December"];
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:self.selectedDate];
    
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [monthArray objectAtIndex: [[dateFormatter stringFromDate:self.selectedDate] intValue]];

    
    NSString *currentDateString = [NSString stringWithFormat:@"%@ %@", month, year];
    
    self.headerLabel.text = currentDateString;
}

-(void) weekdaySelected:(NSNotification *)notification {
    self.selectedDate = [[notification userInfo] valueForKey:@"dateSelected"];
    for (WeeklyDateItemRendererViewController *aDay in self.weekArray) {
        [aDay changeSelectedDate:[NSDate alloc] isToday:[[aDay getItemDate] isEqualToDate:self.todayDate] isSelectedDate:[[aDay getItemDate] isEqualToDate:self.selectedDate]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
