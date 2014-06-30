//
//  NSObject+WeatherClient.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/29/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>

@interface WeatherClient : NSObject
-(RACSignal *)fetchJSONFromURL :(NSURL *)url;
-(RACSignal *)fetchCurrentConditionsForLocation: (CLLocationCoordinate2D)coordinate;
-(RACSignal *)fetchHourlyForecastForLocation: (CLLocationCoordinate2D)coordinate;
-(RACSignal *)fetchDailyForecastForLocation: (CLLocationCoordinate2D)coordinate;

@end
