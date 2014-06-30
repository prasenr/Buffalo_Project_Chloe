//
//  ToDoDateViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/10/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoDateViewController : UIViewController
@property(nonatomic, strong) NSDate *dateShowing;
@property(nonatomic, strong) UILabel *dateDayLabel;
@property(nonatomic, strong) UILabel *dateMonthLabel;
@property(nonatomic, strong) NSAttributedString *monthString;
@property(nonatomic, strong) UILabel *dateYearLabel;
@property(nonatomic, strong) NSAttributedString *yearString;
- (id)initWtihToDo:(NSDate *)dateShowing initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
