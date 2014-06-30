//
//  TodayViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/28/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
-(void)updateList;
@end
