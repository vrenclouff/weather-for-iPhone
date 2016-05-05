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


//  metoda, ktera se vola pri spusteni okna

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

// nastaveni status baru na cernou barvu

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

//  filtruje data pri vyhledavani mesta
//  vyhledavani zacne az po druhem pismenu

- (void)filterContentForSearchText:(NSString *)searchText
{
    if (searchText.length < 2) return;
    searchResults = [[APP_DELEGATE dataHandler] searchCities:searchText];
}

//  prekresleni grafiky

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

//  event na prepinac aktualni lokace

- (IBAction)useCurrentLocation
{
    [Utils saveDataToMem:[NSNumber numberWithBool:[self.currentLocationSwitch isOn]] forKey:LOCATION];
    [[APP_DELEGATE locationHandler] startLocation];
}

//  event na prepinac jednotek teploty

- (IBAction)changeUnitTemperature
{
    [Utils saveDataToMem:[NSNumber numberWithInteger:[self.unitTemperature selectedSegmentIndex]] forKey:DEGREE];
}

#pragma mark --- TABLES SOURCE AND DELEGATE ---

//  delegate pro tabulku - vraci pocet radku v tabulce

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

// delegate pro tabulku - vraci radky v tabulce

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

// delegate pro tabulku - vola se pri vybrani mesta z tabulky

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * city = (NSString *) [[(CityTableCell *)[tableView cellForRowAtIndexPath:indexPath] cityLabel] text];
    [[APP_DELEGATE dataHandler] setActualCity:city];
    [Utils saveDataToMem:@NO forKey:LOCATION];
    [self reloadData];
    
}

#pragma mark --- SEARCHBAR DELEGATE ---

// delegate pro vyhledavaci bar - vola se pri klinuti na vyhledavaci bar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [[self tableAutoComplete] setHidden:NO];
    return YES;
}

//  delegate pro vyhledavaci bar - vola se pri zadavani textu

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText];
    [self.tableAutoComplete reloadData];
    
}

//  delegate pro vyhledavaci bar - vola se pri skrolovani v tabulce

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


@end
