//
//  ToDoListViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/11/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ToDoListViewController.h"
#import "ToDoModel.h"
#import "NSObject+TodaySummary_Controller.h"

@interface ToDoListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) UILabel *headerStartTimeLabel;
@property (nonatomic, strong) UILabel *headerEndTimeLabel;
@property (nonatomic, strong) NSMutableAttributedString *detailAttributedString;
@property (nonatomic, strong) NSDate *currentDateShowing;
@end

static NSDateFormatter *dateFormatter = nil;
static NSDateFormatter *todayFormatter = nil;
@implementation ToDoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 165, self.view.frame.size.width, self.view.frame.size.height - 165)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor clearColor];
}

-(void) setViewDate:(NSDate *)dateToUse {
    self.currentDateShowing = dateToUse;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    NSString *headerText;
    
    if(todayFormatter == nil) {
        todayFormatter = [[NSDateFormatter alloc] init];
        [todayFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    NSString *todayFormatted = [todayFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *currentDateShowingFormatted = [todayFormatter stringFromDate:self.currentDateShowing];
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    [headerView setBackgroundColor:[UIColor blackColor]];
    self.headerStartTimeLabel = [[UILabel alloc] init];
    self.headerEndTimeLabel = [[UILabel alloc] init];
    self.headerStartTimeLabel.textColor = [UIColor whiteColor];
    self.headerStartTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:30];
    self.headerStartTimeLabel.adjustsFontSizeToFitWidth = NO;
    self.headerStartTimeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.headerStartTimeLabel.textAlignment = NSTextAlignmentRight;
    
    self.headerEndTimeLabel.textColor = [UIColor whiteColor];
    self.headerEndTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    self.headerEndTimeLabel.adjustsFontSizeToFitWidth = NO;
    self.headerEndTimeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.headerEndTimeLabel.textAlignment = NSTextAlignmentRight;
    
    if([todayFormatted isEqualToString:currentDateShowingFormatted]) {
        if(section ==0) {
            // NSString *begininingOfTimeFormatted = [todayFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]];
            // NSDictionary *noStartTimeDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:begininingOfTimeFormatted];
            
            //NSArray *keys = [noStartTimeDict allKeys];
            self.headerStartTimeLabel.frame = CGRectMake(20, 10, self.view.bounds.size.width, 30);
            self.headerStartTimeLabel.textAlignment = NSTextAlignmentLeft;
            self.headerStartTimeLabel.text = @"SOMETIME TODAY";
        } else {
            NSDictionary *currentDateDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:currentDateShowingFormatted];
            NSArray *keys = [currentDateDict allKeys];
            self.headerEndTimeLabel.frame = CGRectMake(10, 10, 110, 12);
            self.headerEndTimeLabel.text = @"BY";
            self.headerStartTimeLabel.frame = CGRectMake(10, (self.headerEndTimeLabel.frame.origin.y + self.headerEndTimeLabel.frame.size.height) - 2, 110, 30);
            self.headerStartTimeLabel.text = [keys objectAtIndex:section-1];
            //headerText = [keys objectAtIndex:section-1];
        }
    } else {
        NSDictionary *currentDateDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:currentDateShowingFormatted];
        NSArray *keys = [currentDateDict allKeys];
        self.headerEndTimeLabel.frame = CGRectMake(10, 10, 110, 12);
        self.headerEndTimeLabel.text = @"BY";
        self.headerStartTimeLabel.frame = CGRectMake(10, (self.headerEndTimeLabel.frame.origin.y + self.headerEndTimeLabel.frame.size.height) - 2, 110, 30);
        self.headerStartTimeLabel.text = [keys objectAtIndex:section];
        //headerText = [keys objectAtIndex:section];
    }
    NSLog(@"headerText %@", headerText);
    
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 2, tableView.frame.size.width - 5, 18);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel.text = headerText;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the header view
    [headerView addSubview:self.headerStartTimeLabel];
    [headerView addSubview:self.headerEndTimeLabel];
    //[headerView addSubview:headerLabel];
    
    // 5. Finally return
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //self.startTimeLabel = [[UILabel alloc] init];
        //self.endTimeLabel = [[UILabel alloc] init];
        self.detailTextLabel = [[UILabel alloc] init];
        
        /*self.startTimeLabel.textColor = [UIColor whiteColor];
         self.startTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:30];
         self.startTimeLabel.adjustsFontSizeToFitWidth = NO;
         self.startTimeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
         self.startTimeLabel.textAlignment = NSTextAlignmentRight;
         
         self.endTimeLabel.textColor = [UIColor whiteColor];
         self.endTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
         self.endTimeLabel.adjustsFontSizeToFitWidth = NO;
         self.endTimeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
         self.endTimeLabel.textAlignment = NSTextAlignmentRight;*/
        
        
        self.detailTextLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:16];
        
        self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.detailTextLabel.numberOfLines = 0;
        [self.detailTextLabel sizeToFit];
        
        //[cell.contentView addSubview:self.startTimeLabel];
        //[cell.contentView addSubview:self.endTimeLabel];
        [cell.contentView addSubview:self.detailTextLabel];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    if(dateFormatter == nil){
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mma"];
    }
    
    if(todayFormatter == nil) {
        todayFormatter = [[NSDateFormatter alloc] init];
        [todayFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    
    CGRect detailFrame = self.detailTextLabel.frame;
    
    if(todayFormatter == nil) {
        todayFormatter = [[NSDateFormatter alloc] init];
        [todayFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    NSString *todayFormatted = [todayFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *currentDateShowingFormatted = [todayFormatter stringFromDate:self.currentDateShowing];
    
    ToDoModel *cellData;
    if([todayFormatted isEqualToString:currentDateShowingFormatted]) {
        if(indexPath.section ==0) {
            NSLog(@"current row section 0: %ld", (long)indexPath.row);
            NSString *begininingOfTimeFormatted = [todayFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]];
            NSDictionary *noStartTimeDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:begininingOfTimeFormatted];
            
            NSArray *keys = [noStartTimeDict allKeys];
            cellData = [[noStartTimeDict valueForKey:[keys objectAtIndex:0]] objectAtIndex:indexPath.row];
            NSLog(@"made a cell");
        } else {
            NSLog(@"current row section %ld: %ld", (long)indexPath.section,(long)indexPath.row);
            NSDictionary *currentDateDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:currentDateShowingFormatted];
            NSArray *keys = [currentDateDict allKeys];
            cellData = [[currentDateDict valueForKey:[keys objectAtIndex:indexPath.section -1]] objectAtIndex:indexPath.row];
        }
    } else {
        NSDictionary *currentDateDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:currentDateShowingFormatted];
        NSArray *keys = [currentDateDict allKeys];
        
        cellData = [[currentDateDict valueForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    
    /*if(cellData.startDate != [[NSDate alloc] initWithTimeIntervalSinceNow:0]) {
     self.endTimeLabel.frame = CGRectMake(10, 10, 110, 12);
     self.endTimeLabel.text = @"BY";
     self.startTimeLabel.frame = CGRectMake(10, (self.endTimeLabel.frame.origin.y + self.endTimeLabel.frame.size.height) - 2, 110, 30);
     self.startTimeLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:cellData.startDate]];
     self.detailTextLabel.frame = CGRectMake(20, 30, self.view.frame.size.width - 40, 100);
     } else {
     self.startTimeLabel.frame = CGRectMake(20, 10, 110, 30);
     self.startTimeLabel.textAlignment = NSTextAlignmentLeft;
     self.startTimeLabel.text = @"TODAY";
     self.detailTextLabel.frame = CGRectMake(20, 20, self.view.frame.size.width - 40, 100);
     }*/
    
    self.detailTextLabel.frame = CGRectMake(20, 20, self.view.frame.size.width - 40, 100);
    
    if(cellData.isComplete) {
        self.detailAttributedString = [[NSMutableAttributedString alloc] initWithString:cellData.todo];
        [self.detailAttributedString addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, [self.detailAttributedString length])];
        self.detailTextLabel.attributedText = self.detailAttributedString;
        self.detailTextLabel.alpha = 0.25;
        //self.startTimeLabel.alpha = 0.25;
        //self.endTimeLabel.alpha = 0.25;
    } else {
        if(self.detailAttributedString){
            self.detailTextLabel.attributedText = nil;
            self.detailTextLabel.alpha = 1.0;
            //self.startTimeLabel.alpha = 1.0;
            //self.endTimeLabel.alpha = 1.0;
        }
    }
    
    self.detailTextLabel.text = cellData.todo;
    
    CGSize maxDetailLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    CGRect expectedDetailLabelSize = [self.detailTextLabel.text boundingRectWithSize:CGSizeMake(maxDetailLabelSize.width, maxDetailLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.detailTextLabel.font} context:nil];
    
    self.detailTextLabel.frame = expectedDetailLabelSize;
    
    detailFrame = self.detailTextLabel.frame;
    detailFrame.origin.y = 10;
    detailFrame.origin.x = 20;
    self.detailTextLabel.frame = detailFrame;
    
    /*if(cellData.startDate != [[NSDate alloc] initWithTimeIntervalSinceNow:0]) {
     
     detailFrame.origin.y = 48;
     } else {
     detailFrame.origin.y = 38;
     }*/
    self.detailTextLabel.frame = detailFrame;
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ToDoModel *cellData = [[TodaySummary_Controller sharedManager].rawToDos objectAtIndex:indexPath.row];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:cellData forKey:@"todo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editToDo" object:nil userInfo:userInfo];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: Need to determine height;
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *textString;
    CGRect expectedDetailLabelSize;
    
    if(dateFormatter == nil){
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mma"];
    }
    
    if(todayFormatter == nil) {
        todayFormatter = [[NSDateFormatter alloc] init];
        [todayFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    
    //CGRect detailFrame = self.detailTextLabel.frame;
    
    if(todayFormatter == nil) {
        todayFormatter = [[NSDateFormatter alloc] init];
        [todayFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    NSString *todayFormatted = [todayFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *currentDateShowingFormatted = [todayFormatter stringFromDate:self.currentDateShowing];
    
    ToDoModel *cellData;
    if([todayFormatted isEqualToString:currentDateShowingFormatted]) {
        if(indexPath.section ==0) {
            NSLog(@"current row section 0: %ld", (long)indexPath.row);
            NSString *begininingOfTimeFormatted = [todayFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]];
            NSDictionary *noStartTimeDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:begininingOfTimeFormatted];
            
            NSArray *keys = [noStartTimeDict allKeys];
            cellData = [[noStartTimeDict valueForKey:[keys objectAtIndex:0]] objectAtIndex:indexPath.row];
            NSLog(@"made a cell");
        } else {
            NSLog(@"current row section %ld: %ld", (long)indexPath.section,(long)indexPath.row);
            NSDictionary *currentDateDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:currentDateShowingFormatted];
            NSArray *keys = [currentDateDict allKeys];
            cellData = [[currentDateDict valueForKey:[keys objectAtIndex:indexPath.section -1]] objectAtIndex:indexPath.row];
        }
    } else {
        NSDictionary *currentDateDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:currentDateShowingFormatted];
        NSArray *keys = [currentDateDict allKeys];
        
        cellData = [[currentDateDict valueForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    
    //ToDoModel *cellData = [[TodaySummary_Controller sharedManager].rawToDos objectAtIndex:indexPath.row];
    textString = cellData.todo;
    CGSize maxDetailLabelSize = CGSizeMake(self.view.bounds.size.width - 40, FLT_MAX);
    expectedDetailLabelSize = [textString boundingRectWithSize:CGSizeMake(maxDetailLabelSize.width, maxDetailLabelSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Colaborate-Thin" size:16]} context:nil];
    /*if(cellData.startDate != [[NSDate alloc] initWithTimeIntervalSinceNow:0]) {
     expectedDetailLabelSize.size.height += 48;
     } else {
     expectedDetailLabelSize.size.height += 38;
     }*/
    
    
    //For padding
    
    expectedDetailLabelSize.size.height += 30;
    return expectedDetailLabelSize.size.height;
}

/*- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
 }*/

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(todayFormatter == nil) {
        todayFormatter = [[NSDateFormatter alloc] init];
        [todayFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    NSString *todayFormatted = [todayFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *currentDateShowingFormatted = [todayFormatter stringFromDate:self.currentDateShowing];
    
    if([todayFormatted isEqualToString:currentDateShowingFormatted]) {
        if(section ==0) {
            NSString *begininingOfTimeFormatted = [todayFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]];
            NSDictionary *noStartTimeDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:begininingOfTimeFormatted];
            
            NSArray *keys = [noStartTimeDict allKeys];
            return [[noStartTimeDict valueForKey:[keys objectAtIndex:0]] count];
        } else {
            NSDictionary *currentDateDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:currentDateShowingFormatted];
            NSArray *keys = [currentDateDict allKeys];
            return [[currentDateDict valueForKey:[keys objectAtIndex:section-1]] count];
        }
    } else {
        NSDictionary *currentDateDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:currentDateShowingFormatted];
        NSArray *keys = [currentDateDict allKeys];
        return [[currentDateDict valueForKey:[keys objectAtIndex:section]] count];
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(todayFormatter == nil) {
        todayFormatter = [[NSDateFormatter alloc] init];
        [todayFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    
    NSString *todayFormatted = [todayFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *currentDateShowingFormatted = [todayFormatter stringFromDate:self.currentDateShowing];
    NSUInteger sectionCount = 0;
    
    
    if([todayFormatted isEqualToString:currentDateShowingFormatted]) {
        
        NSString *begininingOfTimeFormatted = [todayFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]];
        NSDictionary *noStartTimeDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:begininingOfTimeFormatted];
        
        sectionCount = [noStartTimeDict count];
    }
    
    NSDictionary *currentDateDict = [[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:currentDateShowingFormatted];
    sectionCount = sectionCount + [currentDateDict count];
    
    NSLog(@"total: %lu", (unsigned long)sectionCount);
    
    //NSUInteger tcount = [[[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:todayString] count];
    //NSUInteger bcount = [[[TodaySummary_Controller sharedManager].allToDosSorted valueForKey:beginingOfTimeString] count];
    
    return sectionCount;
}

-(void)updateToDos {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
