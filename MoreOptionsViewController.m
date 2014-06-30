//
//  MoreOptionsViewController.m
//  Buffalo Project 2
//
//  Created by Christopher Fisher on 8/19/13.
//  Copyright (c) 2013 Christopher Fisher. All rights reserved.
//

#import "MoreOptionsViewController.h"

@interface MoreOptionsViewController ()

@end

@implementation MoreOptionsViewController

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
    bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    [bg setBackgroundColor:[UIColor whiteColor]];
    [bg setAlpha: 0];
    [self.view addSubview:bg];
    
    moreOptionsButton = [[UIButton alloc] initWithFrame:CGRectMake(133, 10, 54, 13)];
    [moreOptionsButton setBackgroundImage:[UIImage imageNamed:@"moreButton.png"] forState:UIControlStateNormal];
    [self.view addSubview:moreOptionsButton];
    
    addContactButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-(94/2), 30, 94, 16)];
    [addContactButton setBackgroundImage:[UIImage imageNamed:@"addContact.png"] forState:UIControlStateNormal];
    addContactButton.alpha = 0;
    [self.view addSubview:addContactButton];
    
    findContactsButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-(103/2), 70, 103, 16)];
    [findContactsButton setBackgroundImage:[UIImage imageNamed:@"findAContact.png"] forState:UIControlStateNormal];
    findContactsButton.alpha = 0;
    [self.view addSubview:findContactsButton];
    
    moreOptionsSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moreOptionsSwipeUp:)];
    moreOptionsSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    moreOptionsSwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moreOptionsSwipeDown:)];
    moreOptionsSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:moreOptionsSwipeUp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)moreOptionsSwipeUp:(UIGestureRecognizer *)sender {
    
    CGRect optionsTo = CGRectMake(0, 250, self.view.frame.size.width, 300);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.view.frame = optionsTo;
    bg.alpha = 1;
    addContactButton.alpha = 1;
    findContactsButton.alpha = 1;
    bg.alpha = 1;
    moreOptionsButton.alpha = 0;
    [UIView commitAnimations];
    
    [self.view removeGestureRecognizer:moreOptionsSwipeUp];
    [self.view addGestureRecognizer:moreOptionsSwipeDown];
    
}

-(IBAction)moreOptionsSwipeDown:(UIGestureRecognizer *)sender {
    
    CGRect optionsTo = CGRectMake(0, 430, self.view.frame.size.width, 300);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.view.frame = optionsTo;
    bg.alpha = 0;
    addContactButton.alpha = 0;
    findContactsButton.alpha = 0;
    bg.alpha = 0;
    moreOptionsButton.alpha = 1;
    [UIView commitAnimations];
    
    [self.view removeGestureRecognizer:moreOptionsSwipeDown];
    [self.view addGestureRecognizer:moreOptionsSwipeUp];
}

@end
