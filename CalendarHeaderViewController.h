//
//  CalendarHeaderViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 5/1/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarHeaderViewController : UIViewController <UIScrollViewDelegate> {
    UISwipeGestureRecognizer *calendarHeaderGestureLeft;
    UISwipeGestureRecognizer *calendarHeaderGestureRight;
    UISwipeGestureRecognizer *calendarHeaderGestureDown;
    
    UISwipeGestureRecognizer *calendarHeaderWeekGestureLeft;
    UISwipeGestureRecognizer *calendarHeaderWeekGestureRight;
    UISwipeGestureRecognizer *calendarHeaderWeekGestureDown;
    UISwipeGestureRecognizer *calendarHeaderWeekGestureUp;
    
    UISwipeGestureRecognizer *calendarHeaderMonthGestureLeft;
    UISwipeGestureRecognizer *calendarHeaderMonthGestureRight;
    UISwipeGestureRecognizer *calendarHeaderMonthGestureUp;
    
    UIGestureRecognizer *weekTap;
}
@end
