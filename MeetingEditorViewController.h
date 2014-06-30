//
//  MeetingEditorViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/5/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+TodaySummaryListItems.h"
#import <MapBox/Mapbox.h>

@interface MeetingEditorViewController : UIViewController <CLLocationManagerDelegate, UIScrollViewDelegate, RMMapViewDelegate>
- (id)initWtihMeeting:(TodaySummaryListItems *)meetingItem initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
