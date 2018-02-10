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
    
    LocationInfo *singleton = [LocationInfo sharedSingleton];
    
    if ([weatherTypeID isEqualToString:currentWeather]) {
        formatString = @"lat=%f&lon=%f&units=%@&appid=%@";
        
        query = [NSString stringWithFormat:formatString,
                 singleton.locationManager.location.coordinate.latitude,
                 singleton.locationManager.location.coordinate.longitude,
                 temperatureUnits,
                 apiKey];
        
        rawURL = [currentWeatherURL stringByAppendingString: query];
    }
    else {
        formatString = @"lat=%f&lon=%f&units=%@&appid=%@";
        formatString = [@"cnt=5&"  stringByAppendingString:formatString];
        
        query = [NSString stringWithFormat:formatString,
                 singleton.locationManager.location.coordinate.latitude,
                 singleton.locationManager.location.coordinate.longitude,
                 temperatureUnits,
                 apiKey];
        
        rawURL = [forecastWeatherURL stringByAppendingString: query];
    }
    
    NSString *encodedURL = [rawURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"encodedURL: %@", encodedURL);
    
    return [NSURL URLWithString: encodedURL];
}

- (void)queryURL:(NSURL *)url withCompletion:(APICallCompletionHandler)completion {
    [[[NSURLSession sharedSession]
      dataTaskWithURL:url
      completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *apiCallError) {
          if (apiCallError) {
              completion(nil);
          }
          
          NSError *parseError = nil;
          NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parseError];
          NSLog(@"jsonDict: %@", jsonDict);
          
          if (parseError) {
              completion(nil);
          }
          
          completion(jsonDict);
      }] resume];
}

- (void)getCurrentWeatherInUnits:(NSString*)temperatureUnits withCompletion:(APICallCompletionHandler)completion {
    NSURL *url = [self getURLforWeatherType:currentWeather inUnits:temperatureUnits];
    
    [self queryURL:url withCompletion:completion];
}

- (void)getForecastWeatherInUnits:(NSString*)temperatureUnits withCompletion:(APICallCompletionHandler)completion {
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

