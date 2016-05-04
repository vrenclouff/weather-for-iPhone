//
//  LocationHandler.h
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 01.05.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationHandler : NSObject <CLLocationManagerDelegate>

-(void) startLocation;

@end
