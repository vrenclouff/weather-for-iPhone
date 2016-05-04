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

+(void) initialize
{
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    }
}

+(NSString *) stringFromDate: (NSDate *) date usingFormat: (NSString *) format
{
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+(NSDate *) dateFromString: (NSString *) dateString usingFormat: (NSString *) format
{
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateString];
}

+(NSString *)formatDateAsDayMounthNumber:(NSDate *)date
{
    return [self stringFromDate:date usingFormat:@"EEEE, MMMM dd"];
}

+(NSString *)formatDateAsDay: (NSDate *) date
{
    return [self stringFromDate:date usingFormat:@"EEEE"];
}

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

+(NSString *) translateUnit: (id) unit
{
    return [unit boolValue] ? @"metric" : @"imperial";
}

+(NSString *) formatTemperature: (id) temp
{
    if ([temp isKindOfClass:[NSString class]]) return temp;
    return [NSString stringWithFormat:@"%d°", [temp integerValue]];
}

+(NSString *) formatHumidity: (id) humidity
{
    if ([humidity isKindOfClass:[NSString class]]) return [NSString stringWithFormat:@"%% %@", humidity];
    return [NSString stringWithFormat:@"%%%d", [humidity integerValue]];
}

+(NSString *) formatWindSpeed: (id) windSpeed
{
    if ([windSpeed isKindOfClass:[NSString class]]) return [NSString stringWithFormat:@"%@ kph", windSpeed];
    return [NSString stringWithFormat:@"%dkph", [windSpeed integerValue]];
}

+(BOOL) compareDayForSameHour: (NSDate *) date
{
    NSString * hour = [self stringFromDate:date usingFormat:@"HH:mm"];
    return [hour isEqualToString:FIRST_DEFAULT_TIME_IN_DAY] ? YES : ([hour isEqualToString:SECOND_DEFAULT_TIME_IN_DAY] ? YES : NO);
}

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

+(BOOL) compareSameDate: (NSDate *) weatherDate withSecondDate: (NSDate *) nextDate
{
    int days = [self daysBetweenDate:weatherDate andDate:nextDate];
    if (days != 0) return NO;
    BOOL res = [self compareDayForSameHour:weatherDate];
    return res;
}

+(NSDate *) dateFromActualDate: (NSDate *) actualDate toCount: (int) count
{
    NSDate *newDate = [actualDate dateByAddingTimeInterval:60*60*24*count];
    return newDate;
}

+(NSDate *) formatDateFromString: (NSString *) stringDate
{
    return [self dateFromString:stringDate usingFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+(void) saveDataToMem: (id) data forKey: (NSString *) key
{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}

+(id) dataForKey: (NSString *) key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
