//
//  WeatherAPI.h
//  Weatherize
//
//  Created by Vidya Sagar on 2/6/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LocationInfo.h"

@interface WeatherAPI : NSObject

@property (strong, nonatomic) NSString* temperatureUnits;
@property (strong, nonatomic) LocationInfo* locationInfo;

- (NSURL *)getURLforWeatherType:(NSString *)weatherTypeID inUnits:(NSString *)temperatureUnits;

typedef void (^WeatherCompletionBlock)(NSData *weatherData);
- (void)queryURL:(NSURL *)url withCompletion:(WeatherCompletionBlock)completion;

- (void)getCurrentWeatherInUnits:(NSString*)temperatureUnits withCompletion:(WeatherCompletionBlock)completion;
- (void)getForecastWeatherInUnits:(NSString*)temperatureUnits withCompletion:(WeatherCompletionBlock)completion;

typedef void (^ImageCompletionBlock)(NSError *error, UIImage *image);
- (void)getIconWithID:(NSString *)weatherIconID completion:(ImageCompletionBlock)completion;

@end
