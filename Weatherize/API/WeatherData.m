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

- (NSDictionary *)extractWeatherInfo: (NSData *)weatherData {
    NSMutableDictionary *infoDict = [NSMutableDictionary new];
    NSError *error = nil;

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:&error];
    
    NSString *weatherIcon = [[json objectForKey:@"weather"] objectAtIndex:0][@"icon"];
    NSString *temperature = [json objectForKey:@"main"][@"temp"];
    
    infoDict[@"weatherIcon"] = weatherIcon;
    infoDict[@"temperature"] = temperature;

    return infoDict;
}

- (NSArray *)extractWeatherInfoList: (NSData *)weatherData {
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:&error];
    
    NSMutableArray *fiveDayForecastInfo = [NSMutableArray arrayWithCapacity:5];
    
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
        NSMutableArray *fiveDayForecastInfo = [NSMutableArray arrayWithCapacity:5];
        
        NSArray *weatherInfoArray = [self extractWeatherInfoList:weatherData];
        
        for (NSDictionary *weatherInfo in weatherInfoArray) {
            NSDictionary *oneDayWeatherInfo = [self extractWeatherInfo:weatherData];

            [fiveDayForecastInfo addObject:oneDayWeatherInfo];
            
            if ([fiveDayForecastInfo count] == 5) {
                
            }
        }
    }];
}

@end

