//
//  NSObject+WeatherController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/29/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

@import Foundation;
@import CoreLocation;
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>

#import "WeatherCondition+DailyForecastModel.h"

@interface WeatherController :NSObject
<CLLocationManagerDelegate>
+(instancetype)sharedManager;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) WeatherCondition *currentCondition;
@property (nonatomic, strong, readonly) NSArray *hourlyForecast;
@property (nonatomic, strong, readonly) NSArray *dailyForecast;


-(void) findCurrentLocation;

@end
