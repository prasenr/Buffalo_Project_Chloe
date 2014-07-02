//
//  ContactAddressSearchViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ContactAddressSearchViewController.h"
#import "AddressSearchModel.h"
#import "AddressHistoryModel.h"
#import "ContactAddressSearchController.h"

@interface ContactAddressSearchViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *countyLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *zipCodeLabel;
@property (nonatomic, strong) UILabel *countryLabel;
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
        
        self.addressLabel = [[UILabel alloc] init];
        self.cityLabel = [[UILabel alloc] init];
        self.stateLabel = [[UILabel alloc] init];
        self.countyLabel = [[UILabel alloc] init];
        self.zipCodeLabel = [[UILabel alloc] init];
        self.countryLabel = [[UILabel alloc] init];
        [cell.contentView addSubview:self.addressLabel];
        [cell.contentView addSubview:self.cityLabel];
        [cell.contentView addSubview:self.stateLabel];
        [cell.contentView addSubview:self.countyLabel];
        [cell.contentView addSubview:self.zipCodeLabel];
        [cell.contentView addSubview:self.countryLabel];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    NSInteger xPos = 10;
    NSInteger yPos = 10;
    
    if([cellData.addressLine1 length]>0) {
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        self.addressLabel.text = cellData.addressLine1;
        self.addressLabel.font = [UIFont fontWithName:@"Colaborate" size:12];
        self.addressLabel.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [cellData.addressLine1 boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.addressLabel.font} context:nil];
        CGRect newFrame = self.addressLabel.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        newFrame.origin.x = xPos;
        newFrame.origin.y = yPos;
        self.addressLabel.frame = newFrame;
        yPos = yPos + self.addressLabel.frame.size.height;
        [cell.contentView addSubview:self.addressLabel];
    }
    
    if([cellData.city length]>0) {
        self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        self.cityLabel.text = cellData.city;
        self.cityLabel.font = [UIFont fontWithName:@"Colaborate" size:12];
        self.cityLabel.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [cellData.city boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.cityLabel.font} context:nil];
        CGRect newFrame = self.cityLabel.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        newFrame.origin.y = yPos;
        self.cityLabel.frame = newFrame;
        xPos = xPos + self.cityLabel.frame.size.width + 5;
        [cell.contentView addSubview:self.cityLabel];
    }
    
    if([cellData.state length]>0) {
        
        NSMutableString *stateString = [[NSMutableString alloc] init];
        if([cellData.city length]>0) {
            [stateString appendString:@", "];
        }
        
        [stateString appendString:cellData.state];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        self.stateLabel.text = stateString;
        self.stateLabel.font = [UIFont fontWithName:@"Colaborate" size:12];
        self.stateLabel.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [cellData.state boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.stateLabel.font} context:nil];
        CGRect newFrame = self.stateLabel.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        newFrame.origin.y = yPos;
        newFrame.origin.x = xPos;
        self.stateLabel.frame = newFrame;
        xPos = xPos + self.stateLabel.frame.size.width + 5;
        [cell.contentView addSubview:self.stateLabel];
    }
    
    if([cellData.county length]>0) {
        self.countyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        self.countyLabel.text = cellData.county;
        self.countyLabel.font = [UIFont fontWithName:@"Colaborate" size:12];
        self.countyLabel.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [cellData.county boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.countyLabel.font} context:nil];
        CGRect newFrame = self.countyLabel.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        newFrame.origin.y = yPos;
        newFrame.origin.x = xPos;
        self.countyLabel.frame = newFrame;
        xPos = xPos + self.countyLabel.frame.size.width + 5;
        [cell.contentView addSubview:self.countyLabel];
    }
    
    if([cellData.zipcode length]>0) {
        self.zipCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        self.zipCodeLabel.text = cellData.zipcode;
        self.zipCodeLabel.font = [UIFont fontWithName:@"Colaborate" size:12];
        self.zipCodeLabel.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [cellData.zipcode boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.zipCodeLabel.font} context:nil];
        CGRect newFrame = self.zipCodeLabel.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        newFrame.origin.y = yPos;
        newFrame.origin.x = xPos;
        self.zipCodeLabel.frame = newFrame;
        xPos = xPos + self.zipCodeLabel.frame.size.width + 5;
        [cell.contentView addSubview:self.zipCodeLabel];
    }
    
    if([cellData.country length]>0) {
        self.countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 50)];
        self.countryLabel.text = cellData.country;
        self.countryLabel.font = [UIFont fontWithName:@"Colaborate" size:12];
        self.countryLabel.textColor = [UIColor whiteColor];
        CGSize maxSummaryLabelSize = CGSizeMake(self.view.bounds.size.width - 20, FLT_MAX);
        CGRect expectedLabelSize = [cellData.country boundingRectWithSize:CGSizeMake(maxSummaryLabelSize.width, maxSummaryLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.countryLabel.font} context:nil];
        CGRect newFrame = self.countryLabel.frame;
        newFrame.size.height = expectedLabelSize.size.height;
        newFrame.size.width = expectedLabelSize.size.width;
        newFrame.origin.y = yPos;
        newFrame.origin.x = xPos;
        self.countryLabel.frame = newFrame;
        xPos = xPos + self.countryLabel.frame.size.width + 5;
        [cell.contentView addSubview:self.countryLabel];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressSearchModel *cellData = [[ContactAddressSearchController sharedManager].searchResults objectAtIndex:indexPath.row];
    AddressHistoryModel *aAddressHistory = [[AddressHistoryModel alloc] init];
    [aAddressHistory convertFromAddressSearch:cellData];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:aAddressHistory forKey:@"addressHistory"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addContactAddress" object:nil userInfo:userInfo];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ContactAddressSearchController sharedManager].searchResults count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
