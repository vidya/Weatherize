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

typedef void (^InfoCompletionBlock)(NSDictionary *information);

- (void)getCurrentWeatherInfoWithCompletion:(InfoCompletionBlock)completion;
- (void)getFiveDayForecastInfoWithCompletion:(InfoCompletionBlock)completion;

@end

