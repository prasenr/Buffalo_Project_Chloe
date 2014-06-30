//
//  ToDoDateViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/10/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ToDoDateViewController.h"

@interface ToDoDateViewController ()

@end
static NSDateFormatter *dayFormatter = nil;
static NSDateFormatter *monthFormatter = nil;
static NSDateFormatter *yearFormatter = nil;
@implementation ToDoDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWtihToDo:(NSDate *)dateShowing initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dateShowing = dateShowing;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = 150;
    self.view.frame = viewFrame;
    self.view.backgroundColor = [UIColor clearColor];
    
    if(dayFormatter == nil) {
        dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat:@"dd"];
    }
    self.dateDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width, 100)];
    self.monthString = [[NSMutableAttributedString alloc] initWithString:[dayFormatter stringFromDate:self.dateShowing] attributes:
                        @{
                          NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:120],
                          NSKernAttributeName : @(-10.3f),
                          NSForegroundColorAttributeName :[UIColor whiteColor]
                          }];

    self.dateDayLabel.attributedText = self.monthString;
    [self.view addSubview:self.dateDayLabel];
    
    if(monthFormatter == nil) {
        monthFormatter = [[NSDateFormatter alloc] init];
        [monthFormatter setDateFormat:@"MMM"];
    }
    
    self.dateMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 95, self.view.bounds.size.width, 30)];
    self.dateMonthLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:30];
    self.dateMonthLabel.text = [monthFormatter stringFromDate:self.dateShowing].uppercaseString;
    self.dateMonthLabel.adjustsFontSizeToFitWidth = NO;
    self.dateMonthLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.dateMonthLabel];
    
    if(yearFormatter == nil) {
        yearFormatter = [[NSDateFormatter alloc] init];
        [yearFormatter setDateFormat:@"yyyy"];
    }
    
    self.dateYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 94, self.view.bounds.size.width, 30)];
    self.yearString = [[NSMutableAttributedString alloc] initWithString:[yearFormatter stringFromDate:self.dateShowing] attributes:
                        @{
                          NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:30],
                          NSKernAttributeName : @(-2.3f),
                          NSForegroundColorAttributeName :[UIColor whiteColor]
                          }];
    
    self.dateYearLabel.attributedText = self.yearString;
    [self.view addSubview:self.dateYearLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
