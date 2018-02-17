//  WeatherData.h
//  Weatherize
//
//  Created by Vidya Sagar on 2/6/18.
//

#import <Foundation/Foundation.h>
#import "WeatherAPI.h"

@interface WeatherData : NSObject

@property (strong, nonatomic) WeatherAPI* weatherAPI;
@property (strong, nonatomic) NSArray* theseSixDayNames;

typedef void (^DataFetchCompletionHandler)(NSDictionary *weatherDataArray);

- (void)getWeatherDataWithCompletion:(DataFetchCompletionHandler)completion;

@end

