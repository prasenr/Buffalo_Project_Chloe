//
//  WeeklyDateItemRendererViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 5/2/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeeklyDateItemRendererViewController : UIViewController {
    
}
-(id)initWithDate:(NSDate *)dateToBe isToday:(BOOL)isTodayBoolean isSelectedDate:(BOOL)isSelectedDateBoolean initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(NSDate *)getItemDate;
-(void)changeSelectedDate:(NSDate *)newSelectedDate isToday:(BOOL)isTodayBoolean isSelectedDate:(BOOL)isSelectedDateBoolean;
@end
