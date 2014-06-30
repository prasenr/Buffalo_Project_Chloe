//
//  MTLModel+WeatherCondition.m
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/29/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import "MTLModel+WeatherCondition.h"
#define MPS_TO_MPH 2.23694f

@implementation WeatherCondition : MTLModel

+(NSDictionary *) imageMap {
    
    static NSDictionary *_imageMap = nil;
    if(!_imageMap) {
    _imageMap = @{
                  @200: @"thunder_shower",
                  @201: @"thunder_rain",
                  @202: @"thunder_rain",
                  @210: @"thunder_shower",
                  @211: @"thunder-shower",
                  @212: @"thunder_rain",
                  @221: @"thunder_rain",
                  @230: @"thunder_shower",
                  @231: @"thunder_shower",
                  @232: @"thunder_rain",
                  @300: @"rain",
                  @301: @"rain",
                  @302: @"rain",
                  @310: @"rain",
                  @311: @"rain",
                  @312: @"rain",
                  @313: @"rain",
                  @314: @"rain",
                  @321: @"rain",
                  @500: @"rain",
                  @501: @"rain",
                  @502: @"rain",
                  @503: @"rain",
                  @504: @"rain",
                  @511: @"rain",
                  @520: @"shower",
                  @521: @"shower",
                  @522: @"shower",
                  @531: @"shower",
                  @600: @"snow",
                  @601: @"snow",
                  @602: @"snow",
                  @611: @"snow",
                  @612: @"snow",
                  @615: @"snow",
                  @616: @"snow",
                  @620: @"snow",
                  @621: @"snow",
                  @622: @"snow",
                  @701: @"mist",
                  @711: @"sunny",
                  @721: @"sunny",
                  @731: @"sunny",
                  @741: @"sunny",
                  @751: @"sunny",
                  @761: @"sunny",
                  @762: @"sunny",
                  @771: @"sunny",
                  @781: @"sunny",
                  @800: @"sunny",
                  @801: @"partly_cloudy",
                  @802: @"partly_cloudy",
                  @803: @"partly_cloudy",
                  @804: @"partly_sunny",
                  @901: @"windy",
                  @902: @"windy",
                  @903: @"windy",
                  @904: @"windy",
                  @905: @"windy",
                  @906: @"hail",
                  @951: @"sunny",
                  @952: @"windy",
                  @953: @"windy",
                  @954: @"windy",
                  @955: @"windy",
                  @956: @"windy",
                  @957: @"windy",
                  @958: @"windy",
                  @959: @"windy",
                  @960: @"windy",
                  @961: @"windy",
                  @962: @"windy"
                  };
    }
    return _imageMap;
    
}

-(NSString *)imageName {
    return [WeatherCondition  imageMap][self.icon[0]];
}

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"date": @"dt",
             @"locationName": @"name",
             @"humidity": @"main.humidity",
             @"temperature": @"main.temp_max",
             @"tempHigh": @"main.temp_min",
             @"sunrise": @"sys.sunrise",
             @"sunset": @"sys.sunset",
             @"conditionDescription": @"weather.description",
             @"condition": @"weather.main",
             @"icon": @"weather.id",
             @"windBearing": @"wind.deg",
             @"windSpeed": @"wind.speed"
             };
}

+(NSValueTransformer *) dateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
    } reverseBlock:^(NSDate *date) {
        return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    }];
}

+(NSValueTransformer *) sunriseJSONTransformer {
    return [self dateJSONTransformer];
}

+(NSValueTransformer *) sunsetJSONTransformer {
    return [self dateJSONTransformer];
}

+(NSValueTransformer *) windSpeedJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
        return @(num.floatValue * MPS_TO_MPH);
    }reverseBlock:^(NSNumber *speed) {
        return @(speed.floatValue/MPS_TO_MPH);
    }];
}
@end
