//
//  WeatherTableViewCell.h
//  Weatherize
//
//  Created by Vidya Sagar on 2/7/18.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeatherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@end
