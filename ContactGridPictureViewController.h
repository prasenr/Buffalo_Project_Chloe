//
//  ContactGridPictureViewController.h
//  Buffalo Project 2
//
//  Created by Christopher Fisher on 8/15/13.
//  Copyright (c) 2013 Christopher Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+PersonModel.h"

@interface ContactGridPictureViewController : UIView {
    PersonModel *personModel;
    NSString *personPath;
    UIButton *button;
}
-(id)initWithPerson:(PersonModel *)person initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void)removeClickListener;
-(void)addClickListner;
@property (assign) BOOL isSearch;
@end
