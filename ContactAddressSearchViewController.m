//
//  ContactAddressSearchViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ContactAddressSearchViewController.h"
#import "AddressSearchModel.h"
#import "ContactAddressSearchController.h"

@interface ContactAddressSearchViewController ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ContactAddressSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithSearch:(NSString *)searchText initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[RACObserve([ContactAddressSearchController sharedManager], searchResults)
          deliverOn:RACScheduler.mainThreadScheduler]
         subscribeNext:^(NSMutableArray *newSearchResults) {
             [self.tableView reloadData];
         }];
        
        [[ContactAddressSearchController sharedManager] fetchSearchResults:searchText];
    }
    return self;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    AddressSearchModel *cellData = [[ContactAddressSearchController sharedManager].searchResults objectAtIndex:indexPath.row];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        /*self.addressLine1 = [[UILabel alloc] init];
        self.addressLine2 = [[UILabel alloc] init];
        self.city = [[UILabel alloc] init];
        self.state = [[UILabel alloc] init];
        self.zipCode = [[UILabel alloc] init];
        [cell.contentView addSubview:self.addressLine1];
        [cell.contentView addSubview:self.addressLine2];
        [cell.contentView addSubview:self.city];
        [cell.contentView addSubview:self.state];
        [cell.contentView addSubview:self.zipCode];*/
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
