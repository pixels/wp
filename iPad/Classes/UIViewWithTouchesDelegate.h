//
//  UIViewWithTouchesDelegate.h
//  WePublish
//
//  Created by NEO on 10/08/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchesDelegate.h"

@interface UIViewWithTouchesDelegate : UIView {
  // delegate target
  id<TouchesDelegate> delegate;
}

@property (nonatomic, retain) id delegate;

@end
