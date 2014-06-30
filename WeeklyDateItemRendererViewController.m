//
//  WeeklyDateItemRendererViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 5/2/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "WeeklyDateItemRendererViewController.h"

@interface WeeklyDateItemRendererViewController () {
    NSDate *itemDate;
    UILabel *dateLabel;
}
@property (nonatomic, strong) NSCalendar *cal;
@property (nonatomic, retain) NSDate *cellDate;
@property (nonatomic, assign) BOOL isToday1;
@property (nonatomic, assign) BOOL isSelectedDate1;
@end


@implementation WeeklyDateItemRendererViewController


-(id)initWithDate:(NSDate *)dateToBe isToday:(BOOL)isTodayBoolean isSelectedDate:(BOOL)isSelectedDateBoolean initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    self = [super init];
    if (self) {
        itemDate = dateToBe;
        self.isToday1 = isTodayBoolean;
        self.isSelectedDate1 = isSelectedDateBoolean;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor clearColor];
    
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    dateLabel.text = [dateFormatter stringFromDate:itemDate];
    
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:22];
    dateLabel.backgroundColor = [UIColor whiteColor];
    
    if(self.isToday1) {
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.font = [UIFont fontWithName:@"Colaborate-Medium" size:22];
        dateLabel.backgroundColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:255.0f/255.0f];
    }
    
    if(self.isSelectedDate1) {
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:22];
        dateLabel.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:79.0f/255.0f blue:14.0f/255.0f alpha:255.0f/255.0f];
    }
    
    dateLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:dateLabel];
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    clearButton.backgroundColor = [UIColor redColor];
    clearButton.alpha = 0.5;
    //clearButton.hidden = YES;
    [self.view addSubview:clearButton];
    [clearButton addTarget:self action:@selector(onDateSelected:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDate *)getItemDate {
    return itemDate;
}

-(void)changeSelectedDate:(NSDate *)newSelectedDate isToday:(BOOL)isTodayBoolean isSelectedDate:(BOOL)isSelectedDateBoolean {
    if(isTodayBoolean) {
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.font = [UIFont fontWithName:@"Colaborate-Medium" size:22];
        dateLabel.backgroundColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:255.0f/255.0f];
    }
    
    if(isSelectedDateBoolean) {
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:22];
        dateLabel.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:79.0f/255.0f blue:14.0f/255.0f alpha:255.0f/255.0f];
    }
}

-(void)onDateSelected:(id)sender {
    NSDictionary *dateInfo = [NSDictionary dictionaryWithObject:itemDate forKey:@"dateSelected"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dateClickedFromWeek" object:nil userInfo:dateInfo];
}

@end

