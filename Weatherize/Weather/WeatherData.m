//  WeatherData.m
//  Weatherize
//
//  Created by Vidya Sagar on 2/6/18.
//

#import "WeatherData.h"

@interface WeatherData ()

@end

@implementation WeatherData

- (id)init {
    self = [super init];
    
    if (self) {
        self.weatherAPI = [WeatherAPI new];
        self.theseSixDayNames = [self getTheseSixDayNames];
    }
    
    return self;
}

- (NSArray *)getTheseSixDayNames {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSDate *tempDay;
    NSDate *today = [NSDate date];
    
    NSMutableArray *nextSixDayNames = [NSMutableArray arrayWithCapacity:5];
    
    double secondsInDay = (24 * 60 * 60);

    [nextSixDayNames addObject:[dateFormatter stringFromDate: today]];

    tempDay = [today dateByAddingTimeInterval: (1 * secondsInDay)];
    [nextSixDayNames addObject:[dateFormatter stringFromDate: tempDay]];
    
    tempDay = [today dateByAddingTimeInterval: (2 * secondsInDay)];
    [nextSixDayNames addObject:[dateFormatter stringFromDate: tempDay]];
    
    tempDay = [today dateByAddingTimeInterval: (3 * secondsInDay)];
    [nextSixDayNames addObject:[dateFormatter stringFromDate: tempDay]];
    
    tempDay = [today dateByAddingTimeInterval: (4 * secondsInDay)];
    [nextSixDayNames addObject:[dateFormatter stringFromDate: tempDay]];
    
    tempDay = [today dateByAddingTimeInterval: (5 * secondsInDay)];
    [nextSixDayNames addObject:[dateFormatter stringFromDate: tempDay]];
    
    return nextSixDayNames;
}

- (NSDictionary *)extractWeatherData: (NSDictionary *)jsonDict {
    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    
    dataDict[@"weatherIcon"] = [[jsonDict objectForKey:@"weather"] objectAtIndex:0][@"icon"];
    dataDict[@"temperature"] = [jsonDict objectForKey:@"main"][@"temp"];
    
    return dataDict;
}

- (void)getWeatherDataWithCompletion:(DataFetchCompletionHandler)completion {
    NSMutableDictionary* weatherDataDict = [[NSMutableDictionary alloc] init];
    
    [self.weatherAPI getCurrentWeatherInUnits: @"imperial"
                               withCompletion: ^(NSDictionary *apiResponseDict) {
        // current weather
        weatherDataDict[@"currentWeather"] = [self extractWeatherData:apiResponseDict];

        [self.weatherAPI getForecastWeatherInUnits: @"imperial"
                                    withCompletion: ^(NSDictionary *apiResponseDict) {
            // forecast weather
            NSArray *fiveDayList = [self theseSixDayNames];

            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];

            NSArray *responseDictList = [apiResponseDict objectForKey:@"list"];

            NSMutableDictionary *fiveDayForecastInfo = [NSMutableDictionary new];
            
            int n = 0;
            for (NSString* dayName in fiveDayList) {
                fiveDayForecastInfo[dayName] = [self extractWeatherData:responseDictList[n]];
                
                fiveDayForecastInfo[dayName][@"dayName"] = dayName;
                n++;
            }

            weatherDataDict[@"forecastWeather"] = fiveDayForecastInfo;

            completion(weatherDataDict);
        }];
    }];
}


@end
