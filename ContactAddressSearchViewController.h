//
//  ContactAddressSearchViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactAddressSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
-(id)initWithSearch:(NSString *)searchText initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
