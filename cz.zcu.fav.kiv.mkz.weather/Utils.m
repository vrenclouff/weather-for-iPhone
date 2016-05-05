//
//  Utils.m
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 28.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import "Utils.h"

#define FIRST_DEFAULT_TIME_IN_DAY   (NSString *) @"12:00"
#define SECOND_DEFAULT_TIME_IN_DAY  (NSString *) @"13:00"

NSDateFormatter *dateFormatter;
@implementation Utils

//  staticky blok
//  initializuje dateFormatter a nastavuje na locale

+(void) initialize
{
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    }
}

//  prevadi datum na retezec podle zvoleneho formatu

+(NSString *) stringFromDate: (NSDate *) date usingFormat: (NSString *) format
{
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

//  prevadi retezec na datum podle zvoleneho formatu

+(NSDate *) dateFromString: (NSString *) dateString usingFormat: (NSString *) format
{
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateString];
}

// prevadi datum na retezec ve formatu: Name of day, Month day

+(NSString *)formatDateAsDayMounthNumber:(NSDate *)date
{
    return [self stringFromDate:date usingFormat:@"EEEE, MMMM dd"];
}

// prevadi tavum an retezec ve formatu: Name of day

+(NSString *)formatDateAsDay: (NSDate *) date
{
    return [self stringFromDate:date usingFormat:@"EEEE"];
}

//  odstranuje diakritiku 

+(NSString *) removeDiacritic: (NSString *) text
{
    static NSString * diacritics =        @"ÁÄČÇĎÉĚËÍŇÓÖŘŠŤÚŮÜÝŽáäčçďéěëíňóöřšťúůüýž";
    static NSString * withoutDiacritics = @"AACCDEEEINOORSTUUUYZaaccdeeeinoorstuuuyz";
    
    NSString * item;
    NSMutableString * result = [NSMutableString string];
    for(int i = 0; i < text.length; i++){
        item = [text substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [diacritics rangeOfString:item];
        if (range.location != NSNotFound && range.length > 0) item = [withoutDiacritics substringWithRange:NSMakeRange(range.location, 1)];
        [result appendString:item];
    }
    return result;
}

// preklada zvolenou volbu jednotek teploty na text

+(NSString *) translateUnit: (id) unit
{
    return [unit boolValue] ? @"metric" : @"imperial";
}

//  formatuje teplotu

+(NSString *) formatTemperature: (id) temp
{
    if ([temp isKindOfClass:[NSString class]]) return temp;
    return [NSString stringWithFormat:@"%d°", [temp integerValue]];
}

// formatuje vlhkost

+(NSString *) formatHumidity: (id) humidity
{
    if ([humidity isKindOfClass:[NSString class]]) return [NSString stringWithFormat:@"%% %@", humidity];
    return [NSString stringWithFormat:@"%%%d", [humidity integerValue]];
}

// formatuje rychlost vetru

+(NSString *) formatWindSpeed: (id) windSpeed
{
    if ([windSpeed isKindOfClass:[NSString class]]) return [NSString stringWithFormat:@"%@ kph", windSpeed];
    return [NSString stringWithFormat:@"%dkph", [windSpeed integerValue]];
}

//  vraci pocet dnu mezi dvema datumy

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

// vraci den o count pocet dnu

+(NSDate *) dateFromActualDate: (NSDate *) actualDate toCount: (int) count
{
    NSDate *newDate = [actualDate dateByAddingTimeInterval:60*60*24*count];
    return newDate;
}

// vytvari datum z retezce ve formatu: rok-mesic-den hodina:minuta:sekunda

+(NSDate *) formatDateFromString: (NSString *) stringDate
{
    return [self dateFromString:stringDate usingFormat:@"yyyy-MM-dd HH:mm:ss"];
}

// uklada data do vnitrniho uloziste telefonu podle zvoleneho klice

+(void) saveDataToMem: (id) data forKey: (NSString *) key
{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}

// vraci data z vnitrniho uloziste telefonu podle zvoleneho klice

+(id) dataForKey: (NSString *) key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
