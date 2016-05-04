//
//  FileDelegate.h
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 06.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandler : NSObject

-(NSArray *)      searchCities: (NSString *) name;
//-(NSNumber *)     searchCityIDForName: (NSString *) name;
-(NSDictionary *) weatherDataForDay:(NSNumber *)day;

//-(NSNumber *) actualCityID;
//-(NSString *) actualCityName;
-(NSString *) actualCity;

-(void)  setActualCity:(NSString *) city;
//-(void)  setActualCityByName:(NSString *) cityName;
-(void)  dataReceived:(NSDictionary *) data;

-(NSMutableDictionary *) createDefaultData;

@end
