//
//  WeatherCellView.h
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 27.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCellView : UIView

@property (strong, nonatomic) IBOutlet UILabel      *dayLabel;
@property (strong, nonatomic) IBOutlet UIImageView  *weatherImageView;
@property (strong, nonatomic) IBOutlet UILabel      *tempLabel;

@end
