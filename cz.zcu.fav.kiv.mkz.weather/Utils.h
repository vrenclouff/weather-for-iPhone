//
//  Utils.h
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 28.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject


+(NSString *) formatDateAsDayMounthNumber: (NSDate *) date;
+(NSString *) formatDateAsDay: (NSDate *) date;

+(NSDate *)   formatDateFromString: (NSString *) stringDate;

+(NSDate *)   dateFromActualDate: (NSDate *) actualDate toCount: (int) count;
+(NSString *) removeDiacritic: (NSString *) text;

+(NSString *) formatTemperature: (id) temp;
+(NSString *) formatHumidity: (id) humidity;
+(NSString *) formatWindSpeed: (id) windSpeed;


+(BOOL) compareDayForSameHour: (NSDate *) date;
+(BOOL) compareSameDate: (NSDate *) firstDate withSecondDate: (NSDate *) secondDate;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

+(NSString *) translateUnit: (NSNumber* ) unit;
+(void) saveDataToMem: (id) data forKey: (NSString *) key;
+(id)   dataForKey: (NSString *) key;

@end
