//
//  ContactGridPictureViewController.m
//  Buffalo Project 2
//
//  Created by Christopher Fisher on 8/15/13.
//  Copyright (c) 2013 Christopher Fisher. All rights reserved.
//

#import "ContactGridPictureViewController.h"
#import "NSObject+PersonModel.h"

@interface ContactGridPictureViewController ()
@property (nonatomic, strong) UIImageView *loaderImage;
@end

@implementation ContactGridPictureViewController

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }*/

-(id)initWithPerson:(PersonModel *)person initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    personModel = person;
    personPath = personModel.personImage;
    self.isSearch = false;
    
    
    
    self = [super init];
    if (self) {
        // Custom initialization
        
        button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 142)];
        [button addTarget:self action:@selector(contactClick:) forControlEvents:UIControlEventTouchUpInside];
        button.alpha = 0;
        [self addSubview:button];
        
        NSMutableString *filePath = [[NSMutableString alloc] init];
        [filePath appendString:[personModel.firstName substringToIndex:1].lowercaseString];
        [filePath appendString:@".png"];
        NSLog(@"file path: %@", filePath);
        
        self.loaderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filePath]];
        self.loaderImage.frame = CGRectMake(0, 0, 80, 142);
        self.loaderImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.loaderImage];
        
        
        __block NSData *imageData;
        dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.buffaloproject.profileImageBGqueue", NULL);
        
        dispatch_async(backgroundQueue, ^(void) {
            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:personPath]];
            UIImage *imageLoad;
            imageLoad = [[UIImage alloc] initWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [button setBackgroundImage:imageLoad forState:UIControlStateNormal];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDuration:.5];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                button.alpha = 1;
                self.loaderImage.alpha = 0;
                [UIView commitAnimations];
            });
        });
    }
    return self;
}

-(void)buttonImageLoaded:(UIImage *)image {
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
}

/*- (void)viewDidLoad
 {
 [super viewDidLoad];
 
 UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(240, 390, 80, 110)];
 [button setBackgroundImage:personModel.personImage forState:UIControlStateNormal];
 [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
 [self.view addSubview:button];
 }*/

-(IBAction)contactClick:(id)sender {
    if(!self.isSearch)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:personModel forKey:@"person"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"contactClickedFromGrid" object:nil userInfo:userInfo];
    }
}

-(void)removeClickListener {
    self.isSearch = false;
}

-(void)addClickListner{
    self.isSearch = true;
}

/*- (void)didReceiveMemoryWarning
 {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }*/

@end
