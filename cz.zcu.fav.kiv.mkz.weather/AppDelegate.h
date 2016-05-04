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

@property (strong, nonatomic) UIWindow * window;

@property (strong, nonatomic) DataHandler * dataHandler;
@property (strong, nonatomic) NetworkHandler * networkHandler;
@property (strong, nonatomic) LocationHandler * locationHandler;


-(void)showMessage:(NSString *)message withHeader:(NSString *) header andButton:(NSString *) button;


@end

