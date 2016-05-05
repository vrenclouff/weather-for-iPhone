//
//  AppDelegate.h
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 04.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHandler.h"
#import "NetworkHandler.h"
#import "LocationHandler.h"
#import "Utils.h"
#import "Constants.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

// instance hlavni obrazovky
@property (strong, nonatomic) UIWindow * window;

// instance tridy pro praci s daty
@property (strong, nonatomic) DataHandler * dataHandler;

// instance tridy pro praci se siti
@property (strong, nonatomic) NetworkHandler * networkHandler;

// instance tridy pro praci s loklaizaci
@property (strong, nonatomic) LocationHandler * locationHandler;

//
//  metoda pro vyvolani hlasky
//  @message - zprava
//  @header  - hlavicka zpravy
//  @button  - text na telacitku

-(void)showMessage:(NSString *)message withHeader:(NSString *) header andButton:(NSString *) button;


@end

