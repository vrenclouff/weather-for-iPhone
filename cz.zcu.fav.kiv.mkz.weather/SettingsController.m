//
//  SecondViewController.m
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 04.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import "SettingsController.h"
#import "AppDelegate.h"
#import "CityTableCell.h"
#import "Constants.h"

@implementation SettingsController {
    NSArray * searchResults;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"DataChanged" object:nil queue:nil usingBlock: ^(NSNotification *notification)
     {
         [self performSelectorOnMainThread:@selector(reloadData) withObject: nil waitUntilDone:NO];
     }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"CityChanged" object:nil queue:nil usingBlock: ^(NSNotification *notification)
     {
         [self performSelectorOnMainThread:@selector(reloadData) withObject: nil waitUntilDone:NO];
     }];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)filterContentForSearchText:(NSString *)searchText
{
    if (searchText.length < 2) return;
    searchResults = [[APP_DELEGATE dataHandler] searchCities:searchText];
}

- (void) reloadData
{
    [[self searchBar] setText:@""];
    [[self searchBar] resignFirstResponder];
    [self.unitTemperature setSelectedSegmentIndex:[[Utils dataForKey:DEGREE] integerValue]];
    [self.currentLocationSwitch setOn:[[Utils dataForKey:LOCATION] boolValue]];
    [self.actualCity setText:[[APP_DELEGATE dataHandler] actualCity]];
    [self.tableAutoComplete setHidden:YES];
    
}

#pragma mark --- BUTTON DELEGATE ---

- (IBAction)useCurrentLocation
{
    [Utils saveDataToMem:[NSNumber numberWithBool:[self.currentLocationSwitch isOn]] forKey:LOCATION];
    [[APP_DELEGATE locationHandler] startLocation];
}

- (IBAction)changeUnitTemperature
{
    [Utils saveDataToMem:[NSNumber numberWithInteger:[self.unitTemperature selectedSegmentIndex]] forKey:DEGREE];
}

#pragma mark --- TABLES SOURCE AND DELEGATE ---

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityTableCell";
    CityTableCell * cell = (CityTableCell *)[self.tableAutoComplete dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CityTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString * city = [searchResults objectAtIndex:[indexPath item]];
    cell.cityLabel.text = city;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * city = (NSString *) [[(CityTableCell *)[tableView cellForRowAtIndexPath:indexPath] cityLabel] text];
    [[APP_DELEGATE dataHandler] setActualCity:city];
    [Utils saveDataToMem:@NO forKey:LOCATION];
    [self reloadData];
    
}

#pragma mark --- SEARCHBAR DELEGATE ---

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [[self tableAutoComplete] setHidden:NO];
    return YES;
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText];
    [self.tableAutoComplete reloadData];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


@end
