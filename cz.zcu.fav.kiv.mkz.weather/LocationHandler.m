//
//  LocationHandler.m
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 01.05.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import "LocationHandler.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Utils.h"

@implementation LocationHandler {
    CLLocationManager *locationManager;
}

-(id) init
{
    self = [super init];
    if (self)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=kCLDistanceFilterNone;
        [locationManager requestWhenInUseAuthorization];
        [locationManager startMonitoringSignificantLocationChanges];
    }
    return self;
}

-(void) startLocation
{
    if ([CLLocationManager locationServicesEnabled])
        [locationManager startUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [locationManager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations firstObject];
    
    if (currentLocation != nil) {
        NSLog(@"Location found.");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChangedByLocation" object:currentLocation];
    } else{
        NSLog(@"Location not found.");
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
 
    if ([[Utils dataForKey:LOCATION] boolValue])
        [APP_DELEGATE showMessage:@"Please enable location service for application" withHeader:@"Error" andButton:@"Ok"];
    
    [Utils saveDataToMem:@NO forKey:LOCATION];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:nil];
}


@end
