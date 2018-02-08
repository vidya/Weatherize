//
//  LocationInfo.m
//  Weatherize
//
//  Created by Vidya Sagar on 2/6/18.
//
#import "LocationInfo.h"

@implementation LocationInfo

@synthesize locationManager;

- (id)init {
    self = [super init];
    
    if (self) {
        self.locationManager = [CLLocationManager new];
        
        [self.locationManager setDelegate:self];
        
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestLocation];
        
        CLLocation *location = self.locationManager.location;
        
        self.latitude = location.coordinate.latitude;
        self.longitude = location.coordinate.longitude;
    }
    
    return self;
}

- (LocationInfo*)sharedSingleton {
    static LocationInfo* sharedSingleton;

    if(!sharedSingleton) {
        static dispatch_once_t onceToken;
    
        dispatch_once(&onceToken, ^{
            sharedSingleton = [LocationInfo new];
        });
    }

    return sharedSingleton;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {    
    self.latitude = [locations lastObject].coordinate.latitude;
    self.longitude = [locations lastObject].coordinate.longitude;
                      
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
         fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation: %@", newLocation);
}

@end
