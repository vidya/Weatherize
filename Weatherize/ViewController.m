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
        self.dataResponseArray = [NSMutableArray new];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.weatherData getWeatherDataWithCompletion:^(NSArray *dataResponse) {
        self.dataResponseArray = (NSMutableArray *) dataResponse;        
        NSLog(@"-->%@", self.dataResponseArray);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTemperature:self.dataResponseArray[0][@"temperature"] inLabel:self.headerTemperatureLabel];
            [self setWeatherIcon:self.dataResponseArray[0][@"weatherIcon"] inImageView:self.headerWeatherIcon];
            
            [[self tableView] reloadData];
            
        });

    }];
}

- (void)setTemperature:(NSString *)temperature inLabel:(UILabel *)label {
    dispatch_async(dispatch_get_main_queue(), ^{
        [label setFont:[UIFont systemFontOfSize:16.0]];
        
        [label setText:[NSString stringWithFormat:@"%.02f°", [temperature floatValue]]];
    });
}

- (void)setDayLabel:(NSString *)day inLabel:(UILabel *)label {
    [label setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightBold]];
    [label setText:day];
}

- (void)setWeatherIcon:(NSString *)weatherIcon inImageView:(UIImageView *)imageView {
    [[[self weatherData] weatherAPI] getIconWithID:weatherIcon completion:^(NSError *error, UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:image];
        });
    }];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self dataResponseArray] count];
}

- (WeatherTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weatherCell"];
    
    if (cell == nil) {
        cell = [[WeatherTableViewCell new] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weatherCell"];
    }
    
    NSDictionary *dayDict = self.dataResponseArray[indexPath.row];
    
    int newIndex = 0;
    if (indexPath.row > 4) {
        newIndex = 4;
    }
    else {
        newIndex = indexPath.row;
    }
//    newIndex = indexPath.row;

    NSString *dayName = [self weatherData].nextFiveDayNames[newIndex];

    NSDictionary *tempDict = dayDict;

    NSString *iconID = tempDict[@"weatherIcon"];
    NSString *temperature = tempDict[@"temperature"];

    [self setDayLabel:dayName inLabel:cell.dayLabel];
    [self setWeatherIcon:iconID inImageView:cell.weatherIcon];
    [self setTemperature:temperature inLabel:cell.temperatureLabel];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


