//
//  MoreOptionsViewController.h
//  Buffalo Project 2
//
//  Created by Christopher Fisher on 8/19/13.
//  Copyright (c) 2013 Christopher Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+PersonModel.h"

@interface MoreOptionsViewController : UIViewController {
    UIView *bg;
    UIButton *moreOptionsButton;
    UIButton *addContactButton;
    UIButton *findContactsButton;
    UISwipeGestureRecognizer *moreOptionsSwipeUp;
    UISwipeGestureRecognizer *moreOptionsSwipeDown;
}


@end
