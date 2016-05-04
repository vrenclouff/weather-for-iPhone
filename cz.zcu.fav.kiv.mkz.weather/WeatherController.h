//
//  FirstViewController.h
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 04.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *content;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@property (strong, nonatomic) IBOutlet UILabel *actualCity;
@property (strong, nonatomic) IBOutlet UILabel *actualDay;
@property (strong, nonatomic) IBOutlet UILabel *actualTemp;
@property (strong, nonatomic) IBOutlet UIImageView *actualImg;
@property (strong, nonatomic) IBOutlet UILabel *actualWind;
@property (strong, nonatomic) IBOutlet UILabel *actualHumidity;

@property (strong, nonatomic) IBOutlet UIView *cellFirst;
@property (strong, nonatomic) IBOutlet UIView *cellSecond;
@property (strong, nonatomic) IBOutlet UIView *cellThird;
@property (strong, nonatomic) IBOutlet UIView *cellFourth;


-(void) reloadData;

@end

