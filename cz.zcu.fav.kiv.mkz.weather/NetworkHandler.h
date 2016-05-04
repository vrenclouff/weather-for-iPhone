//
//  NetworkHandler.h
//  cz.zcu.fav.kiv.mkz.weather
//
//  Created by Lukas Cerny on 27.04.16.
//  Copyright © 2016 MKZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHandler : NSObject

-(void)     sendRequestByURL: (NSString *) url;
-(BOOL)     networkAccess;
-(void)     reloadDataWithActualCity:(NSNumber * )cityID;

@end
