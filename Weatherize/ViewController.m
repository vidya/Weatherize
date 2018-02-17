//  ViewController.m
//  Weatherize
//
//  Created by Vidya Sagar on 2/6/18.
//
#import "ViewController.h"
#import "WeatherTableViewCell.h"

@interface ViewController ()

@end


@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    
    if (self) {
        self.weatherData = [WeatherData new];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.weatherData getWeatherDataWithCompletion:^(NSDictionary *dataResponse) {
        NSLog(@"-->%@", dataResponse);
        
        self.forecastResponseDict = dataResponse[@"forecastWeather"];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self setCurrentWeatherFromDataResponse:dataResponse[@"currentWeather"]];

            [[self tableView] reloadData];
        });
        
    }];
}

- (void)setCurrentWeatherFromDataResponse: (NSDictionary *)responseDict {
    NSMutableDictionary* weatherProps = [[NSMutableDictionary alloc] init];

    weatherProps[@"weatherIcon"] = responseDict[@"weatherIcon"];
    weatherProps[@"temperature"] = responseDict[@"temperature"];
    
    weatherProps[@"imageView"] = self.headerWeatherIcon;
    weatherProps[@"label"] = self.headerTemperatureLabel;
    
    [self setWeatherWithProps:weatherProps];
}

- (void)setWeatherWithProps: (NSDictionary *)propsDict {
    UIImageView* imageView = propsDict[@"imageView"];
    UILabel* label = propsDict[@"label"];
    
    NSString* icon = propsDict[@"weatherIcon"];
    NSString* temperature = propsDict[@"temperature"];

    WeatherAPI* weatherAPI = [[self weatherData] weatherAPI];
    
    [weatherAPI getIconWithID:icon
                   completion:^(NSError *error, UIImage *image) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [imageView setImage:image];
                           
                           [label setFont:[UIFont systemFontOfSize:16.0]];
                           [label setText:[NSString stringWithFormat:@"%.02f°", [temperature floatValue]]];
                       });
                   }];

}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self forecastResponseDict] count];
}

- (void)setForecastWeatherInCell: (WeatherTableViewCell *)cell FromDataResponse: (NSDictionary *)responseDict {
    NSString* dayName = responseDict[@"dayName"];
    
    [cell.dayLabel setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightBold]];
    [cell.dayLabel setText:dayName];
    
    NSMutableDictionary* weatherProps = [[NSMutableDictionary alloc] init];
    
    weatherProps[@"weatherIcon"] = responseDict[@"weatherIcon"];
    weatherProps[@"temperature"] = responseDict[@"temperature"];
    
    weatherProps[@"imageView"] = cell.weatherIcon;
    weatherProps[@"label"] = cell.temperatureLabel;
    
    [self setWeatherWithProps:weatherProps];
}

- (WeatherTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weatherCell"];
    
    if (cell == nil) {
        cell = [[WeatherTableViewCell new] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weatherCell"];
    }
    
    NSArray* sixDayNames = [self.weatherData theseSixDayNames];
    
    if (indexPath.row < 5) {
        NSString* dayName = sixDayNames[indexPath.row + 1];
        [self setForecastWeatherInCell:cell
                      FromDataResponse:self.forecastResponseDict[dayName]];
    }

    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


