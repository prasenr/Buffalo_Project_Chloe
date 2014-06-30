//
//  ToDoEditorViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 5/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
#import "ToDoModel.h"
#import <MapBox/Mapbox.h>

@interface ToDoEditorViewController : UIViewController <CLLocationManagerDelegate, UIScrollViewDelegate, RMMapViewDelegate>
- (id)initWtihToDo:(ToDoModel *)todoItem initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end

