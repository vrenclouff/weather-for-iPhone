//
//  FirstViewController.m
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 04.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import "WeatherController.h"
#import "WeatherCellView.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Utils.h"


@implementation WeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:NO];
    
    [self refreshCity];
        
    [[NSNotificationCenter defaultCenter] addObserverForName:@"DataChanged" object:nil queue:nil usingBlock: ^(NSNotification *notification)
    {
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"LoadingBar" object:nil queue:nil usingBlock: ^(NSNotification *notification)
     {
         [self performSelectorOnMainThread:@selector(loadingBar:) withObject:notification.object waitUntilDone:NO];
     }];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self refreshCity];
}


-(void) loadingBar: (NSNumber *) on
{
    if (!on) return;
    
    if ([on boolValue])
    {
        [self.content setAlpha:0.3];
        [self.content setUserInteractionEnabled: NO];
        [self.loading startAnimating];
    }else
    {
        [self.content setAlpha:1];
        [self.content setUserInteractionEnabled: YES];
        [self.loading stopAnimating];
    }
}

-(void)reloadData
{
    DataHandler * dataHandler = [APP_DELEGATE dataHandler];
    
    NSDictionary * actual = [dataHandler weatherDataForDay:@0];
    
    [[self actualCity] setText:[dataHandler actualCity]];
    [[self actualTemp] setText:[Utils formatTemperature:[actual objectForKey:DAY_TEMP]]];
    [[self actualDay] setText: [Utils formatDateAsDayMounthNumber: [actual objectForKey:DAY_TIME]]];
    [[self actualImg] setImage:[UIImage imageNamed:[actual objectForKey:DAY_IMG]]];
    [[self actualHumidity] setText:[Utils formatHumidity:[actual objectForKey:DAY_HUMIDITY]]];
    [[self actualWind] setText:[Utils formatWindSpeed: [actual objectForKey:DAY_WIND]]];
    
    [self fillView:[self cellFirst]  withData: [dataHandler weatherDataForDay: @1]];
    [self fillView:[self cellSecond] withData: [dataHandler weatherDataForDay: @2]];
    [self fillView:[self cellThird]  withData: [dataHandler weatherDataForDay: @3]];
    [self fillView:[self cellFourth] withData: [dataHandler weatherDataForDay: @4]];
}

-(void) fillView:(UIView *) view withData:(NSDictionary *) data
{
    
    [view.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    WeatherCellView *contentView = (WeatherCellView *)[[[NSBundle mainBundle] loadNibNamed:@"WeatherCellView" owner:self options:nil] objectAtIndex:0];
    
    [[contentView dayLabel] setText:[Utils formatDateAsDay:[data objectForKey:DAY_TIME]]];
    [[contentView tempLabel] setText:[Utils formatTemperature:[data objectForKey:DAY_TEMP_MAX]]];
    [[contentView weatherImageView] setImage:[UIImage imageNamed:[data objectForKey:DAY_IMG]]];
    
    [contentView setFrame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [view addSubview:contentView];
    
}

#pragma mark --- BUTTON DELEGATE ---

-(IBAction)refreshCity
{
    if ([[Utils dataForKey:LOCATION] boolValue]) {
        [[APP_DELEGATE locationHandler] startLocation];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:[[APP_DELEGATE dataHandler] actualCity]];
    }
}


@end
