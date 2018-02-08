//
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
    }

    return self;
}

- (NSString *)currentDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSLog(@"The day of the week: %@", [dateFormatter stringFromDate:[NSDate date]]);
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (NSArray *)fiveDays {
    NSString *currentDay = [self currentDay];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSArray *weekdays = [dateFormatter weekdaySymbols];
    
    NSMutableArray *daysNeeded = [NSMutableArray arrayWithCapacity:5];
    
    /* Get the current day as a index of weekdays array, and count forward 5 days from it*/
    NSUInteger currentIndex = [weekdays indexOfObject:currentDay];
    
    for (int i = currentIndex; i <= 6; i++) {
        if ([daysNeeded count] < 5) {
            [daysNeeded addObject:weekdays[i]];
        }
    }
    
    int daysRemaining = 5 - [daysNeeded count];
    
    for(int i = 0; i < daysRemaining; i++) {
        [daysNeeded addObject:weekdays[i]];
    }
    
    NSLog(@"daysNeeded: %@", daysNeeded);
    
    return [NSMutableArray arrayWithObject:currentDay];
}

- (NSDictionary *)extractWeatherData: (NSDictionary *)jsonDict {
    NSMutableDictionary *dataDict = [NSMutableDictionary new];

    NSString *weatherIcon = [[jsonDict objectForKey:@"weather"] objectAtIndex:0][@"icon"];
    NSString *temperature = [jsonDict objectForKey:@"main"][@"temp"];
    
    dataDict[@"weatherIcon"] = weatherIcon;
    dataDict[@"temperature"] = temperature;
    
    return dataDict;
}

- (NSArray *)extractWeatherDataList: (NSDictionary *)apiResponseDict {
    NSArray *weatherDataDictArray = [apiResponseDict objectForKey:@"list"];

    return weatherDataDictArray;
}

- (void)getCurrentWeatherInfoWithCompletion:(APICallCompletionHandler)completion {
    [self.weatherAPI getCurrentWeatherInUnits: @"imperial" withCompletion:^(NSDictionary *apiResponseDict) {
        NSDictionary *weatherInfoDict = [self extractWeatherData:apiResponseDict];

        completion(weatherInfoDict);
    }];
}

- (void)getFiveDayForecastInfoWithCompletion:(APICallCompletionHandler)completion {
    [self.weatherAPI getForecastWeatherInUnits: @"imperial" withCompletion: ^(NSDictionary *apiResponseDict) {
        NSArray *weatherInfoDictArray = [self extractWeatherDataList:apiResponseDict];
        
        NSMutableArray *fiveDayForecastArray = [NSMutableArray arrayWithCapacity:5];
        NSMutableDictionary *fiveDayForecastInfo = [NSMutableDictionary new];

        for (NSDictionary *weatherInfoDict in weatherInfoDictArray) {
            NSDictionary *dataDict = [self extractWeatherData:weatherInfoDict];
            
            [fiveDayForecastArray addObject:dataDict];

            if ([fiveDayForecastInfo count] == 5) {
                for (NSString *day in [self fiveDays]) {
                    int dex = (int)[[self fiveDays] indexOfObject:day];
                    fiveDayForecastInfo[day] = fiveDayForecastArray[dex];
                }
                
                NSLog(@"This is the Five Day Forecast Info: %@", fiveDayForecastInfo);
            }
        }
        
        completion(fiveDayForecastInfo);
    }];
}

@end

