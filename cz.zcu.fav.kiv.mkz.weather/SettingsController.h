//
//  SecondViewController.h
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 04.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *unitTemperature;
@property (weak, nonatomic) IBOutlet UISwitch *currentLocationSwitch;
@property (weak, nonatomic) IBOutlet UILabel *actualCity;
@property (strong, nonatomic) IBOutlet UITableView *tableAutoComplete;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

