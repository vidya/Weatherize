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

- (void)getCurrentWeatherInfoWithCompletion:(InfoCompletionBlock)completion {
    [self.weatherAPI getCurrentWeatherInUnits: @"imperial" withCompletion:^(NSData *weatherData) {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:&error];

        completion(json);
    }];
}

- (void)getFiveDayForecastInfoWithCompletion:(InfoCompletionBlock)completion {
    [self.weatherAPI getForecastWeatherInUnits: @"imperial" withCompletion: ^(NSData *weatherData) {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:&error];
    
        completion(json);
    }];
}

@end

