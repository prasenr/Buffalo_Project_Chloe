//
//  ContactGridViewController.h
//  Buffalo Project 2
//
//  Created by Christopher Fisher on 8/13/13.
//  Copyright (c) 2013 Christopher Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreOptionsViewController.h"
#import "SearchButton.h"
#import "NSObject+TodaySummary_Controller.h"


@interface ContactsViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate> {
    UIView *header;
    SearchButton *searchIconButton;
    SearchButton *addContactButton;
    UIView *searchHeaderBackground;
    UILabel *colleaguesLabel;
    UIView *gridHolder;
    NSMutableArray *gridButtons;
    UIButton *gridButton;
    NSMutableArray *contacts;
    UISearchBar *contactSeachBar;
    UITableView *contactSearchTableView;
}
@property (nonatomic) BOOL isFiltered;
@property (strong, nonatomic) NSMutableArray* allTableData;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
-(void)reset;
-(void)resetKeyboard;
-(void)addContactsData:(NSMutableArray *)incomingContacts;
@end