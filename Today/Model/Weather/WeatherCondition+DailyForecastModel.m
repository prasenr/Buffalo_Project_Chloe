//
//  WeatherCondition+DailyForecastModel.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/29/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "WeatherCondition+DailyForecastModel.h"
#import "MTLModel+WeatherCondition.h"

@implementation DailyForecastModel : WeatherCondition

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    
    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    
    return paths;
}
@end
