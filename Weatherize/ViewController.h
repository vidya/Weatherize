//  ViewController.h
//  Weatherize
//
//  Created by Vidya Sagar on 2/6/18.
//

#import <UIKit/UIKit.h>
#import "WeatherData.h"

@interface ViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTemperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerWeatherIcon;

@property (strong, nonatomic) WeatherData *weatherData;

@property (strong, nonatomic) NSMutableDictionary *forecastResponseDict;

@end

