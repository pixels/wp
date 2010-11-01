//
//  WePublishAppDelegate.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/26.
//  Copyright 3di 2010. All rights reserved.
//

#import "WePublishAppDelegate.h"
#import "WePublishViewController.h"
#import "Define.h"

@implementation WePublishAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:APP_FINISH_EVENT object:nil userInfo:nil];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
