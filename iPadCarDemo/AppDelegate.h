//
//  AppDelegate.h
//  iPadCarDemo
//
//  Created by John Basile on 2/17/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqlite.h"


extern NSCalendar *myCalendar;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
	//Sqlite				*sqlite;
	
}

@property (nonatomic, strong)	UIWindow			*window;
@property (nonatomic, strong)	Sqlite				*sqlite;
@property (nonatomic, strong)	NSString			*databasePath;

@property (nonatomic, strong)	NSString			*logPath;    // applog

@end
