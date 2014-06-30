//
//  ToDoListViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/11/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
-(void)setViewDate:(NSDate *)dateToUse;
@end
