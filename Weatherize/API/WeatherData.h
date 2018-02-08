//
//  WeatherData.h
//  Weatherize
//
//  Created by Vidya Sagar on 2/6/18.
//

#import <Foundation/Foundation.h>
#import "WeatherAPI.h"

@interface WeatherData : NSObject

@property (strong, nonatomic) WeatherAPI* weatherAPI;

- (void)getCurrentWeatherInfoWithCompletion:(APICallCompletionHandler)completion;
- (void)getFiveDayForecastInfoWithCompletion:(APICallCompletionHandler)completion;

@end

