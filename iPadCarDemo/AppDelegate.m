//
//  AppDelegate.m
//  iPadCarDemo
//
//  Created by John Basile on 2/17/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import "AppDelegate.h"


//static const NSTimeInterval askAgainTimeLimit = (60 * 60 * 24) * 7;	// 7 day

NSCalendar *myCalendar = nil;

@implementation AppDelegate
//@synthesize sqlite;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSString	*databaseName;
	
	databaseName = @"Cars.sqlite";
	
	NSArray		*documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString	*documentsDir = [documentPaths objectAtIndex:0];
	
	self.databasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	self.sqlite = [[Sqlite alloc] init];
	
	if (![self.sqlite open:self.databasePath])
		return NO;

    self.logPath = [documentsDir stringByAppendingFormat:@"/SNConsole.log"];
	SNFileLogger *logger = [[SNFileLogger alloc] initWithPathAndSize:self.logPath size:LOGMAXFILESIZE];
	
	[[SNLog logManager] addLogStrategy:logger];

    myCalendar = [NSCalendar currentCalendar];	
	
	
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
	UIImage *imageP = [[UIFactory sharedInstance] navigationBackgroundForBarMetrics:UIBarMetricsDefault];
	UIImage *imageL = [[UIFactory sharedInstance] navigationBackgroundForBarMetrics:UIBarMetricsLandscapePhone];

	
	[navigationBarAppearance setBackgroundImage:imageP forBarMetrics:UIBarMetricsDefault];
	[navigationBarAppearance setBackgroundImage:imageL forBarMetrics:UIBarMetricsLandscapePhone];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
