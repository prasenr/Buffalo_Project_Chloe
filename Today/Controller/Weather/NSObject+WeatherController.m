//
//  NSObject+WeatherController.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/29/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "NSObject+WeatherController.h"
#import "NSObject+WeatherClient.h"
#import <TSMessages/TSMessage.h>

@interface WeatherController()

@property (nonatomic, strong, readwrite) WeatherCondition *currentCondition;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) NSArray *hourlyForecast;
@property (nonatomic, strong, readwrite) NSArray *dailyForecast;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property (nonatomic, assign) BOOL isFetching;
@property (nonatomic, strong) WeatherClient *client;

@end
@implementation WeatherController :NSObject

+(instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}
    

-(id)init {
    if (self= [super init]) {
        self.isFirstUpdate = YES;
        self.isFetching = NO;
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        _client = [[WeatherClient alloc] init];
        
        [[[[RACObserve(self, currentLocation)
            ignore:nil]
           
           flattenMap:^(CLLocation *newLocation) {
               return [RACSignal merge:@[
                                         [self updateCurrentConditions]
                                         ]];
           }] deliverOn:RACScheduler.mainThreadScheduler]
         
         subscribeError:^(NSError *error) {
             [TSMessage showNotificationWithTitle:@"Error" subtitle:@"There was a problem fetching the today's weather" type:TSMessageNotificationTypeError];
         }];
    }
    return self;
}

-(void) findCurrentLocation {
    self.isFirstUpdate = YES;
    [self.locationManager startUpdatingLocation];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if(self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    
    if(!self.isFetching) {
        CLLocation *location = [locations lastObject];
        
        if(location.horizontalAccuracy >0) {
            self.currentLocation = location;
            [self.locationManager stopUpdatingLocation];
        }
        self.isFetching = YES;
    }
}

-(RACSignal *) updateCurrentConditions {
    return [[self.client fetchCurrentConditionsForLocation:self.currentLocation.coordinate] doNext:^(WeatherCondition *condition) {
        self.currentCondition = condition;
    }];
}

/*-(RACSignal *) updateHourlyForecast {
    return [[self.client fetchHourlyForecastForLocation:self.currentLocation.coordinate] doNext:^(NSArray *conditions) {
        self.hourlyForecast = conditions;
    }];
}

-(RACSignal *) updateDailyForecast {
    return [[self.client fetchDailyForecastForLocation:self.currentLocation.coordinate] doNext:^(NSArray *conditions) {
        self.dailyForecast = conditions;
    }];
}*/
@end
