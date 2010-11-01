//
//  WePublishAppDelegate.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/26.
//  Copyright 3di 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WePublishViewController;

@interface WePublishAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WePublishViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WePublishViewController *viewController;

@end

