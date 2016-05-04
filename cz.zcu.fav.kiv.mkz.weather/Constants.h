//
//  Constants.h
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 27.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define DEFAULT_CITY    (NSString *) @"Pilsen"

#define CITY         @"actual_city_name"
#define DEGREE       @"degree"
#define LOCATION     @"location"

#define DAY_NAME     @"day_name"
#define DAY_TEMP     @"day_temp"
#define DAY_TEMP_MAX @"day_temp_max"
#define DAY_IMG      @"day_img"
#define DAY_TIME     @"day_time"
#define DAY_WIND     @"day_wind"
#define DAY_HUMIDITY @"day_humidity"

static NSString * const apiKey = @"3b6d525de7b97bb17cfc898cd72ce4a4";
static NSString * const apiUrl = @"http://api.openweathermap.org/data/2.5/forecast/city";


#endif /* Constants_h */