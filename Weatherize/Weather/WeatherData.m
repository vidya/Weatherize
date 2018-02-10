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
        self.nextFiveDayNames = [NSMutableArray new];
        self.nextFiveDayNames = [self getNextFiveDayNames];
    }
    
    return self;
}

- (NSArray *)getNextFiveDayNames {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSDate *tempDay;
    NSDate *today = [NSDate date];
    
    NSMutableArray *nextFiveDayNames = [NSMutableArray arrayWithCapacity:5];
    
    double secondsInDay = (24 * 60 * 60);
    
    tempDay = [today dateByAddingTimeInterval: (1 * secondsInDay)];
    [nextFiveDayNames addObject:[dateFormatter stringFromDate: tempDay]];
    
    tempDay = [today dateByAddingTimeInterval: (2 * secondsInDay)];
    [nextFiveDayNames addObject:[dateFormatter stringFromDate: tempDay]];
    
    tempDay = [today dateByAddingTimeInterval: (3 * secondsInDay)];
    [nextFiveDayNames addObject:[dateFormatter stringFromDate: tempDay]];
    
    tempDay = [today dateByAddingTimeInterval: (4 * secondsInDay)];
    [nextFiveDayNames addObject:[dateFormatter stringFromDate: tempDay]];
    
    tempDay = [today dateByAddingTimeInterval: (5 * secondsInDay)];
    [nextFiveDayNames addObject:[dateFormatter stringFromDate: tempDay]];
    
    return nextFiveDayNames;
}

- (NSDictionary *)extractWeatherData: (NSDictionary *)jsonDict {
    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    
    NSString *weatherIcon = [[jsonDict objectForKey:@"weather"] objectAtIndex:0][@"icon"];
    NSString *temperature = [jsonDict objectForKey:@"main"][@"temp"];
    
    dataDict[@"weatherIcon"] = weatherIcon;
    dataDict[@"temperature"] = temperature;
    
    return dataDict;
}

- (void)getCurrentWeatherInfoWithCompletion:(APICallCompletionHandler)completion {
    [self.weatherAPI getCurrentWeatherInUnits: @"imperial" withCompletion:^(NSDictionary *apiResponseDict) {
        NSDictionary *weatherInfoDict = [self extractWeatherData:apiResponseDict];
        
        completion(weatherInfoDict);
    }];
}

- (void)getFiveDayForecastInfoWithCompletion:(APICallCompletionHandler)completion {
    [self.weatherAPI getForecastWeatherInUnits: @"imperial" withCompletion: ^(NSDictionary *apiResponseDict) {
        NSArray *fiveDayList = [self nextFiveDayNames];
        NSArray *weatherInfoDictArray = [apiResponseDict objectForKey:@"list"];
        
        NSMutableDictionary *fiveDayForecastInfo = [NSMutableDictionary new];
        
        for (int n = 0; n < 5; n++ ) {
            NSString *dayName = fiveDayList[n];
            NSDictionary *dayWeatherDict = weatherInfoDictArray[n];
            
            fiveDayForecastInfo[dayName] = [self extractWeatherData:dayWeatherDict];
        }
        
        completion(fiveDayForecastInfo);
    }];
}

- (void)getWeatherDataWithCompletion:(NewAPICallCompletionHandler)completion {
    NSMutableArray *weatherData = [NSMutableArray new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];

    [self getCurrentWeatherInfoWithCompletion:^(NSDictionary *info) {
        NSDate *today = [NSDate date];
        NSString *dayName = [dateFormatter stringFromDate: today];
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        
        tempDict[@"dayName"] = dayName;
        tempDict[@"weatherIcon"] = info[@"weatherIcon"];
        tempDict[@"temperature"] = info[@"temperature"];

        [weatherData addObject:tempDict];

//        [self getFiveDayForecastInfoWithCompletion: ^(NSDictionary *apiResponseDict) {
//
//            NSArray *fiveDayList = self.nextFiveDayNames;
//            NSArray *weatherInfoDictArray = [apiResponseDict objectForKey:@"list"];
//
//            NSMutableDictionary *fiveDayForecastInfo = [NSMutableDictionary new];
//
//            for (int n = 0; n < 5; n++ ) {
//                NSString *dayName = fiveDayList[n];
//                NSDictionary *dayWeatherDict = weatherInfoDictArray[n];
//
//                fiveDayForecastInfo[dayName] = [self extractWeatherData:dayWeatherDict];
//
//                NSMutableDictionary *tempDict = [NSMutableDictionary new];
//
//                tempDict[@"dayName"] = dayName;
//                tempDict[@"weatherIcon"] = fiveDayForecastInfo[@"weatherIcon"];
//                tempDict[@"temperature"] = fiveDayForecastInfo[@"temperature"];
//
//                [weatherData addObject:tempDict];
//            }
//            completion(weatherData);
//
//        }];

        completion(weatherData);
    
    }];
}


@end




