//
//  NetworkHandler.m
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 27.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import "NetworkHandler.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Utils.h"
#include <unistd.h>
#include <netdb.h>

@implementation NetworkHandler

//  konstruktor, ktery nastavuje posluchace na zmenu mesta
//  CityChanged - posluchac naslouchajici na zmenu mesta podle nazvu
//  CityChangedByLocation - posluchat naslouchajici na zmenu mesta podle GPS souradnic

-(id) init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserverForName:@"CityChanged" object:nil queue:nil usingBlock: ^(NSNotification *notification)
         {
             [self performSelectorOnMainThread:@selector(reloadDataWithActualCity:) withObject:notification.object waitUntilDone:NO];
         }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:@"CityChangedByLocation" object:nil queue:nil usingBlock: ^(NSNotification *notification)
         {
             [self performSelectorOnMainThread:@selector(reloadDataWithLocation:) withObject:notification.object waitUntilDone:NO];
         }];
    }
    return self;
}

//  metoda posilajici dotazy do site
//  obsahuje kontrolu dostupnisti site
//  nastavuje otacejici se kolecko pri sitove aktivite

-(void) sendRequestByURL: (NSString *) url
{
    if (!url) return;
    
    if ([self networkAccess]){
        NSURLSession *session = [NSURLSession sharedSession];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingBar" object:@YES];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [[session dataTaskWithURL: [NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response,  NSError *error) {
                
                NSString * json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary * result = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:[json_string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
                [[APP_DELEGATE dataHandler] dataReceived:result];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingBar" object:@NO];
        
            }] resume];
    }else {
        [[APP_DELEGATE dataHandler] dataReceived:nil];
        [APP_DELEGATE showMessage:@"Please connect to internet" withHeader:@"Error" andButton:@"OK"];
    }
}

// vytvari URL adresu pro nazev mesta

-(void)reloadDataWithActualCity:(NSString * )city
{
    if (!city) return;
    NSString * url = [NSString stringWithFormat:@"%@?APPID=%@&q=%@&units=%@", apiUrl, apiKey, city, [Utils translateUnit:[Utils dataForKey:DEGREE]]];
    [self sendRequestByURL:url];
}

// vytvari URL adresu pro data ziskane z GPS

-(void)reloadDataWithLocation:(CLLocation *) currentLocation
{
    if (!currentLocation) return;
    
    NSString * lognitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    NSString * latitude  = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    
    NSString * url = [NSString stringWithFormat:@"%@?APPID=%@&lat=%@&lon=%@&units=%@", apiUrl, apiKey, latitude, lognitude, [Utils translateUnit:[Utils dataForKey:DEGREE]]];
    [self sendRequestByURL:url];
}

//  kontrola dostupnosti site

-(BOOL)networkAccess
{
    char *hostname;
    struct hostent *hostinfo;
    hostname = "google-public-dns-a.google.com.";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection!\n");
        return NO;
    }
    else{
        NSLog(@"-> connection established!\n");
        return YES;
    }
}



@end
