//
//  TouchesDelegate.h
//  WePublish
//
//  Created by NEO on 10/08/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchesDelegate

@optional
- (void)view:(UIView*)view touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)view:(UIView*)view touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)view:(UIView*)view touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)view:(UIView*)view touchesCanceled:(NSSet*)touches withEvent:(UIEvent*)event;

@end
