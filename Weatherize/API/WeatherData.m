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

- (NSDictionary *)fetchWeatherData: (NSDictionary *)jsonDict {
    NSMutableDictionary *infoDict = [NSMutableDictionary new];

    NSString *weatherIcon = [[jsonDict objectForKey:@"weather"] objectAtIndex:0][@"icon"];
    NSString *temperature = [jsonDict objectForKey:@"main"][@"temp"];
    
    infoDict[@"weatherIcon"] = weatherIcon;
    infoDict[@"temperature"] = temperature;
    
    return infoDict;
}

- (NSDictionary *)extractWeatherInfo: (NSData *)weatherData {
    NSError *error = nil;

    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:&error];
    
    NSDictionary *infoDict = [self fetchWeatherData: jsonDict];

    return infoDict;
}

- (NSArray *)extractWeatherInfoList: (NSData *)weatherData {
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:&error];
    
    NSArray *weatherInfoArray = [json objectForKey:@"list"];

    return weatherInfoArray;
}

- (void)getCurrentWeatherInfoWithCompletion:(InfoCompletionBlock)completion {
    [self.weatherAPI getCurrentWeatherInUnits: @"imperial" withCompletion:^(NSData *weatherData) {
        NSDictionary *currentWeatherInfo = [self extractWeatherInfo:weatherData];

        completion(currentWeatherInfo);
    }];
}

- (void)getFiveDayForecastInfoWithCompletion:(InfoCompletionBlock)completion {
    [self.weatherAPI getForecastWeatherInUnits: @"imperial" withCompletion: ^(NSData *weatherData) {
        NSArray *weatherInfoArray = [self extractWeatherInfoList:weatherData];
        
        NSMutableArray *fiveDayForecastArray = [NSMutableArray arrayWithCapacity:5];
        NSMutableDictionary *fiveDayForecastInfo = [NSMutableDictionary new];

        for (NSDictionary *weatherInfo in weatherInfoArray) {
            NSDictionary *infoDict = [self fetchWeatherData:weatherInfo];
            
            [fiveDayForecastArray addObject:infoDict];

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

