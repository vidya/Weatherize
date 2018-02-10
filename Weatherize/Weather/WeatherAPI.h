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
@property (strong, nonatomic) NSMutableDictionary* iconCache;

@property (strong, nonatomic) LocationInfo* locationInfo;

typedef void (^APICallCompletionHandler)(NSDictionary *jsonDict);
typedef void (^NewAPICallCompletionHandler)(NSArray *weatherDataArray);

- (void)getCurrentWeatherInUnits:(NSString*)temperatureUnits withCompletion:(APICallCompletionHandler)completion;
- (void)getForecastWeatherInUnits:(NSString*)temperatureUnits withCompletion:(APICallCompletionHandler)completion;

typedef void (^ImageCompletionBlock)(NSError *error, UIImage *image);
- (void)getIconWithID:(NSString *)weatherIconID completion:(ImageCompletionBlock)completion;

@end
