//
//  ProfileViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    // Do any additional setup after loading the view from its nib.
    
    UILabel *contactsHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 50)];
    contactsHeader.backgroundColor = [UIColor clearColor];
    contactsHeader.textColor = [UIColor whiteColor];
    contactsHeader.text = @"Profile";
    contactsHeader.textAlignment = NSTextAlignmentCenter;
    contactsHeader.font = [UIFont fontWithName:@"Colaborate-Thin" size:20];;
    [self.view addSubview:contactsHeader];
    
     self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
