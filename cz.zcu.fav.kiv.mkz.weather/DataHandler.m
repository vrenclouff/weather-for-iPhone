//
//  FileDelegate.m
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 06.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import "DataHandler.h"
#import "Constants.h"
#import "Utils.h"

#define DEFAULT_MARK                (NSString *) @"--"
#define FIRST_DEFAULT_TIME_IN_DAY   (NSString *) @"12:00"
#define SECOND_DEFAULT_TIME_IN_DAY  (NSString *) @"13:00"

@interface DataHandler ()

@end


@implementation DataHandler
{
    NSArray * citiesData;
    NSDictionary * weatherData;
    NSDate * actualDate;
    NSString * actualCity;
    BOOL virtualData;
}


-(id) init {
    self = [super init];
    if (self){
        [self loadCities];
        weatherData = [NSMutableDictionary dictionary];
        actualDate = [[NSDate alloc] init];
        actualCity = [Utils dataForKey:CITY];
    }
    return self;
}

-(void) loadCities {
    
    NSError * error;
    NSLog(@"Start loading data of cities");
    NSString *fileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    citiesData = [fileContents componentsSeparatedByString:@"\n"];
    NSLog(@"Stop loading data of cities");
 
}

-(NSArray *) searchCities: (NSString *) name
{
    if (!name) return [NSArray array];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", name];
    NSArray * filterCities = [citiesData filteredArrayUsingPredicate:predicate];
    return filterCities;
}

-(NSDictionary *) parseRawData: (NSDictionary *) rawData
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    
    if (!rawData) return result;
    int days;
    NSArray * list = [rawData objectForKey:@"list"];
    for (NSDictionary * item in list)
    {
        NSDictionary * main = [item objectForKey:@"main"];
        NSNumber * temp = [main objectForKey:@"temp"];
        NSNumber * temp_max = [main objectForKey:@"temp_max"];
        NSNumber * humidity = [main objectForKey:@"humidity"];
        
        NSArray * weather = [item objectForKey:@"weather"];
        NSString * img = [[weather firstObject] objectForKey:@"icon"];
        
        NSString * dateString = [item objectForKey:@"dt_txt"];
        NSDate * date = [Utils formatDateFromString:dateString];
        
        NSDictionary * wind = [item objectForKey:@"wind"];
        NSNumber * windSpeed = [wind objectForKey:@"speed"];
        
        NSDictionary * dataOfHour = [NSDictionary dictionaryWithObjectsAndKeys:
                                     temp_max, DAY_TEMP_MAX,
                                     temp, DAY_TEMP,
                                     date, DAY_TIME,
                                     img, DAY_IMG,
                                     windSpeed, DAY_WIND,
                                     humidity, DAY_HUMIDITY,
                                     nil];
        
        
        days = [Utils daysBetweenDate:actualDate andDate: date];
        if (([result count] -1) != days) [result setObject:[NSMutableArray array] forKey:[NSNumber numberWithInteger:days]];
        NSMutableArray * item = [result objectForKey:[NSNumber numberWithInteger:days]];
        
        [item addObject:dataOfHour];
    }
    
    return result;
}

-(void) setActualCity:(NSString *) city
{
    if (!city) return;
    actualCity = city;
    [Utils saveDataToMem:city forKey:CITY];
}

-(NSString *) actualCity
{
    return actualCity;
}

-(void) dataReceived:(NSDictionary *) rawData {
    
    NSString * city;
    if (rawData)
    {
        weatherData = [self parseRawData:rawData];
        city = [[rawData objectForKey:@"city"] objectForKey:@"name"];
        virtualData = NO;
    } else
    {
        city = DEFAULT_CITY;
        weatherData = [self createDefaultData];
        virtualData = YES;
    }

    [self setActualCity:city];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataChanged" object:nil];
}

-(NSDictionary *)weatherDataForDay:(NSNumber *)day {
    NSDictionary * result;
    
    if (!virtualData)
    {
        NSArray * dataPerDay = [weatherData objectForKey:day];
        if ([day integerValue] != 0)
        {
            NSInteger count = [dataPerDay count];
            result = [dataPerDay objectAtIndex:count/2+1];
            
        }else
        {
            result = [dataPerDay firstObject];
        }
        
    }else
    {
        result = [weatherData objectForKey:day];
    }
    return result;
}

-(NSMutableDictionary *) createDefaultData
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    
    for(int i = 0; i < 5; i++)
    {
        NSDate * date = [Utils dateFromActualDate:actualDate toCount:i];
        [result setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           DEFAULT_MARK, DAY_TEMP,
                           DEFAULT_MARK, DAY_TEMP_MAX,
                           date, DAY_TIME,
                           DEFAULT_MARK, DAY_IMG,
                           DEFAULT_MARK, DAY_WIND,
                           DEFAULT_MARK, DAY_HUMIDITY,
                           nil]
                forKey:[NSNumber numberWithInteger:i]];
    }
    
    return result;
}

@end
