//
//  LocationInfo.h
//  Weatherize
//
//  Created by Vidya Sagar on 2/6/18.
//

#import <CoreLocation/CoreLocation.h>

@interface LocationInfo : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;

@property double latitude;
@property double longitude;

@end
