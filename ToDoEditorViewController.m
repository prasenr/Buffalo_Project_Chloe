//
//  ToDoEditorViewController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 5/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "ToDoEditorViewController.h"
#import "ToDoModel.h"
#import <MapBox/Mapbox.h>



@interface ToDoEditorViewController ()
@property (nonatomic, retain) ToDoModel *toDo;
@property (nonatomic, retain) RMMapView *map;
@property (nonatomic, retain) UIView *blackOverlay;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong) UIScrollView *detailsScroller;
@property (nonatomic, strong) UIView *detailsHolder;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@end

@implementation ToDoEditorViewController

- (id)initWtihToDo:(ToDoModel *)todoItem initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
   
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.toDo = todoItem;
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"chloeproject.map-gnfkv8ht"];
    self.map = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];
    
    self.map.delegate = self;

    [self.view addSubview:self.map];
    
    self.blackOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.blackOverlay setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [self.view addSubview:self.blackOverlay];
    
    self.detailsScroller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.detailsScroller];
    
    self.detailsHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 200)];
    [self.detailsScroller addSubview:self.detailsHolder];
    [self.detailsScroller setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 200)];
    
    if(![self.toDo.locationLatLon[0] isEqualToString:@""]) {
        self.isFirstUpdate = YES;
        [self.locationManager startUpdatingLocation];
        

    } else {
        self.currentLocation = [[CLLocation alloc] initWithCoordinate: CLLocationCoordinate2DMake([self.toDo.locationLatLon[0] doubleValue], [self.toDo.locationLatLon[1] doubleValue])
                                                             altitude:0
                                                   horizontalAccuracy:0
                                                     verticalAccuracy:0
                                                            timestamp:[NSDate date]];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mma"];
    
    self.startTimeLabel = [[UILabel alloc] init];
    self.endTimeLabel = [[UILabel alloc] init];
    self.detailTextLabel = [[UILabel alloc] init];
    
    self.startTimeLabel.textColor = [UIColor whiteColor];
    self.startTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:36];
    self.startTimeLabel.adjustsFontSizeToFitWidth = NO;
    self.startTimeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.startTimeLabel.textAlignment = NSTextAlignmentRight;
    
    self.endTimeLabel.textColor = [UIColor whiteColor];
    self.endTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    self.endTimeLabel.adjustsFontSizeToFitWidth = NO;
    self.endTimeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.endTimeLabel.textAlignment = NSTextAlignmentRight;
    
    
    self.detailTextLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.font = [UIFont fontWithName:@"Colaborate-Thin" size:18];
    
    self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.detailTextLabel.numberOfLines = 0;
    [self.detailTextLabel sizeToFit];
    
    if(self.toDo.startDate != [[NSDate alloc] initWithTimeIntervalSinceNow:0]) {
        self.endTimeLabel.frame = CGRectMake(10, 10, 110, 12);
        self.endTimeLabel.text = @"BY";
        self.startTimeLabel.frame = CGRectMake(10, (self.endTimeLabel.frame.origin.y + self.endTimeLabel.frame.size.height) - 2, 110, 30);
        self.startTimeLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.toDo.startDate]];
        self.detailTextLabel.frame = CGRectMake(20, 30, self.view.frame.size.width - 40, 100);
    } else {
        self.startTimeLabel.frame = CGRectMake(20, 10, 110, 30);
        self.startTimeLabel.textAlignment = NSTextAlignmentLeft;
        self.startTimeLabel.text = @"TODAY";
        self.detailTextLabel.frame = CGRectMake(20, 20, self.view.frame.size.width - 40, 100);
    }
    
    self.detailTextLabel.text = self.toDo.todo;
    
    CGRect newFrame = self.detailTextLabel.frame;
    newFrame.origin.y = (self.view.bounds.size.height - 60) - (self.detailTextLabel.frame.size.height + 20);
    self.detailTextLabel.frame = newFrame;
    
    newFrame = self.startTimeLabel.frame;
    newFrame.origin.y = (self.detailTextLabel.frame.origin.y -0) - self.startTimeLabel.frame.size.height;
    self.startTimeLabel.frame = newFrame;
    
    
    [self.detailsHolder addSubview:self.startTimeLabel];
    [self.detailsHolder addSubview:self.endTimeLabel];
    [self.detailsHolder addSubview:self.detailTextLabel];
    
    UIView *buttonHolder = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)-(240/2), self.view.bounds.size.height -85, 240, 100)];
    [self.view addSubview:buttonHolder];
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
     [okButton setBackgroundImage:[UIImage imageNamed:@"okCheckMark.png"] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(onOkClicked:) forControlEvents:UIControlEventTouchUpInside];
     [buttonHolder addSubview:okButton];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 100, 100)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"deleteIcon.png"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(onDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonHolder addSubview:deleteButton];
    
    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(140, 0, 100, 100)];
    [editButton setBackgroundImage:[UIImage imageNamed:@"editIcon.png"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(onEditClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonHolder addSubview:editButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 5, 50, 50)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelCloseButton.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

-(IBAction)onOkClicked:(id)sender {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.toDo forKey:@"todo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toDoCompleted" object:nil userInfo:userInfo];
}

-(IBAction)onDeleteClicked:(id)sender {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.toDo forKey:@"todo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteToDo" object:nil userInfo:userInfo];
}

-(IBAction)onEditClicked:(id)sender {
    
}

-(IBAction)onCancelClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelToDo" object:nil];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if(self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    
        CLLocation *location = [locations lastObject];
        
        if(location.horizontalAccuracy >0) {
            self.currentLocation = location;
            [self setMap];
        }
}

-(void)setMap {
    
    [self.map setZoom:14.0 atCoordinate:self.currentLocation.coordinate animated:YES];
    
    RMAnnotation *locationAnnotation = [[RMAnnotation alloc] initWithMapView:self.map coordinate:self.currentLocation.coordinate andTitle:@""];

    [self.map addAnnotation:locationAnnotation];
}

-(RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation {
    
    
    
    RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"mapMarkerCircle.png"]];

    marker.canShowCallout = NO;
    
    return marker;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
