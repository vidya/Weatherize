//
//  LocationInfo.h
//  Weatherize
//
//  Created by Vidya Sagar  on 2/6/18.
//

#import <CoreLocation/CoreLocation.h>

@interface LocationInfo : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;

+ (LocationInfo*)sharedSingleton;

@end
