//
//  WeatherAPI.m
//  Weatherize
//
//  Created by Vidya Sagar on 2/6/18.
//

#import "WeatherAPI.h"

@interface WeatherAPI ()
@end

@implementation WeatherAPI

static NSString* const apiKey = @"85bac986e143c41ef673e970154dc7fb";

static NSString* const currentWeather = @"currentWeather";
static NSString* const forecastWeather = @"forecastWeather";

static NSString* const currentWeatherURL = @"https://api.openweathermap.org/data/2.5/weather?";
static NSString* const forecastWeatherURL = @"https://api.openweathermap.org/data/2.5/forecast?";

static NSString* const iconURL = @"https://openweathermap.org/img/w/";

- (id)init {
    self = [super init];
    
    if(self) {
//        self.locationInfo = [LocationInfo new];
    }
    
    return self;
}

- (NSURL *)getURLforWeatherType:(NSString *)weatherTypeID inUnits:(NSString *)temperatureUnits {
    NSString *formatString;
    NSString *query;
    NSString *rawURL;

    if ([weatherTypeID isEqualToString:currentWeather]) {
        formatString = @"lat=%f&lon=%f&units=%@&appid=%@";
        
        query = [NSString stringWithFormat:formatString,
                 self.locationInfo.latitude, self.locationInfo.longitude,
                 temperatureUnits,
                 apiKey];
        
        rawURL = [currentWeatherURL stringByAppendingString: query];
    }
    else {
        formatString = @"lat=%f&lon=%f&units=%@&appid=%@";
        formatString = [@"cnt=5&"  stringByAppendingString:formatString];
        
        query = [NSString stringWithFormat:formatString,
                 self.locationInfo.latitude, self.locationInfo.longitude,
                 temperatureUnits,
                 apiKey];

        rawURL = [forecastWeatherURL stringByAppendingString: query];
    }
    
    NSString *encodedURL = [rawURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"encodedURL: %@", encodedURL);
    
    return [NSURL URLWithString: encodedURL];
}

- (void)queryURL:(NSURL *)url withCompletion:(WeatherCompletionBlock)completion {
    [[[NSURLSession sharedSession]
      dataTaskWithURL:url
      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
          if (!error) {
              NSError *error = nil;
              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              NSLog(@"data: %@", json);

              completion(data);
          }
          else {
              completion(nil);
          }
      }] resume];
}

- (void)getCurrentWeatherInUnits:(NSString*)temperatureUnits withCompletion:(WeatherCompletionBlock)completion {
    NSURL *url = [self getURLforWeatherType:currentWeather inUnits:temperatureUnits];
    
    [self queryURL:url withCompletion:completion];
}

- (void)getForecastWeatherInUnits:(NSString*)temperatureUnits withCompletion:(WeatherCompletionBlock)completion {
    NSURL *url = [self getURLforWeatherType:forecastWeather  inUnits:temperatureUnits];

    [self queryURL:url withCompletion:completion];
}

- (void)getIconWithID:(NSString *)weatherIconID completion:(ImageCompletionBlock)completion;
{
    NSString* iconString = [NSString stringWithFormat:@"%@.png", weatherIconID];
    
    NSString* rawURL = [iconURL stringByAppendingString:iconString];
    NSString *encodedURL = [rawURL
                            stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"encodedURL: %@", encodedURL);
    
    [[[NSURLSession sharedSession]
      dataTaskWithURL:[NSURL URLWithString:encodedURL]
      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            completion(nil, image);
        }
        else {
            completion(error, nil);
        }
    }] resume];
}

@end
